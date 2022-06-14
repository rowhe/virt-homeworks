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


locals {
  instance = {
    default	= 0
    prod	= 2
    stage	= 1
  }
}

resource "yandex_compute_instance" "virt_machine" {
  name = "banzai-vm-${count.index}-${terraform.workspace}"
  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id	= "${yandex_compute_image.my_image.id}"
      size	= 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet192.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${file("~/.ssh/id_rsa.pub")}"
  }
  count 	= local.instance[terraform.workspace]
}

resource "yandex_vpc_network" "test_network" {
  name = "test-net"
}

resource "yandex_vpc_subnet" "subnet192" {
  v4_cidr_blocks = ["192.168.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.test_network.id}"
}


// Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = "${var.yc_folder_id}"
  name      = "tf-test-sa"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = "${var.yc_folder_id}"
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "stage732-1235gwosn" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "bigbucket"
}
