#!/bin/bash
set -e
set -x

terraform init
terraform apply --auto-approve

INSTANCE_ID=$(terraform output -raw instance_id)
INSTANCE_IP=$(terraform output -raw instance_ip)

aws ec2 wait instance-status-ok --instance-ids "$INSTANCE_ID"
scp -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ubuntu@"$INSTANCE_IP":/etc/rancher/k3s/k3s.yaml ./kubeconfig.yaml
sed -i '' "s/127.0.0.1/$INSTANCE_IP/g" ./kubeconfig.yaml
kubectl get nodes -o wide --kubeconfig=./kubeconfig.yaml
