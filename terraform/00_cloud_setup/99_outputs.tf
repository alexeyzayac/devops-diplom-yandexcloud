# ./terraform/00_cloud_setup/99_outputs.tf

output "sa_id" {
  description = "ID сервисного аккаунта Terraform"
  value       = yandex_iam_service_account.terraform.id
}

output "s3_access_key" {
  description = "Access key для S3 backend"
  value       = yandex_iam_service_account_static_access_key.terraform_key.access_key
}

output "s3_secret_key" {
  description = "Secret key для S3 backend"
  value       = yandex_iam_service_account_static_access_key.terraform_key.secret_key
  sensitive   = true
}

output "kms_key_id" {
  description = "ID KMS-ключа для шифрования бакета"
  value       = yandex_kms_symmetric_key.bucket_key.id
}

output "container_registry_id" {
  description = "ID Yandex Container Registry"
  value       = yandex_container_registry.app_registry.id
}