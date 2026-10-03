# ./terraform/00_cloud_setup/03_kms.tf

resource "yandex_kms_symmetric_key" "bucket_key" {
  description       = "Симметричный KMS-ключ для шифрования S3 bucket ${var.bucket_name}"
  name              = "${var.bucket_name}-key"
  default_algorithm = "AES_256"
  rotation_period   = "8760h"
}

# Права terraform на использование ключа для шифрования/расшифровки
resource "yandex_kms_symmetric_key_iam_binding" "bucket_key_encrypter" {
  symmetric_key_id = yandex_kms_symmetric_key.bucket_key.id
  role             = "kms.keys.encrypterDecrypter"

  members = [
    "serviceAccount:${yandex_iam_service_account.terraform.id}",
  ]
}