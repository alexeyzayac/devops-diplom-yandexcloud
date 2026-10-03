# ./terraform/00_cloud_setup/05_local_files.tf

resource "local_file" "backend_env" {
  filename        = "${path.module}/../01_main/backend.hcl"
  content         = <<-EOT
    # ./terraform/01_main/backend.hcl

    access_key = "${yandex_iam_service_account_static_access_key.terraform_key.access_key}"
    secret_key = "${yandex_iam_service_account_static_access_key.terraform_key.secret_key}"
  EOT
  file_permission = "0600"
}