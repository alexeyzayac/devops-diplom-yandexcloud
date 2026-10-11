#!/usr/bin/env bash
set -euo pipefail

REGISTRY_ID="$(terraform -chdir=../../terraform/00_cloud_setup output -raw container_registry_id)"

yc container registry configure-docker

IMAGES=(
  "docker.io/bats/bats:1.14.0"
  "docker.io/grafana/grafana:13.2.3-distroless"
  "docker.io/jkroepke/kube-webhook-certgen:1.8.9"
  "quay.io/kiwigrid/k8s-sidecar:2.13.1"
  "quay.io/prometheus/alertmanager:v0.34.1"
  "quay.io/prometheus/node-exporter:v1.12.1-distroless"
  "quay.io/prometheus-operator/prometheus-operator:v0.94.1"
  "quay.io/prometheus-operator/prometheus-config-reloader:v0.94.1"
  "quay.io/prometheus/prometheus:v3.15.0-distroless"
  "registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.20.0"
)

for img in "${IMAGES[@]}"; do
  # Извлекаем имя и тег
  name="${img##*/}"
  name="${name%%:*}"
  tag="${img##*:}"

  new="cr.yandex/${REGISTRY_ID}/${name}:${tag}"

  echo "Скачивание образа: ${img}"
  docker pull "${img}"

  echo "Присвоение нового имени: ${img} -> ${new}"
  docker tag "${img}" "${new}"

  echo "Загрузка образа в ${REGISTRY_ID}: ${new}"
  docker push "${new}"
done

echo "Все образы успешно загружены в cr.yandex/${REGISTRY_ID}"