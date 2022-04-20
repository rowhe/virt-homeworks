
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
    * "Инфраструктура как код" позволяет более гибко и предсказуемо управлять конфигурациями сервисов. 
- Какой из принципов IaaC является основополагающим?
    * Основопологающим принципом IaaC является "Иденпотентность", что означает высокий уровень идентичности, повторяемости, неизменности получаемого результата. 

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
    * Преимуществами Ansible являются:
      - огромное комьюнити
      - большое количество готовых шаблонов
      - push подход
      - легкость в изучении
      - применение языка python
      
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
    * На мой взгляд метот push является наиболее предпочтительным.

## Задача 3

Установить на личный компьютер:

- VirtualBox
```shell
dpopov@dpopov-test:~/devops/vagrant$ virtualbox --help
Oracle VM VirtualBox VM Selector v6.1.32_Ubuntu
(C) 2005-2022 Oracle Corporation
All rights reserved.

No special options.

If you are looking for --startvm and related options, you need to use VirtualBoxVM.
dpopov@dpopov-test:~/devops/vagrant$
 

```
- Vagrant
```shell
dpopov@dpopov-test:~/devops/vagrant$ vagrant -v
Vagrant 2.2.14
dpopov@dpopov-test:~/devops/vagrant$

```
- Ansible
```shell
dpopov@dpopov-test:~/devops/vagrant$ ansible --version
ansible 2.10.8
  config file = /home/dpopov/devops/vagrant/ansible.cfg
  configured module search path = ['/home/dpopov/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.9.7 (default, Sep 10 2021, 14:59:43) [GCC 11.2.0]
dpopov@dpopov-test:~/devops/vagrant$
```

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

* Вывод `docker ps` из виртуальной машины:
```shell
dpopov@dpopov-test:~/devops/vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed 20 Apr 2022 07:19:51 PM UTC

  System load:  0.0                Users logged in:          0
  Usage of /:   13.4% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 24%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.192.11
  Processes:    108


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Wed Apr 20 19:09:14 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$

```