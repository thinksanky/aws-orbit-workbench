#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License").
#    You may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

import logging
import os
import time
from datetime import datetime
from typing import Tuple

import boto3
import botocore.exceptions

from datamaker_cli.utils import does_cfn_exist

CHANGESET_PREFIX = "aws-datamaker-cli-deploy-"

_logger: logging.Logger = logging.getLogger(__name__)


def _wait_for_changeset(changeset_id: str, stack_name: str) -> bool:
    waiter = boto3.client("cloudformation").get_waiter("change_set_create_complete")
    waiter_config = {"Delay": 1}
    try:
        waiter.wait(ChangeSetName=changeset_id, StackName=stack_name, WaiterConfig=waiter_config)
    except botocore.exceptions.WaiterError as ex:
        resp = ex.last_response
        status = resp["Status"]
        reason = resp["StatusReason"]
        if (
            status == "FAILED"
            and "The submitted information didn't contain changes." in reason
            or "No updates are to be performed" in reason
        ):
            _logger.debug(f"No changes for {stack_name} CloudFormation stack.")
            return False
        raise RuntimeError(f"Failed to create the changeset: {ex}. Status: {status}. Reason: {reason}")
    return True


def _create_changeset(stack_name: str, template_str: str, env_tag: str) -> Tuple[str, str]:
    now = datetime.utcnow().isoformat()
    description = f"Created by AWS DataMaker CLI at {now} UTC"
    changeset_name = CHANGESET_PREFIX + str(int(time.time()))
    changeset_type = "UPDATE" if does_cfn_exist(stack_name=stack_name) else "CREATE"
    kwargs = {
        "ChangeSetName": changeset_name,
        "StackName": stack_name,
        "TemplateBody": template_str,
        "ChangeSetType": changeset_type,
        "Capabilities": ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"],
        "Description": description,
        "Tags": ({"Key": "Env", "Value": env_tag},),
    }
    resp = boto3.client("cloudformation").create_change_set(**kwargs)
    return str(resp["Id"]), changeset_type


def _execute_changeset(changeset_id: str, stack_name: str) -> None:
    boto3.client("cloudformation").execute_change_set(ChangeSetName=changeset_id, StackName=stack_name)


def _wait_for_execute(stack_name: str, changeset_type: str) -> None:
    if changeset_type == "CREATE":
        waiter = boto3.client("cloudformation").get_waiter("stack_create_complete")
    elif changeset_type == "UPDATE":
        waiter = boto3.client("cloudformation").get_waiter("stack_update_complete")
    else:
        raise RuntimeError(f"Invalid changeset type {changeset_type}")
    waiter_config = {
        "Delay": 5,
        "MaxAttempts": 480,
    }
    waiter.wait(StackName=stack_name, WaiterConfig=waiter_config)


def deploy_template(stack_name: str, filename: str, env_tag: str) -> None:
    if not os.path.isfile(filename):
        raise FileNotFoundError(f"CloudFormation template not found at {filename}")
    template_size = os.path.getsize(filename)
    if template_size > 51_200:
        raise RuntimeError(f"The CloudFormation template ({filename}) is too big to be deployed w/o an s3 bucket.")
    with open(filename, "r") as handle:
        template_str = handle.read()
    changeset_id, changeset_type = _create_changeset(stack_name=stack_name, template_str=template_str, env_tag=env_tag)
    has_changes = _wait_for_changeset(changeset_id, stack_name)
    if has_changes:
        _execute_changeset(changeset_id=changeset_id, stack_name=stack_name)
        _wait_for_execute(stack_name, changeset_type)


def destroy_stack(stack_name: str) -> None:
    client = boto3.client("cloudformation")
    client.delete_stack(StackName=stack_name)
    waiter = client.get_waiter("stack_delete_complete")
    waiter.wait(StackName=stack_name, WaiterConfig={"Delay": 5, "MaxAttempts": 200})
