variable "aws_region" {
  description = "AWS region where the EKS cluster will be deployed"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "A list of CIDR blocks for the private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "A list of CIDR blocks for the public subnets"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "azs_list"{
  description = "A list of azs list for availability zones"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_name" {
  description = "The name of VPC"
  default = "callbot-eks-vpc"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "callbot-eks-cluster"
}

variable "tags" {
  description = "Tags to apply to all resources created by this module"
  default = {
    Terraform   = "true"
    Environment = "dev"
    Author      = "Dr. Frei"
    Owner       = "Prankmaster"
    Developer   = "Crab"
  }
}

variable "node_group_defaults" {
  description = "Default values for the node groups"
  default = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }
}

variable "node_groups" {
  description = "Node groups to be created for the EKS cluster"
  default = {
    example = {
      desired_capacity = 2
      max_capacity     = 10
      min_capacity     = 1
      instance_types   = ["t3.small"]
    }
  }
}
