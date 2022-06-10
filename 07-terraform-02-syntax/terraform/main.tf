terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

provider "yandex" {
  token = var_yc_token
  cloud_id = var.yc_cloud_id
  zone = var.yc_region
  folder_id = var.yc_folder_id
}


resource "yandex_compute_instance" "fist_vm" {
  name "p4p-madrid"
  description "test debian virtual machine"
