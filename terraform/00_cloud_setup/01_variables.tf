# ./terraform/00_cloud_setup/01_variables.tf

variable "bucket_name" {
  description = "Имя S3 bucket для Terraform state"
  type        = string
  nullable    = false
}

variable "cloud_id" {
  description = "Идентификатор облака в Yandex Cloud"
  type        = string
  nullable    = false
}

variable "folder_id" {
  description = "Идентификатор каталога в облаке Yandex Cloud"
  type        = string
  nullable    = false
}

variable "service_account_key_file" {
  description = "Путь к JSON-ключу сервисного аккаунта Yandex Cloud"
  type        = string
  nullable    = false
}