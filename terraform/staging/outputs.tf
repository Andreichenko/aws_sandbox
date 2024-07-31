output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate data required to communicate with the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "vpc_id" {
  description = "The VPC ID where the EKS cluster is deployed"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "The private subnets used by the EKS cluster"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "The public subnets used by the EKS cluster"
  value       = module.vpc.public_subnets
}

# output "kubeconfig" {
#   description = "Kubeconfig file for connecting to the EKS cluster"
#   value       = module.eks.kubeconfig
# }

# output "aws_auth_configmap_yaml" {
#   description = "The Kubernetes ConfigMap YAML for AWS IAM Authenticator"
#   value       = try(module.eks.aws_auth_configmap_yaml, "")
#   depends_on  = [module.eks.aws_auth_configmap]
# }
