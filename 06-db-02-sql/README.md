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

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

  * Создаю базу данных, пользователей и таблицы:
```commandline
create database test_db;
create user test_admin_user with encrypted password 'password';
create table orders (id serial primary key, наименование varchar, цена int);
create table clients (id serial primary key, фамилия varchar, страна varchar, заказ int, foreign key (заказ) references orders (id));
grant all privileges on database test_db to test_admin_user;
create user test_sipmle_user with encrypted password 'password';
grant select,insert,update,delete on table orders to test_sipmle_user;
grant select,insert,update,delete on table clients to test_sipmle_user;
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

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
