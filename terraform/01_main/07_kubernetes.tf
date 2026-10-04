# ./terraform/01_main/07_kubernetes.tf

resource "yandex_kubernetes_cluster" "k8s_cluster" {
  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_sa_roles,
    yandex_kms_symmetric_key_iam_binding.k8s_secrets_access,
  ]

  name        = "${var.flow}-k8s"
  description = "Кластер Kubernetes для ${var.flow}"
  network_id  = yandex_vpc_network.main.id

  master {
    version = var.k8s_version

    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.public_a.zone
        subnet_id = yandex_vpc_subnet.public_a.id
      }
      location {
        zone      = yandex_vpc_subnet.public_b.zone
        subnet_id = yandex_vpc_subnet.public_b.id
      }
      location {
        zone      = yandex_vpc_subnet.public_d.zone
        subnet_id = yandex_vpc_subnet.public_d.id
      }
    }

    public_ip          = true
    security_group_ids = [yandex_vpc_security_group.k8s_master.id]

    maintenance_policy {
      auto_upgrade = true
      maintenance_window {
        day        = "saturday"
        start_time = "12:00"
        duration   = "3h"
      }
    }
  }

  kms_provider {
    key_id = yandex_kms_symmetric_key.k8s_secrets_key.id
  }

  service_account_id      = yandex_iam_service_account.k8s_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_sa.id

  release_channel         = "REGULAR"
  network_policy_provider = "CALICO"

  cluster_ipv4_range = "10.200.0.0/16"
  service_ipv4_range = "10.210.0.0/16"
}

resource "yandex_kubernetes_node_group" "k8s_nodes" {
  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  name       = "${var.flow}-k8s-nodes"
  version    = var.k8s_version

  instance_template {
    name        = "k8s-node-${var.flow}-{instance.short_id}"
    platform_id = "standard-v3"

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      type = "network-hdd"
      size = 32
    }

    network_interface {
      nat = true
      subnet_ids = [
        yandex_vpc_subnet.public_a.id,
        yandex_vpc_subnet.public_b.id,
        yandex_vpc_subnet.public_d.id,
      ]
      security_group_ids = [yandex_vpc_security_group.k8s_nodes.id]
    }

    scheduling_policy {
      preemptible = true
    }

    metadata = {
      user-data = templatefile("${path.module}/cloud_init.tpl", {
        ssh_public_key = tls_private_key.ssh.public_key_openssh
      })
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    location {
      zone = var.zone_a
    }
    location {
      zone = var.zone_b
    }
    location {
      zone = var.zone_d
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true
  }
}