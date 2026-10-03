# ./terraform/01_main/02_network.tf

resource "yandex_vpc_network" "main" {
  description = "Основная VPC-сеть для потока ${var.flow}"
  name        = "${var.flow}-vpc"
}

resource "yandex_vpc_subnet" "public_a" {
  description    = "Публичная подсеть для доступа в интернет"
  name           = "${var.flow}-public-a"
  zone           = var.zone_a
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "public_b" {
  description    = "Публичная подсеть для доступа в интернет"
  name           = "${var.flow}-public-b"
  zone           = var.zone_b
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "public_d" {
  description    = "Публичная подсеть для доступа в интернет"
  name           = "${var.flow}-public-d"
  zone           = var.zone_d
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}
