# ./terraform/01_main/99_outputs.tf

output "vpc_id" {
  value = yandex_vpc_network.main.id
}

output "public_subnet_ids" {
  value = {
    a = yandex_vpc_subnet.public_a.id
    b = yandex_vpc_subnet.public_b.id
    d = yandex_vpc_subnet.public_d.id
  }
}

output "k8s_cluster_id" {
  description = "ID Kubernetes-кластера"
  value       = yandex_kubernetes_cluster.k8s_cluster.id
}

output "k8s_cluster_endpoint" {
  description = "Публичный endpoint API-сервера K8s"
  value       = yandex_kubernetes_cluster.k8s_cluster.master[0].external_v4_endpoint
}

output "k8s_sa_id" {
  description = "ID сервисного аккаунта K8s"
  value       = yandex_iam_service_account.k8s_sa.id
}

output "kms_k8s_key_id" {
  description = "ID KMS-ключа для секретов K8s"
  value       = yandex_kms_symmetric_key.k8s_secrets_key.id
}