provider "yandex" {
  token		= var.yc_token
  cloud_id	= var.yc_cloud_id
  zone		= var.yc_region
  folder_id	= var.yc_folder_id
}


resource "yandex_compute_image" "ubuntu-2004-test-image" {
  name = "ubuntu_test_image"
  description = "ubuntu test image"
  source_image = "fd800n45ob5uggkrooi8"
  family	= "linux"
  min_disk
}
