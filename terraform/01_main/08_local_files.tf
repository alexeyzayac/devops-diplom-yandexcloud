# ./terraform/01_main/08_local_files.tf

resource "local_file" "make_vars_k8s" {
  filename        = "${path.module}/../../k8s/Makefile.vars"
  content         = <<-EOT
    # ./k8s/Makefile.vars

    CLUSTER-ID := ${yandex_kubernetes_cluster.k8s_cluster.id}
  EOT
  file_permission = "0644"
}