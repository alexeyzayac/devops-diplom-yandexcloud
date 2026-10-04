# ./terraform/00_cloud_setup/00_providers.tf

terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.235.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.9.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.3.2"
    }
  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = pathexpand(var.service_account_key_file)
}