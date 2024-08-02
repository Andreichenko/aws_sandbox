terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
    }
  }
}

provider "vultr" {
  api_key = var.VULTR_API_TOKEN
}

resource "vultr_instance" "testcall" {
  label                = "testcaller"
  region              = "fra"
  plan                = "vc2-1c-2gb"
  snapshot_id         = ""
  os_id        = "448"


  user_data = ""
}
