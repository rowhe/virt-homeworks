# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
2. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 

   * Указываем s3 бакет, iam роль и пользователя в [main.tf](https://github.com/rowhe/virt-homeworks/blob/3973eca996d02f1a230dec3c82d82b29110ba4de/07-terraform-03-basic/terraform/main.tf)

   * Пробуем создать конфирацию:
```shell
   dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$ terraform apply -var-file=.tfvars

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_image.my_image will be created
  + resource "yandex_compute_image" "my_image" {
      + created_at      = (known after apply)
      + description     = "Test image"
      + folder_id       = "b1gb32s82dickk1qj5v9"
      + id              = (known after apply)
      + min_disk_size   = 10
      + os_type         = "linux"
      + pooled          = (known after apply)
      + product_ids     = (known after apply)
      + size            = (known after apply)
      + source_disk     = (known after apply)
      + source_family   = "ubuntu-2004-lts"
      + source_image    = (known after apply)
      + source_snapshot = (known after apply)
      + source_url      = (known after apply)
      + status          = (known after apply)
    }

  # yandex_compute_instance.virt_machine will be created
  + resource "yandex_compute_instance" "virt_machine" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC80kTosJ4KiOENc/kJJ2KxYDXFTlotKfKOBL+9sJkF5hwX56WNeGzK7NQYVoEYUsP+rMy3KEI7Qqh4k7c7VnIw+x61ABl9EGINgCK4mWmUBvhpp91Cz5oafxxCPZ1o8jfkTYAW8Sg2TPX3aJXThxROl4vvW3IW7OQUbbvG9URT0GQX4z7dOzyGE5DVxoY/jPgBCrdmU3vemeFeki2nuxkrclVTzyuVmdX0Ng2+S7JLyMHMSSlUx2uMpUiZRv8eklkwk/tuyAklKYRNKkjMicG6xw+p/RUKheiZG7wUVrH6YCQbTCEZXthwB7/f9+Vlrtlanla9uGEfxZL+S53lZpnq9nI5oclV/ddUnhDFYzZjy9iuJNkY5vrmL+plijm7vTKUZJ93uFbjDGty7KlaaIWb1+ISd4mw78bjS59Uqn9UiKZwRRHwqbO40MSFa0zkCPTc9HLDECNe3zqgIAHaiqlnMzxfkHXAOHwhXftKdPooKDuaB5ToaTcXd/HLT8AAN+8= dpopov@dpopov-test
            EOT
        }
      + name                      = "banzai-vm"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd80viupr3qjr5g6g9du"
              + name        = (known after apply)
              + size        = 500
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_iam_service_account.sa will be created
  + resource "yandex_iam_service_account" "sa" {
      + created_at = (known after apply)
      + folder_id  = "b1gb32s82dickk1qj5v9"
      + id         = (known after apply)
      + name       = "tf-test-sa"
    }

  # yandex_iam_service_account_static_access_key.sa-static-key will be created
  + resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
      + access_key           = (known after apply)
      + created_at           = (known after apply)
      + description          = "static access key for object storage"
      + encrypted_secret_key = (known after apply)
      + id                   = (known after apply)
      + key_fingerprint      = (known after apply)
      + secret_key           = (sensitive value)
      + service_account_id   = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.sa-editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
      + folder_id = "b1gb32s82dickk1qj5v9"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "storage.editor"
    }

  # yandex_storage_bucket.stage732-1235gwosn will be created
  + resource "yandex_storage_bucket" "stage732-1235gwosn" {
      + access_key            = (known after apply)
      + acl                   = "private"
      + bucket                = "stage732-1235gwosn"
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = false
      + id                    = (known after apply)
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)

      + anonymous_access_flags {
          + list = (known after apply)
          + read = (known after apply)
        }

      + versioning {
          + enabled = (known after apply)
        }
    }

  # yandex_vpc_network.test_network will be created
  + resource "yandex_vpc_network" "test_network" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "test-net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet192 will be created
  + resource "yandex_vpc_subnet" "subnet192" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = (known after apply)
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.0.0/16",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 8 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_iam_service_account.sa: Creating...
yandex_vpc_network.test_network: Creating...
yandex_compute_image.my_image: Creating...
yandex_vpc_network.test_network: Creation complete after 1s [id=enp6v18u38nolhcn6jkm]
yandex_vpc_subnet.subnet192: Creating...
yandex_iam_service_account.sa: Creation complete after 2s [id=ajeitaq022spksp2cuap]
yandex_resourcemanager_folder_iam_member.sa-editor: Creating...
yandex_iam_service_account_static_access_key.sa-static-key: Creating...
yandex_vpc_subnet.subnet192: Creation complete after 1s [id=e9bc5khnf4dfm4hmrrq0]
yandex_compute_instance.virt_machine: Creating...
yandex_iam_service_account_static_access_key.sa-static-key: Creation complete after 0s [id=aje8b5c4hafe3onkvabd]
yandex_storage_bucket.stage732-1235gwosn: Creating...
yandex_resourcemanager_folder_iam_member.sa-editor: Creation complete after 1s [id=b1gb32s82dickk1qj5v9/storage.editor/serviceAccount:ajeitaq022spksp2cuap]
yandex_compute_image.my_image: Creation complete after 6s [id=fd850nakbg63vsaph0dc]
yandex_compute_instance.virt_machine: Still creating... [10s elapsed]
yandex_storage_bucket.stage732-1235gwosn: Still creating... [10s elapsed]
yandex_compute_instance.virt_machine: Still creating... [20s elapsed]
yandex_storage_bucket.stage732-1235gwosn: Still creating... [20s elapsed]
yandex_compute_instance.virt_machine: Creation complete after 24s [id=fhmcd8qbs6tr8sgvbqh1]
yandex_storage_bucket.stage732-1235gwosn: Still creating... [30s elapsed]
yandex_storage_bucket.stage732-1235gwosn: Still creating... [40s elapsed]
yandex_storage_bucket.stage732-1235gwosn: Still creating... [50s elapsed]
yandex_storage_bucket.stage732-1235gwosn: Still creating... [1m0s elapsed]
yandex_storage_bucket.stage732-1235gwosn: Creation complete after 1m1s [id=stage732-1235gwosn]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$ 
```
  



## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.
 * Проверяем стейты

```shell
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$ terraform state list
yandex_compute_image.my_image
yandex_compute_instance.virt_machine
yandex_iam_service_account.sa
yandex_iam_service_account_static_access_key.sa-static-key
yandex_resourcemanager_folder_iam_member.sa-editor
yandex_storage_bucket.stage732-1235gwosn
yandex_vpc_network.test_network
yandex_vpc_subnet.subnet192
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$ terraform state show yandex_iam_service_account.sa
# yandex_iam_service_account.sa:
resource "yandex_iam_service_account" "sa" {
    created_at = "2022-06-14T18:14:36Z"
    folder_id  = "b1gb32s82dickk1qj5v9"
    id         = "ajeitaq022spksp2cuap"
    name       = "tf-test-sa"
}
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$ terraform state show yandex_storage_bucket.stage732-1235gwosn
# yandex_storage_bucket.stage732-1235gwosn:
resource "yandex_storage_bucket" "stage732-1235gwosn" {
    access_key            = "YCAJE_KcdBnNkUFRkB6XKRFxu"
    acl                   = "private"
    bucket                = "stage732-1235gwosn"
    bucket_domain_name    = "stage732-1235gwosn.storage.yandexcloud.net"
    default_storage_class = "STANDARD"
    folder_id             = "b1gb32s82dickk1qj5v9"
    force_destroy         = false
    id                    = "stage732-1235gwosn"
    max_size              = 0
    policy                = ""
    secret_key            = (sensitive value)

    anonymous_access_flags {
        list = false
        read = false
    }

    versioning {
        enabled = false
    }
}
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$
```

1. Создайте два воркспейса `stage` и `prod`.
```shell
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$ terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$ terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$ terraform workspace list
  default
  prod
* stage

```

2. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
   1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два.
   * Добавляем `count` для `yandex_coupute_instance` в [main.tf](https://github.com/rowhe/virt-homeworks/blob/cc90565aaf793f6289044001bbf0bf3be009acec/07-terraform-03-basic/terraform/main.tf)
```shell
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
```
   * Проверяем стейт
```shell
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$  terraform state list
yandex_compute_image.my_image
yandex_compute_instance.virt_machine[0]
yandex_compute_instance.virt_machine[1]
yandex_iam_service_account.sa
yandex_iam_service_account_static_access_key.sa-static-key
yandex_resourcemanager_folder_iam_member.sa-editor
yandex_storage_bucket.stage732-1235gwosn
yandex_vpc_network.test_network
yandex_vpc_subnet.subnet192
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$

```
3. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
4. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из ресурсов `aws_instance`.
   * Добавим `create_before_destroy` в инстанс `virt_machine`
```shell
lifecycle {
  create_before_destroy = true
}
```

5. При желании поэкспериментируйте с другими параметрами и ресурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`.  

   * Вывод команд `terraform workspace list` и `terraform plan`
```shell
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$ terraform workspace list
  default
* prod
  stage

dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$ terraform plan -var-file=.tfvars

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_image.my_image will be created
  + resource "yandex_compute_image" "my_image" {
      + created_at      = (known after apply)
      + description     = "Test image"
      + folder_id       = "b1gb32s82dickk1qj5v9"
      + id              = (known after apply)
      + min_disk_size   = 10
      + os_type         = "linux"
      + pooled          = (known after apply)
      + product_ids     = (known after apply)
      + size            = (known after apply)
      + source_disk     = (known after apply)
      + source_family   = "ubuntu-2004-lts"
      + source_image    = (known after apply)
      + source_snapshot = (known after apply)
      + source_url      = (known after apply)
      + status          = (known after apply)
    }

  # yandex_compute_instance.maschina["0"] will be created
  + resource "yandex_compute_instance" "maschina" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "mama-0-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.maschina["1"] will be created
  + resource "yandex_compute_instance" "maschina" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "mama-1-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.maschina["2"] will be created
  + resource "yandex_compute_instance" "maschina" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + name                      = "mama-2-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.virt_machine[0] will be created
  + resource "yandex_compute_instance" "virt_machine" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC80kTosJ4KiOENc/kJJ2KxYDXFTlotKfKOBL+9sJkF5hwX56WNeGzK7NQYVoEYUsP+rMy3KEI7Qqh4k7c7VnIw+x61ABl9EGINgCK4mWmUBvhpp91Cz5oafxxCPZ1o8jfkTYAW8Sg2TPX3aJXThxROl4vvW3IW7OQUbbvG9URT0GQX4z7dOzyGE5DVxoY/jPgBCrdmU3vemeFeki2nuxkrclVTzyuVmdX0Ng2+S7JLyMHMSSlUx2uMpUiZRv8eklkwk/tuyAklKYRNKkjMicG6xw+p/RUKheiZG7wUVrH6YCQbTCEZXthwB7/f9+Vlrtlanla9uGEfxZL+S53lZpnq9nI5oclV/ddUnhDFYzZjy9iuJNkY5vrmL+plijm7vTKUZJ93uFbjDGty7KlaaIWb1+ISd4mw78bjS59Uqn9UiKZwRRHwqbO40MSFa0zkCPTc9HLDECNe3zqgIAHaiqlnMzxfkHXAOHwhXftKdPooKDuaB5ToaTcXd/HLT8AAN+8= dpopov@dpopov-test
            EOT
        }
      + name                      = "banzai-vm-0-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.virt_machine[1] will be created
  + resource "yandex_compute_instance" "virt_machine" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC80kTosJ4KiOENc/kJJ2KxYDXFTlotKfKOBL+9sJkF5hwX56WNeGzK7NQYVoEYUsP+rMy3KEI7Qqh4k7c7VnIw+x61ABl9EGINgCK4mWmUBvhpp91Cz5oafxxCPZ1o8jfkTYAW8Sg2TPX3aJXThxROl4vvW3IW7OQUbbvG9URT0GQX4z7dOzyGE5DVxoY/jPgBCrdmU3vemeFeki2nuxkrclVTzyuVmdX0Ng2+S7JLyMHMSSlUx2uMpUiZRv8eklkwk/tuyAklKYRNKkjMicG6xw+p/RUKheiZG7wUVrH6YCQbTCEZXthwB7/f9+Vlrtlanla9uGEfxZL+S53lZpnq9nI5oclV/ddUnhDFYzZjy9iuJNkY5vrmL+plijm7vTKUZJ93uFbjDGty7KlaaIWb1+ISd4mw78bjS59Uqn9UiKZwRRHwqbO40MSFa0zkCPTc9HLDECNe3zqgIAHaiqlnMzxfkHXAOHwhXftKdPooKDuaB5ToaTcXd/HLT8AAN+8= dpopov@dpopov-test
            EOT
        }
      + name                      = "banzai-vm-1-prod"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = (known after apply)
              + name        = (known after apply)
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_iam_service_account.sa will be created
  + resource "yandex_iam_service_account" "sa" {
      + created_at = (known after apply)
      + folder_id  = "b1gb32s82dickk1qj5v9"
      + id         = (known after apply)
      + name       = "tf-test-sa"
    }

  # yandex_iam_service_account_static_access_key.sa-static-key will be created
  + resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
      + access_key           = (known after apply)
      + created_at           = (known after apply)
      + description          = "static access key for object storage"
      + encrypted_secret_key = (known after apply)
      + id                   = (known after apply)
      + key_fingerprint      = (known after apply)
      + secret_key           = (sensitive value)
      + service_account_id   = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.sa-editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
      + folder_id = "b1gb32s82dickk1qj5v9"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "storage.editor"
    }

  # yandex_storage_bucket.stage732-1235gwosn will be created
  + resource "yandex_storage_bucket" "stage732-1235gwosn" {
      + access_key            = (known after apply)
      + acl                   = "private"
      + bucket                = "bigbucket"
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = false
      + id                    = (known after apply)
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)

      + anonymous_access_flags {
          + list = (known after apply)
          + read = (known after apply)
        }

      + versioning {
          + enabled = (known after apply)
        }
    }

  # yandex_vpc_network.test_network will be created
  + resource "yandex_vpc_network" "test_network" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "test-net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet192 will be created
  + resource "yandex_vpc_subnet" "subnet192" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = (known after apply)
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.0.0/16",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 12 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
dpopov@dpopov-test:~/virt-homeworks/07-terraform-03-basic/terraform$
```
   * Окончательный вариант [main.tf](https://github.com/rowhe/virt-homeworks/blob/1489538b5a8ca06453ee7073c945892ce5aaeb08/07-terraform-03-basic/terraform/main.tf) для задания 7.2
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
