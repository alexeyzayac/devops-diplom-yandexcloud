# ./terraform/00_cloud_setup/99_outputs.tf

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