# ./terraform/01_main/04_service_account_k8s.tf

resource "yandex_iam_service_account" "k8s_sa" {
  name        = "${var.flow}-k8s-sa"
  description = "Сервисный аккаунт для Kubernetes-кластера"
  folder_id   = var.folder_id
}

locals {
  k8s_sa_roles = [
    "k8s.clusters.agent",               # Управление ресурсами кластера от имени SA: ноды, группы нод, балансировщики, диски
    "vpc.publicAdmin",                  # Управление публичными IP-адресами (нужно для NAT на нодах и внешнего IP мастера)
    "container-registry.images.puller", # Скачивание Docker-образов из Container Registry для подов и системных компонентов
    "load-balancer.admin",              # Управление NLB и целевыми группами
    "compute.viewer",                   # Чтение информации об инстансах для target group
  ]
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_sa_roles" {
  for_each  = toset(local.k8s_sa_roles)
  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
}
