terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token		= var.yc_token
  cloud_id	= var.yc_cloud_id
  zone		= var.yc_region
  folder_id	= var.yc_folder_id
}


resource "yandex_compute_image" "my_image" {
  source_family	= "ubuntu-2004-lts"
  folder_id	= var.yc_folder_id
  min_disk_size	= 10    
}
