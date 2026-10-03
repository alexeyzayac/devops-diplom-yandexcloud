# ./terraform/01_main/06_kms.tf

resource "yandex_kms_symmetric_key" "k8s_secrets_key" {
  description       = "KMS-ключ для шифрования секретов Kubernetes"
  name              = "${var.flow}-k8s-secrets-key"
  default_algorithm = "AES_256"
  rotation_period   = "8760h"
}

resource "yandex_kms_symmetric_key_iam_binding" "k8s_secrets_access" {
  symmetric_key_id = yandex_kms_symmetric_key.k8s_secrets_key.id
  role             = "kms.keys.encrypterDecrypter"

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s_sa.id}",
  ]
}