# ./terraform/00_cloud_setup/04_storage.tf

resource "yandex_storage_bucket" "tfstate" {
  bucket        = var.bucket_name
  folder_id     = var.folder_id
  force_destroy = true

  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}