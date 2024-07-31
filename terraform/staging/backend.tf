terraform {
  backend "s3" {
    bucket         = "my-s3-bucket" # This placeholder will be replaced by the Python script
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-lock-table" # This placeholder will be replaced by the Python script
    encrypt        = true
  }
}
