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

#This Script Delete EKS Cluster, AWS Keypair and pem files
#Delete CloudFormation Template

source eks.conf

#Delete Cluster
echo "******* Delete Cluster ********"
eksctl delete cluster --name=$cluster_name --region=$region_var
echo "the cluster will be deleted in 20 minutes, check AWS EKS Console to confirm."
#Delete Keypair
echo ""
echo "******* Delete Keypair ******* "
aws ec2 delete-key-pair --key-name $keypair_var
rm -Rf "$HOME/$keypair_var".pem $HOME/kubeconfig.eks.yaml
echo "Done."