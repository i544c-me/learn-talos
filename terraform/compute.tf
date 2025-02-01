locals {
  worker_nodes = 3
}

resource "sakuracloud_server" "talos_controlplane" {
  name   = "talos-controlplane"
  core   = 4
  memory = 8
  disks  = [sakuracloud_disk.talos_controlplane.id]

  cdrom_id = sakuracloud_cdrom.talos.id

  network_interface {
    upstream = "shared"
  }
}

resource "sakuracloud_disk" "talos_controlplane" {
  name = "talos-controlplane"
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
    upstream = "shared"
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
