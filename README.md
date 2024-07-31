# AWS Sandbox (ACG) 

##Terraform Kubernetes Solution

This repository contains Terraform code to deploy a Kubernetes-based Test application on AWS. The Terraform state is stored in an S3 bucket, and the state lock is managed using a DynamoDB table. Both the S3 bucket and the DynamoDB table are created using AWS CloudFormation.

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) installed (version >= 0.13)
2. [AWS CLI](https://aws.amazon.com/cli/) installed and configured with appropriate credentials
3. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed (optional, to interact with the deployed Kubernetes cluster)

## Usage

1. Clone this repository:

```sh
git clone https://github.com/yourusername/<this-repo>.git
cd <this-repo>
```

2. Create the required S3 bucket and DynamoDB table using CloudFormation:

```sh
aws cloudformation create-stack --stack-name my-stack --template-body file://s3-dynamodb.yml --parameters ParameterKey=S3BucketName,ParameterValue=my-s3-bucket ParameterKey=DynamoDBName,ParameterValue=my-lock-table
```

3. Update `backend.tf` with the S3 bucket and DynamoDB table names you provided as parameters when creating the CloudFormation stack:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-s3-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "my-lock-table"
  }
}
```

4. Initialize Terraform:

```sh
terraform init
```

5. Review the Terraform plan and apply:

```sh
terraform plan
terraform apply
```

6. (Optional) To interact with the deployed Kubernetes cluster, configure `kubectl`:

```sh
aws eks update-kubeconfig --region us-west-2 --name my-cluster-name
```

7. To destroy the deployed infrastructure, run:

```sh
terraform destroy
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.
