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
  description	= "Test image"
  source_family	= "ubuntu-2004-lts"
  folder_id	= var.yc_folder_id
  min_disk_size	= 10
  os_type	= "linux"
}


resource "yandex_compute_instance" "virt_machine" {
  name = "banzai-vm"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
#      image_id	= "fd80viupr3qjr5g6g9du"
      image_id = "fd89jk9j9vifp28uprop"
      size	= 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet192.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "test_network" {
  name = "test-net"
}

resource "yandex_vpc_subnet" "subnet192" {
  v4_cidr_blocks = ["10.0.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.test_network.id}"
}
