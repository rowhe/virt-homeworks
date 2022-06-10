# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.
  * Собираю и запускаю контейнер:
```shell
Psql$ sudo docker pull postgres:12-bullseye
214ca5fb9032: Already exists
e6930973d723: Pull complete
...
Digest: sha256:742e8c57aaa18bf60076b959ea3e7c7aa118a963eca0a0d6b3daefe7bbbc0e8d
Status: Downloaded newer image for postgres:12-bullseye
docker.io/library/postgres:12-bullseye
Psql$
Psql$ sudo docker run -d --name postgres12 -p 5432:5432 -e POSTGRES_PASSWORD=password -e PGDATA=/var/lib/postgresql/data/pgdata -v /home/dpopov/virt-homeworks/05-virt-03-docker/Psql/base/:/var/lib/postgresql/data -v /home/dpopov/virt-homeworks/05-virt-03-docker/Psql/replica/:/var/lib/postgreslq/backup postgres:12-bullseye
1ce5d304ae02a352c4fb962e31c8ed99c5905b5f0fdde9ae903ee8d9e426597c
Psql$
Psql$ sudo docker container ls
CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS          PORTS                                       NAMES
1ce5d304ae02   postgres:12-bullseye    "docker-entrypoint.s…"   35 seconds ago   Up 33 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres12

```

Приведите получившуюся команду или docker-compose манифест.

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

 * Создаю базу данных, пользователей и таблицы:
```commandline
create database test_db;
```
  * После переподключения к новой базе данных test_db выполняем команды:

```shell
create user test_admin_user with encrypted password 'password';
grant all privileges on database test_db to test_admin_user with grant option;
create table orders(id serial primary key,  name varchar(64) not null, price int not null);
create table clients(id serial primary key, fio varchar(64) not null, country varchar(64) not null, zakaz int not null, foreign key(zakaz) references orders(id));
create unique index country on clients (country);
create user test_simple_user with encrypted password 'password';
grant select, insert, update, delete on orders,clients to test_simple_user;
```

Приведите:
- итоговый список БД после выполнения пунктов выше,
  * Получить итоговый список баз данных можно получить после подключения к серверу при помощи команды
```shell
Psql$ psql -h 127.0.0.1 -U test_admin_user -W test_db
Password:
psql (13.7 (Ubuntu 13.7-0ubuntu0.21.10.1), server 12.11 (Debian 12.11-1.pgdg110+1))
Type "help" for help.

test_db=> \l
                                      List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |        Access privileges
-----------+----------+----------+------------+------------+---------------------------------
 123       | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                    +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                    +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                   +
           |          |          |            |            | postgres=CTc/postgres          +
           |          |          |            |            | test_admin_user=C*T*c*/postgres
(5 rows)

test_db=>

```
- описание таблиц (describe)
```shell
test_db=> \dt+
                              List of relations
 Schema |  Name   | Type  |  Owner   | Persistence |    Size    | Description
--------+---------+-------+----------+-------------+------------+-------------
 public | clients | table | postgres | permanent   | 8192 bytes |
 public | orders  | table | postgres | permanent   | 8192 bytes |
(2 rows)

```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```shell
SELECT * FROM pg_roles;

rolname                  |rolsuper|rolinherit|rolcreaterole|rolcreatedb|rolcanlogin|rolreplication|rolconnlimit|rolpassword|rolvaliduntil|rolbypassrls|rolconfig|oid  |
-------------------------+--------+----------+-------------+-----------+-----------+--------------+------------+-----------+-------------+------------+---------+-----+
pg_signal_backend        |false   |true      |false        |false      |false      |false         |          -1|********   |             |false       |NULL     | 4200|
pg_read_server_files     |false   |true      |false        |false      |false      |false         |          -1|********   |             |false       |NULL     | 4569|
test_sipmle_user         |false   |true      |false        |false      |true       |false         |          -1|********   |             |false       |NULL     |16386|
postgres                 |true    |true      |true         |true       |true       |true          |          -1|********   |             |true        |NULL     |   10|
pg_write_server_files    |false   |true      |false        |false      |false      |false         |          -1|********   |             |false       |NULL     | 4570|
test_admin_user          |false   |true      |false        |false      |true       |false         |          -1|********   |             |false       |NULL     |16690|
pg_execute_server_program|false   |true      |false        |false      |false      |false         |          -1|********   |             |false       |NULL     | 4571|
pg_read_all_stats        |false   |true      |false        |false      |false      |false         |          -1|********   |             |false       |NULL     | 3375|
pg_monitor               |false   |true      |false        |false      |false      |false         |          -1|********   |             |false       |NULL     | 3373|
test_simple_user         |false   |true      |false        |false      |true       |false         |          -1|********   |             |false       |NULL     |16691|
pg_read_all_settings     |false   |true      |false        |false      |false      |false         |          -1|********   |             |false       |NULL     | 3374|
pg_stat_scan_tables      |false   |true      |false        |false      |false      |false         |          -1|********   |             |false       |NULL     | 3377|
```

- список пользователей с правами над таблицами test_db

