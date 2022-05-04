# SuperOrbital: aws-eks-blueprint-examples

<details>
  <summary>Table of Contents</summary>

- [SuperOrbital: aws-eks-blueprint-examples](#superorbital-aws-eks-blueprint-examples)
  - [Overview](#overview)
  - [Preparation](#preparation)
    - [Terraform](#terraform)
      - [Order of Operations](#order-of-operations)
    - [AWS Authentication](#aws-authentication)
    - [ArgoCD](#argocd)
    - [Addons (via ArgoCD)](#addons-via-argocd)
      - [Kubernetes Dashboard](#kubernetes-dashboard)
      - [Prometheus](#prometheus)
    - [Workloads (via ArgoCD)](#workloads-via-argocd)
      - [Team Riker (Guestbook)](#team-riker-guestbook)
      - [Team Burnham (Nginx)](#team-burnham-nginx)
      - [Team Carmen (Geolocation API)](#team-carmen-geolocation-api)
  - [Troubleshooting](#troubleshooting)
    - [EKS Issues](#eks-issues)
    - [Terraform Issues](#terraform-issues)

</details>

## Overview

- AWS EKS Blueprint examples using Terraform

**Note: These are examples**. They are intended to be used as a starting point for creating your own infrastructure, but you should not deploy this into a live environment without understanding it and configuring it for your requirements.

## Preparation

### Terraform

- The AWS EKS blueprint modules use a few experimental `terraform` features. Terraform will produce a warning that makes this clear to the user.
- For simplicity sake within this repo, we are using various `*.auto.tfvars` files to provide some global variables to multiple underlying directories. [Hashicorp prefers that you define `TF_VAR_*` environment variables for this purpose instead](https://github.com/hashicorp/terraform/issues/22004). Because of this you will see some warnings from `terraform` about unused variables, you can make them a much less noisy, by passing adding the `-compact-warnings` argument to your `terraform` commands.

#### Order of Operations

You should `terraform init`, `plan` and `apply` the directories in the following order when you first spin everything up:

1. `accounts/sandbox/network/primary` (_~2+ minutes_)
2. `accounts/sandbox/eks/poc` (_~30+ minutes_)
3. `accounts/sandbox/k8s/poc` (_~20+ minutes_)

Then you can authenticate with the ArgoCD UI and experiment with the cluster.

### AWS Authentication

By default, the terraform code in this repo expects you to have an AWS profile called `sandbox` defined in your `~/.aws/credentials` file.

```console
$ aws --profile=sandbox eks update-kubeconfig --region us-west-2 --name the-a-team-sbox-poc-eks
Added new context arn:aws:eks:us-west-2:000000000000:cluster/the-a-team-sbox-poc-eks to ~/.kube/config

$ kubectl get all -A
...
```

### ArgoCD

Ideally, you should pass in a pre-made ArgoCD password, but for the moment, you can connect and authenticate to ArgoCD using the default admin password:

- Get default the ArgoCD admin password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

- Forward a local port to the ArgoCD Server service

```bash
kubectl port-forward -n argocd svc/argo-cd-argocd-server 8080:443
```

- Open up a web browser and navigate to:
  - <https://127.0.0.1:8080/>
    - **username**: admin
    - **password**: _see previous command above to get this value_

### Addons (via ArgoCD)

#### Kubernetes Dashboard

- Forward a local port to the Kubernetes Dashboard service

```bash
kubectl port-forward -n kube-system svc/kubernetes-dashboard 8081:443
```

- Grab a current valid token for the cluster.
  - If you have `jq` installed locally you can use the output from:
    - `aws --profile=sandbox eks get-token --cluster-name the-a-team-sbox-poc-eks | jq -r '.["status"]["token"]'`
  - If not, you can use the token value from this command:
    - `aws --profile=sandbox eks get-token --cluster-name the-a-team-sbox-poc-eks`
  
- Open up a web browser and navigate to:
  - <https://127.0.0.1:8081/>

- To authenticate select token, and provide the token from the previous command.

#### Prometheus

- Forward a local port to the Prometheus Server service

```bash
kubectl port-forward -n prometheus svc/prometheus-server 8082:80
```

- Open up a web browser and navigate to:
  - <http://127.0.0.1:8082/>

### Workloads (via ArgoCD)

#### Team Riker (Guestbook)

- Forward a local port to the Guestbook UI service

```bash
kubectl port-forward -n team-riker svc/guestbook-ui 8090:80
```

- Open up a web browser and navigate to:
  - <http://127.0.0.1:8090/>

#### Team Burnham (Nginx)

- Forward a local port to the Nginx service

```bash
kubectl port-forward -n team-burnham svc/nginx 8091:80
```

- Open up a web browser and navigate to:
  - <http://127.0.0.1:8091/>

#### Team Carmen (Geolocation API)

- Forward a local port to the Nginx service

```bash
kubectl port-forward -n geolocationapi svc/geolocationapi 8092:5000
```

- Open up a web browser and navigate to:
  - <http://127.0.0.1:8092/api/v1/GeoLocation/42.42.42.42>
- or run: `curl -X GET "http://127.0.0.1:8092/api/v1/GeoLocation/42.42.42.42"`

- **See**: <https://github.com/CarmenAPuccio/GeoLocationAPI>

## Troubleshooting

### EKS Issues

- `My worker nodes are not joining the cluster.`
  - **Cause**
    - There are various reasons that this can happen, but some of the most likely reasons for this issue, are:
      - The subnets that contain the EC2 instances do not have internet access.
      - The user-data script failed to run properly.
        - This can sometimes manifest as nodes that have successfully joined the Kubernetes cluster, because the bootstrap.sh script in the `user-data` ran successfully, but the node group still reports `Create failed`, because the something else in the user-data script produced an error.
  - **Solution**
    - Make sure that you EC2 instances can reach the `eks.amazonaws.com` endpoints.
    - Make sure that the `user-data` script is not erroring out on the node and that the bootstrap script is run last (and only once).

### Terraform Issues

- `Error: error creating EKS Add-On (*): InvalidParameterException: Addon version specified is not supported`
  - **Cause**
    - This means that you are trying to install a version of the EKS addon that is not compatible with the version of k8s that you are using in the EKS cluster.
  - **Solution**
    - Determine what versions of the EKS addon are available by running `aws eks describe-addon-versions` and then add an appropriate config block for that addon.
    - _e.g._

    ```hcl
    amazon_eks_coredns_config    = {
      // We need an older version since we aren't using the latest EKS k8s version
      addon_version              = "v1.8.3-eksbuild.1"
    }
    ```

- `Error: Get "http://localhost/api/v1/namespaces/kube-system/configmaps/aws-auth": dial tcp 127.0.0.1:80: connect: connection refused`
  - **Cause**
    - This typically occurs if the EKS cluster fails to come up fully (_e.g._ The worker nodes fail to connect to the cluster) or if the EKS cluster is deleted without Terraform's knowledge.
  - **Solution**
    - Run `terraform state rm module.eks_blueprints.kubernetes_config_map.aws_auth[0]` from appropriate terraform directory.
