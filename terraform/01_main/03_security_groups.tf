# ./terraform/01_main/03_security_groups.tf

resource "yandex_vpc_security_group" "k8s_master" {
  name        = "${var.flow}-k8s-master-sg"
  description = "SG для мастера Kubernetes"
  network_id  = yandex_vpc_network.main.id

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "SSH-доступ для администрирования"
    port           = 22
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTPS к API-серверу"
    port           = 443
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "K8s API"
    port           = 6443
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Трафик между мастером и нодами"
    protocol       = "ANY"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    description    = "Трафик между подами и сервисами"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["10.200.0.0/16", "10.210.0.0/16"]
  }

  ingress {
    description       = "Проверки состояния от балансировщика"
    protocol          = "TCP"
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    description       = "Служебный трафик между мастером и нодами"
    protocol          = "ANY"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
}

resource "yandex_vpc_security_group" "k8s_nodes" {
  name        = "${var.flow}-k8s-nodes-sg"
  description = "SG для worker-нод Kubernetes"
  network_id  = yandex_vpc_network.main.id

  egress {
    description    = "Разрешить весь исходящий трафик"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "SSH-доступ для администрирования"
    port           = 22
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTP для приложений через LoadBalancer"
    port           = 80
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTP-альтернативый для приложений через LoadBalancer"
    port           = 8080
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Трафик от мастера к нодам"
    protocol       = "ANY"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    description    = "Трафик между нодами"
    protocol       = "ANY"
    v4_cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    description    = "Трафик между подами и сервисами"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["10.200.0.0/16", "10.210.0.0/16"]
  }

  ingress {
    description    = "Диапазон NodePort для доступа из интернета"
    from_port      = 30000
    to_port        = 32767
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description       = "Проверки состояния от балансировщика"
    protocol          = "TCP"
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }

  ingress {
    description    = "Health check от сетевого балансировщика (порт 10501)"
    port           = 10501
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description       = "Служебный трафик внутри группы (мастер <-> ноды)"
    protocol          = "ANY"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
}