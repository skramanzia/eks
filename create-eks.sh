#!/usr/bin/env bash

# Copyright 2019 VR4. All Rights Reserved.
#
# https://www.vr4it.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Created By: Nicolás Alfonso
# Date: 2 Aug 2019

#This Script Create EKS Cluster, AWS Keypair and pem files
#Use CloudFormation Template

source eks.conf

echo Download the kubectl and heptio-authenticator-aws
mkdir ~/bin
wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/kubectl && chmod +x kubectl && mv kubectl ~/bin/
wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws && chmod +x heptio-authenticator-aws && mv heptio-authenticator-aws ~/bin/

echo Download eksctl from eksctl.io
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

echo Create a keypair
cd ~
aws ec2 create-key-pair --key-name $keypair_var --region $region_var --query 'KeyMaterial' --output text > "$keypair_var".pem
chmod 400 "$keypair_var".pem
sleep 10

cd ~
if [ $region_var == "us-east-1" ]; then
    eksctl create cluster --node-private-networking --ssh-access --ssh-public-key $keypair_var --name $cluster_name --region $region_var --node-type $node_type --node-volume-size 200 --kubeconfig=./kubeconfig.eks.yaml --zones=us-east-1a,us-east-1b,us-east-1d
else
    eksctl create cluster --node-private-networking --ssh-access --ssh-public-key $keypair_var --name $cluster_name --region $region_var --node-type $node_type --node-volume-size 200 --kubeconfig=./kubeconfig.eks.yaml
fi

echo 'export KUBECONFIG=$KUBECONFIG:$HOME/kubeconfig.eks.yaml' >> ~/.bashrc

echo installing jq
sudo yum -y install jq

echo "*********************************"
echo "************ FINISH *************"
echo "*********************************"
echo ""
echo "Cluster Name -> $cluster_name"
echo "KeyPair -> $keypair_var"