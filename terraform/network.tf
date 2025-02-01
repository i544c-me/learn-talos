data "sakuracloud_internet" "main" {
  filter {
    names = ["main"]
  }
}
