provider "aws" {
  region = var.aws_region # This is our main region
}

data "aws_caller_identity" "current" {}

data "aws_iam_roles" "all" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs_list
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 17.0"

  cluster_name = var.cluster_name
  subnets      = module.vpc.private_subnets
  tags         = var.tags

   vpc_id = module.vpc.vpc_id

   # Here is our auth data for kubernetes
  # kubeconfig_aws_authenticator_command        = "aws"
  # kubeconfig_aws_authenticator_command_args   = ["eks", "update-kubeconfig", "--region", "us-west-2", "--name"]
  # kubeconfig_aws_authenticator_additional_args = []

  manage_aws_auth = false

  node_groups_defaults = var.node_group_defaults

  node_groups = var.node_groups
}
