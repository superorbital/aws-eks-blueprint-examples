// The docs for individual addons (confguring. updating, etc) can be found here:
// https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/docs/add-ons/index.md
//
module "k8s-addons" {
  source  = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=34921232356fb69b5a41094246d488c37c596d97"

  eks_cluster_id               = local.eks_cluster_id
  eks_worker_security_group_id = local.eks_worker_security_group_id

  // ----EKS Managed Add-ons----
  //
  // See: `aws eks describe-addon-versions`
  //

  enable_amazon_eks_coredns    = true
  amazon_eks_coredns_config    = {
    // We might need an older version of some of these EKS addons,
    // if we weren't using the latest EKS k8s version
    //addon_version              = "v1.8.3-eksbuild.1"
  }
  
  enable_amazon_eks_kube_proxy = true
  enable_amazon_eks_vpc_cni    = true

  // ----K8s Add-ons----

  enable_argocd                       = true
  argocd_helm_config = {
    version          = "4.5.4"
    // ArgoCD upstream Helm values file:
    // https://github.com/argoproj/argo-helm/blob/master/charts/argo-cd/values.yaml
    values           = [templatefile("${path.module}/helm_values/argocd-values.yaml.tftpl", {nodeSelector = local.primaryNodeSelector})]
  }

  argocd_manage_add_ons               = true
  //argocd_admin_password_secret_name   = <secret_name>
  argocd_applications     = {
    addons = {
      path                = "argocd/addons/chart"
      // This should usually point at an internally owned and managed repo.
      repo_url            = "https://github.com/superorbital/aws-eks-blueprint-examples.git"
      project             = "default"
      add_on_application  = true // This indicates the root add-on application.
    }
    workloads = {
      path                = "argocd/workloads/envs/dev"
      repo_url            = "https://github.com/superorbital/aws-eks-blueprint-examples.git"
      values              = {}
    }
  }

  enable_aws_load_balancer_controller = true
  enable_aws_node_termination_handler = true
  enable_cluster_autoscaler           = true
  enable_prometheus                   = true
  // Note: This addon does not currently work in EKS 1.22 (2022-04-25)
  enable_kubernetes_dashboard         = true

}
