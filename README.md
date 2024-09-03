Terraform configuration and scripts for provisioning a single-node [k3s](https://k3s.io/) cluster on an AWS EC2 instance.

## Prerequisites

- make
- terraform
- AWS CLI v2
- scp
- sed
- kubectl

## Usage

### Provision the infrastructure

```shell
make up
```

### Access the cluster

```shell
kubectl get nodes -o wide --kubeconfig=./kubeconfig.yaml
```

### Teardown the infrastructure

```shell
make down
```
