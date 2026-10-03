# ./terraform/01_main/01_variables.tf

variable "flow" {
  description = "Переменная для идентификации версии"
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

variable "zone_a" {
  description = "Зона доступности A в Yandex Cloud"
  type        = string
  default     = "ru-central1-a"
  nullable    = false
}

variable "zone_b" {
  description = "Зона доступности B вYandex Cloud"
  type        = string
  default     = "ru-central1-b"
  nullable    = false
}

variable "zone_d" {
  description = "Зона доступности D вYandex Cloud"
  type        = string
  default     = "ru-central1-d"
  nullable    = false
}

variable "k8s_version" {
  description = "Версия Kubernetes"
  type        = string
  default     = "1.30"
  nullable    = false
}