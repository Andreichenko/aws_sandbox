variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-03322d2da9374cf60"
}

#ami-03322d2da9374cf60 ubuntu
#ami-0810ddd646a26b133 centos7

variable "public_key_path" {
  description = "Path to the public key used for the EC2 instance"
  type        = string
  default     = "/var/lib/jenkins/.ssh/id_ed25519.pub"
}

variable "public_key" {
  description = "The public SSH key"
  type        = string
  sensitive   = true
}
