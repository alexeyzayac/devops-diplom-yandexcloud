# ./terraform/00_cloud_setup/05_registry.tf

resource "yandex_container_registry" "app_registry" {
  name      = "${var.registry_name}-app-registry"
  folder_id = var.folder_id

  labels = {
    flow = var.registry_name
  }
}

resource "null_resource" "delete_all_images" {
  triggers = {
    registry_id = yandex_container_registry.app_registry.id
  }

  provisioner "local-exec" {
    when       = destroy
    command    = <<-EOT
      REGISTRY_ID="${self.triggers.registry_id}"
      IMAGE_IDS=$(yc container image list --registry-id "$REGISTRY_ID" --format json | jq -r '.[].id')
      for img in $IMAGE_IDS; do
        echo "Deleting image $img..."
        yc container image delete "$img"
      done
    EOT
    on_failure = continue
  }
}

# resource "null_resource" "scan_policy" {
#   triggers = {
#     registry_id = yandex_container_registry.app_registry.id
#     rules_hash = sha256(jsonencode({
#       pushRule = {
#         repositoryPrefixes = ["*"]
#         disabled           = false
#       }
#       scheduleRules = [
#         {
#           repositoryPrefixes = ["*"]
#           rescanPeriod       = "604800s" # 7 дней
#           disabled           = false
#         }
#       ]
#     }))
#   }

#   # terraform apply
#   provisioner "local-exec" {
#     command = <<-EOT
#       IAM_TOKEN=$(yc iam create-token)
#       curl -sS -X POST \
#         -H "Authorization: Bearer $IAM_TOKEN" \
#         -H "Content-Type: application/json" \
#         -d '{
#           "registryId": "${yandex_container_registry.app_registry.id}",
#           "name": "${var.registry_name}-scan-policy",
#           "description": "Автоматическое сканирование при загрузке и по расписанию",
#           "rules": {
#             "pushRule": {
#               "repositoryPrefixes": ["*"],
#               "disabled": false
#             },
#             "scheduleRules": [
#               {
#                 "repositoryPrefixes": ["*"],
#                 "rescanPeriod": "604800s",
#                 "disabled": false
#               }
#             ]
#           }
#         }' \
#         "https://container-registry.api.cloud.yandex.net/container-registry/v1/scanPolicies"
#     EOT
#   }

#   # terraform destroy
#   provisioner "local-exec" {
#     when       = destroy
#     command    = <<-EOT
#       IAM_TOKEN=$(yc iam create-token)
#       POLICY_ID=$(curl -sS -X GET \
#         -H "Authorization: Bearer $IAM_TOKEN" \
#         "https://container-registry.api.cloud.yandex.net/container-registry/v1/scanPolicies/${self.triggers.registry_id}:byRegistry" \
#         | jq -r '.id')
#       if [ -n "$POLICY_ID" ] && [ "$POLICY_ID" != "null" ]; then
#         curl -sS -X DELETE \
#           -H "Authorization: Bearer $IAM_TOKEN" \
#           "https://container-registry.api.cloud.yandex.net/container-registry/v1/scanPolicies/$POLICY_ID"
#       fi
#     EOT
#     on_failure = continue
#   }
# }