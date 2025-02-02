locals {
  out_path = "${path.root}/_out/${var.hostname}"
}

resource "local_file" "meta_data" {
  content = templatefile("${path.module}/template/meta-data.tftpl", {
    hostname = var.hostname
  })
  filename = "${local.out_path}/meta-data"
}

resource "local_file" "network_config" {
  content = templatefile("${path.module}/template/network-config.tftpl", {
    ip_address = var.ip_address
    gateway = var.gateway
  })
  filename = "${local.out_path}/network-config"
}

resource "terraform_data" "gen_iso" {
  triggers_replace = [
    local_file.meta_data.content_sha256,
    local_file.network_config.content_sha256,
  ]

  provisioner "local-exec" {
    working_dir = local.out_path
    command = "genisoimage -output cidata.iso -V cidata -r -J meta-data network-config"
  }
}
