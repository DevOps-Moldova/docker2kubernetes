
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.11.0"


  cluster_name                    = var.cluster_name
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = concat(
    [var.vpc_cidr],
    local.vpc_public_ips,
    var.trusted_ip,
    ["${aws_instance.jenkins.public_ip}/32"]
  )

  cluster_addons = {
    # coredns = {
    #   resolve_conflicts = "OVERWRITE"
    # }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  #   cluster_encryption_config = [{
  #     provider_key_arn = "cluster_encryption_config"
  #     resources        = ["secrets"]
  #   }]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    disk_size      = 30
    instance_types = ["t2.small", "t2.nano"]
    vpc_security_group_ids = [
      aws_security_group.allow_outgoing_traffic.id,
      aws_security_group.whitelisted_traffic.id,
      aws_security_group.internal_traffic.id,
    ]
  }

  eks_managed_node_groups = {
    services = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t2.small"]
      capacity_type  = "SPOT"
      labels = {
        Environment = "dev_g"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
      # taints = {
      #   dedicated = {
      #     key    = "dedicated"
      #     value  = "gpuGroup"
      #     effect = "NO_SCHEDULE"
      #   }
      # }
      tags = local.tags
    }
  }
  
  tags = local.tags

}

resource "local_file" "kubeconfig" {

  content              = local.kubeconfig
  filename             = var.kubeconfig_output_path
  file_permission      = "0600"
  directory_permission = "0755"

   lifecycle {
    prevent_destroy  = true
  }
}

module "eks_auth" {
  source = "aidanmelen/eks-auth/aws"
  eks    = module.eks
    patch  = true

    map_users = [
    {
      userarn  = aws_iam_user.service_ecr_manage_manage.arn
      username = aws_iam_user.service_ecr_manage_manage.name
      groups   = ["system:masters"]
    },
  ]

  depends_on = [
    module.eks,
  ]

}