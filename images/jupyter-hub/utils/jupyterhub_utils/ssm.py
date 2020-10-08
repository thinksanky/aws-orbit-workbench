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

import os
from typing import Any, Dict, cast

import boto3
import yaml

BOTO3_SESSION: boto3.Session = boto3.Session()
ENV_NAME: str = os.environ["ENV_NAME"]


def read_manifest_ssm() -> Dict[str, Any]:
    client = boto3.client(service_name="ssm")
    yaml_str: str = client.get_parameter(Name=f"/datamaker/{ENV_NAME}/manifest")["Parameter"]["Value"]
    return cast(Dict[str, Any], yaml.safe_load(yaml_str))


MANIFEST: Dict[str, Any] = read_manifest_ssm()
REGION: str = MANIFEST["region"]
ACCOUNT_ID: str = MANIFEST["account-id"]
COGNITO_USER_POOL_ID: str = MANIFEST["user-pool-id"]
