# ./terraform/00_cloud_setup/06_local_files.tf

resource "local_file" "backend_env" {
  filename        = "${path.module}/../secret/backend.hcl"
  content         = <<-EOT
    # ./terraform/secret/backend.hcl

    access_key = "${yandex_iam_service_account_static_access_key.terraform_key.access_key}"
    secret_key = "${yandex_iam_service_account_static_access_key.terraform_key.secret_key}"
  EOT
  file_permission = "0600"
}

resource "local_file" "make_vars" {
  filename        = "${path.module}/../../app/Makefile.vars"
  content         = <<-EOT
    # ./app/Makefile.vars

    REGISTRY-ID := ${yandex_container_registry.app_registry.id}
  EOT
  file_permission = "0644"
}

resource "local_file" "app_diplom_k8s_helm_vars" {
  filename        = "${path.module}/../../k8s/app-diplom/chart/values.yaml"
  content         = <<-EOT
  ---

  image: cr.yandex/${yandex_container_registry.app_registry.id}/diplom-app:v1
  
  ...
  EOT
  file_permission = "0644"
}