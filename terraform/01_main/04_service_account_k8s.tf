# ./terraform/01_main/04_service_account_k8s.tf

resource "yandex_iam_service_account" "k8s_sa" {
  name        = "${var.flow}-k8s-sa"
  description = "SA для Kubernetes-кластера"
  folder_id   = var.folder_id
}

locals {
  k8s_sa_roles = [
    "k8s.clusters.agent",
    "vpc.publicAdmin",
    "container-registry.images.puller",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_sa_roles" {
  for_each  = toset(local.k8s_sa_roles)
  folder_id = var.folder_id
  role      = each.value
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s_sa.id}",
  ]
}

