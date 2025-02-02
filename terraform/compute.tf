locals {
  control_nodes = 1
  worker_nodes  = 3
}

resource "sakuracloud_server" "talos_control" {
  count = local.control_nodes

  name   = "talos-control-${count.index}"
  core   = 4
  memory = 8
  disks  = [sakuracloud_disk.talos_control[count.index].id]

  cdrom_id = sakuracloud_cdrom.cidata_control[count.index].id

  network_interface {
    upstream = data.sakuracloud_internet.main.switch_id
  }
}

data "sakuracloud_archive" "talos_control" {
  filter {
    names = ["talos-control"]
  }
}

resource "sakuracloud_disk" "talos_control" {
  count = local.control_nodes

  name              = "talos-control-${count.index}"
  size              = 40
  source_archive_id = data.sakuracloud_archive.talos_control.id
}

resource "sakuracloud_server" "talos_worker" {
  count = local.worker_nodes

  name   = "talos-worker-${count.index}"
  core   = 4
  memory = 8
  disks  = [sakuracloud_disk.talos_worker[count.index].id]

  cdrom_id = sakuracloud_cdrom.cidata_worker[count.index].id

  network_interface {
    upstream = data.sakuracloud_internet.main.switch_id
  }
}

resource "sakuracloud_disk" "talos_worker" {
  count = local.worker_nodes

  name              = "talos-worker-${count.index}"
  size              = 40
  source_archive_id = data.sakuracloud_archive.talos_control.id
}

resource "sakuracloud_cdrom" "cidata_control" {
  count = local.control_nodes

  name           = "cidata-control-${count.index}"
  size           = 5
  iso_image_file = module.gen_iso_control[count.index].iso_path
}

resource "sakuracloud_cdrom" "cidata_worker" {
  count = local.worker_nodes

  name           = "cidata-worker-${count.index}"
  size           = 5
  iso_image_file = module.gen_iso_worker[count.index].iso_path
}

module "gen_iso_control" {
  count = local.control_nodes

  source = "./modules/generate-iso"

  hostname   = "control-${count.index}"
  ip_address = data.sakuracloud_internet.main.ip_addresses[count.index]
  gateway    = data.sakuracloud_internet.main.gateway
}

module "gen_iso_worker" {
  count = local.worker_nodes

  source = "./modules/generate-iso"

  hostname   = "worker-${count.index}"
  ip_address = data.sakuracloud_internet.main.ip_addresses[count.index + 3]
  gateway    = data.sakuracloud_internet.main.gateway
}
