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

  cdrom_id = sakuracloud_cdrom.talos.id

  network_interface {
    upstream = data.sakuracloud_internet.main.switch_id
  }

  disk_edit_parameter {
    hostname   = "talos-controlplane-${count.index}"
    ip_address = data.sakuracloud_internet.main.ip_addresses[count.index]
    gateway    = data.sakuracloud_internet.main.gateway
    netmask    = data.sakuracloud_internet.main.netmask
  }
}

resource "sakuracloud_disk" "talos_control" {
  count = local.control_nodes

  name = "talos-controlplane-${count.index}"
  size = 40
}

resource "sakuracloud_server" "talos_worker" {
  count = local.worker_nodes

  name   = "talos-worker-${count.index}"
  core   = 4
  memory = 8
  disks  = [sakuracloud_disk.talos_worker[count.index].id]

  cdrom_id = sakuracloud_cdrom.talos.id

  network_interface {
    upstream = data.sakuracloud_internet.main.switch_id
  }

  disk_edit_parameter {
    hostname   = "talos-worker-${count.index}"
    ip_address = data.sakuracloud_internet.main.ip_addresses[count.index + 3]
    gateway    = data.sakuracloud_internet.main.gateway
    netmask    = data.sakuracloud_internet.main.netmask
  }
}

resource "sakuracloud_disk" "talos_worker" {
  count = local.worker_nodes

  name = "talos-worker-${count.index}"
  size = 40
}

resource "sakuracloud_cdrom" "talos" {
  name           = "talos-linux-1.9.2-amd64"
  size           = 5
  iso_image_file = "metal-amd64.iso"
}
