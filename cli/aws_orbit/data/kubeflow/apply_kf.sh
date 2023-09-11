#!/usr/bin/env bash
#
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#   Licensed under the Apache License, Version 2.0 (the "License").
#   You may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

set -ex
export AWS_CLUSTER_NAME=${cluster_name}
export CLUSTER_NAME=${cluster_name}
export CLUSTER_REGION="us-east-1"

apt update

apt install git curl unzip tar make sudo vim wget -y


# eksctl create cluster \
# --name ${CLUSTER_NAME} \
# --version 1.22 \
# --region ${CLUSTER_REGION} \
# --nodegroup-name demo-nodes \
# --node-type m5.xlarge \
# --nodes 5 \
# --nodes-min 5 \
# --nodes-max 10 \
# --managed \
# --with-oidc

# export KUBEFLOW_RELEASE_VERSION=v1.6.1
# export AWS_RELEASE_VERSION=v1.6.1-aws-b1.0.2

export KUBEFLOW_RELEASE_VERSION=v1.7.0
export AWS_RELEASE_VERSION=v1.7.0-aws-b1.0.3
git clone https://github.com/awslabs/kubeflow-manifests.git && cd kubeflow-manifests
git checkout ${AWS_RELEASE_VERSION}
git clone --branch ${KUBEFLOW_RELEASE_VERSION} https://github.com/kubeflow/manifests.git upstream


# wget https://github.com/kubeflow/kfctl/releases/download/v1.2.0/kfctl_v1.2.0-0-gbc038f9_linux.tar.gz
# tar -xvf kfctl_v1.2.0-0-gbc038f9_linux.tar.gz

make install-tools

# NOTE: If you have other versions of python installed 
# then make sure the default is set to python3.8
# alias python=python3.8

aws sts get-caller-identity

# chmod +x ./kfctl

# which kfctl

# kfctl version

# ./kfctl apply -V -f kfctl_aws.yaml


# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip -o -q awscliv2.zip
# sudo ./aws/install --update
# rm -r ./aws
# aws --version

# curl --silent --location "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.0.1/kustomize_v5.0.1_linux_amd64.tar.gz" | tar xz -C /tmp
# chmod +x /tmp/kustomize
# sudo mv /tmp/kustomize /usr/bin/kustomize
# kustomize version

# curl --silent --location "https://github.com/mikefarah/yq/releases/download/v4.26.1/yq_linux_amd64.tar.gz" | tar xz -C /tmp
# sudo mv /tmp/yq_linux_amd64 /usr/bin/yq
# rm /tmp/install-man-page.sh
# rm /tmp/yq.1
# sudo apt-get install jq -y

# curl "https://releases.hashicorp.com/terraform/1.4.5/terraform_1.4.5_linux_amd64.zip" -o "terraform.zip"
# unzip -o -q terraform.zip
# sudo install -o root -g root -m 0755 terraform /usr/local/bin/terraform
# rm terraform.zip
# rm terraform
# terraform --version


# wget https://get.helm.sh/helm-v3.12.3-linux-amd64.tar.gz
# tar -xvf helm-v3.12.3-linux-amd64.tar.gz
# sudo mv linux-amd64/helm /usr/local/bin
# rm helm-v3.12.3-linux-amd64.tar.gz
# rm -rf linux-amd64
# helm version

# echo "*** Deploying AWS Kubeflow Vanilla ****"

# python --version
# pip --version

# pip install pyyaml

# alias kubectl=$HOME/bin/kubectl

# which kubectl

# curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.17/2023-08-16/bin/linux/amd64/kubectl
# curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.17/2023-08-16/bin/linux/amd64/kubectl.sha256

# curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.26.7/2023-08-16/bin/linux/amd64/kubectl
# curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.26.7/2023-08-16/bin/linux/amd64/kubectl.sha256

# curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.4/2023-08-16/bin/linux/amd64/kubectl
# curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.27.4/2023-08-16/bin/linux/amd64/kubectl.sha256

# curl -LO "https://dl.k8s.io/release/v1.25.0/bin/linux/amd64/kubectl"
# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# rm kubectl
# kubectl version --client

# sha256sum -c kubectl.sha256

# chmod +x kubectl
# mv ./kubectl /usr/local/bin/kubectl

# export PATH=/usr/local/bin/kubectl:$PATH

# kubectl version --client

# kubectl delete -n cert-manager deployment cert-manager cert-manager-cainjector cert-manager-webhook

## Cannot run this command. 
## Need to fix this: Error: failed to create addon "aws-ebs-csi-driver": operation error EKS: CreateAddon, https response error StatusCode: 403, RequestID: 6c54c4c9-e283-40da-b3bb-d809ff4de0dd, api error AccessDeniedException: User: arn:aws:sts::451404659786:assumed-role/orbit-sky-orbit-env-us-east-1-admin/AWSCodeBuild-4af8face-9c03-4b78-9f69-f7937b427d7c is not authorized to perform: iam:PassRole on resource: arn:aws:iam::451404659786:role/AmazonEKS_EBS_CSI_DriverRole
 #eksctl create addon --name aws-ebs-csi-driver --cluster ${AWS_CLUSTER_NAME} --service-account-role-arn arn:aws:iam::451404659786:role/AmazonEKS_EBS_CSI_DriverRole --force

make deploy-kubeflow INSTALLATION_OPTION=kustomize