```shell
test_db=> \du+
                                              List of roles
    Role name     |                         Attributes                         | Member of | Description
------------------+------------------------------------------------------------+-----------+-------------
 postgres         | Superuser, Create role, Create DB, Replication, Bypass RLS | {}        |
 test_admin_user  |                                                            | {}        |
 test_simple_user |                                                            | {}        |
 test_sipmle_user |                                                            | {}        |

test_db=>
```


 
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

  * Наполняю таблица orders:
```shell
insert into orders values (default, 'Шоколад', 10);
insert into orders values (default, 'Принтер', 3000);
insert into orders values (default, 'Книга', 500);
insert into orders values (default, 'Монитор', 7000);
insert into orders values (default, 'Гитара', 4000);
```

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

  * Наполняю таблицу clients данными:
```shell
insert into clients values (default, 'Петров Петр Петрович', 'USA');
insert into clients values (default, 'ПИванов Иван Иванович', 'USA');
insert into clients values (default, 'Иоганн Себастьян Бах', 'Japan');
insert into clients values (default, 'Ронии Джеймс Дио', 'Russa');
insert into clients values (default, 'Ritchie Blackmore', 'Russia');
```

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 

- приведите в ответе:
    - запросы 
    - результаты их выполнения.
  * Вычисляю количество записей для таблицы orders:
```shell
select count(*) from orders;

count|
-----+
    5|
```
  * Вычисляю количество записей для таблицы clients:
```shell
select count(*) from clients;

count|
-----+
    6|
```
 

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

```shell
UPDATE clients
SET zakaz=3
WHERE id=1;

UPDATE clients
SET zakaz=3
WHERE id=2;

UPDATE clients
SET zakaz=5
WHERE id=4;


```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```shell

select * from clients where zakaz<>0;

id|fio                 |country|zakaz|
--+--------------------+-------+-----+
 2|Петров Петр Петрович|USA    |    4|
 1|Иванов Иван Иванович|USA    |    3|
 4|Иоганн Себастьян Бах|Japan  |    5|

```
 Подсказка - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

```shell
explain (analyze, buffers) select * from clients where zakaz<>0;
```

Приведите получившийся результат и объясните что значат полученные значения.

```shell
QUERY PLAN                                                                                          |
----------------------------------------------------------------------------------------------------+
Seq Scan on clients  (cost=0.00..13.00 rows=239 width=300) (actual time=0.020..0.022 rows=3 loops=1)|
  Filter: (zakaz <> 0)                                                                              |
  Rows Removed by Filter: 3                                                                         |
  Buffers: shared hit=1                                                                             |
Planning Time: 0.073 ms                                                                             |
Execution Time: 0.036 ms                                                                            |
```


## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
```root@dpopov-test:~# pg_dump -U postgres -W -h 10.93.19.52 test_db > /home/dpopov/virt-homeworks/05-virt-03-docker/Psql/replica/test_db
Password:
root@dpopov-test:~#
root@dpopov-test:~# ls -al /home/dpopov/virt-homeworks/05-virt-03-docker/Psql/replica/test_db
-rw-r--r-- 1 root root 3844 May 30 20:05 /home/dpopov/virt-homeworks/05-virt-03-docker/Psql/replica/test_db
root@dpopov-test:~#


```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

```shell
root@dpopov-test:~# docker container ls
CONTAINER ID   IMAGE                   COMMAND                  CREATED       STATUS       PORTS                                       NAMES
1ce5d304ae02   postgres:12-bullseye    "docker-entrypoint.s…"   7 days ago    Up 7 days    0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres12
12ffc48ed796   rowhe/ansible:v.12345   "bash"                   5 weeks ago   Up 5 weeks                                               ansible_12345
2a6332303d02   rowhe/debian:v.12345    "/bin/bash"              5 weeks ago   Up 5 weeks                                               debian_12345
d59dd233b6db   rowhe/centos:v.12345    "/usr/sbin/init"         5 weeks ago   Up 5 weeks                                               centos_v.12345
4c708c7864b0   rowhe/nginx:1.21.6      "/docker-entrypoint.…"   5 weeks ago   Up 5 weeks   0.0.0.0:80->80/tcp, :::80->80/tcp           my_nginx

root@dpopov-test:~# docker container stop 1ce5d304ae02
1ce5d304ae02
root@dpopov-test:~#
```

Поднимите новый пустой контейнер с PostgreSQL.
```shell
root@dpopov-test:~# sudo docker run -d --name empty_postgres12 -p 5432:5432 -e POSTGRES_PASSWORD=password -e PGDATA=/var/lib/postgresql/data/pgdata -v /home/dpopov/virt-homeworks/05-virt-03-docker/Psql/replica/:/var/lib/postgreslq/backup postgres:12-bullseye
0c8c675f17c8b4b7db2e98d2fd21094c3ed0732289057ebbfa1fe03be2c8a78c
root@dpopov-test:~#
```

Восстановите БД test_db в новом контейнере.

  * Подключаемся к пустой базе данных и создаем test_db:
```shell
create database test_db;
```

  * Заливаем наш дамп в пустую базу данные test_db:

```shell
root@dpopov-test:~# psql -d test_db -f /home/dpopov/virt-homeworks/05-virt-03-docker/Psql/replica/test_db -h 10.93.19.52 -U postgres
Password for user postgres:
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 6
COPY 5
 setval
--------
      6
(1 row)

 setval
--------
      5
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE
root@dpopov-test:~#

```

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
