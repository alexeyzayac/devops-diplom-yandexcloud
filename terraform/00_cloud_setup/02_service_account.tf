# ./terraform/00_cloud_setup/02_service_account.tf

resource "yandex_iam_service_account" "terraform" {
  description = "Сервисный аккаунт для Terraform"
  name        = "terraform-sa"
  folder_id   = var.folder_id
}

resource "yandex_iam_service_account_key" "terraform_auth_key" {
  description        = "Authorized key для провайдера yandex"
  service_account_id = yandex_iam_service_account.terraform.id
  key_algorithm      = "RSA_4096"
}

resource "local_file" "sa_key_file" {
  content = jsonencode({
    id                 = yandex_iam_service_account_key.terraform_auth_key.id
    service_account_id = yandex_iam_service_account.terraform.id
    created_at         = yandex_iam_service_account_key.terraform_auth_key.created_at
    key_algorithm      = yandex_iam_service_account_key.terraform_auth_key.key_algorithm
    public_key         = yandex_iam_service_account_key.terraform_auth_key.public_key
    private_key        = yandex_iam_service_account_key.terraform_auth_key.private_key
  })
  filename        = "${path.module}/../secret/terraform-sa-key.json"
  file_permission = "0600"
}

resource "yandex_resourcemanager_folder_iam_member" "terraform_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
}

resource "yandex_iam_service_account_static_access_key" "terraform_key" {
  description        = "Статический ключ для S3 backend"
  service_account_id = yandex_iam_service_account.terraform.id
}

