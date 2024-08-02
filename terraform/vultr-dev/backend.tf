terraform {
  backend "s3" {
    endpoint               = "fra1.digitaloceanspaces.com"
    bucket                 = "callbot"
    key                    = "terraform.tfstate"
    region                 = "fra1"
    skip_region_validation = true
    skip_credentials_validation = true
    skip_metadata_api_check = true
    force_path_style        = true
    access_key             = var.digitalocean_accesskey
    secret_key             = var.digitalocean_token
  }
}
