# ./terraform/00_cloud_setup/05_registry.tf

resource "yandex_container_registry" "app_registry" {
  name      = "${var.registry_name}-app-registry"
  folder_id = var.folder_id

  labels = {
    flow = var.registry_name
  }
}

