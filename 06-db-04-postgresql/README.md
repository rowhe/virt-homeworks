# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
```shell
$ sudo docker run --name postgres13 -d -e POSTGRES_PASSWORD=password -v /home/dpopov/virt-homeworks/06-db-04-postgresql/postgres/13/bullseye/volume1:/var/lib/postgras/data -p 5432:5432 postgres:13-bullseye
345dd901f11f1e601ade16fcf5132619eaa1e751651c37acf917499368ba5b6d
$ sudo docker container ls -a
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS         PORTS                                       NAMES
345dd901f11f   postgres:13-bullseye   "docker-entrypoint.s…"   10 seconds ago   Up 9 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres13
$
```

Подключитесь к БД PostgreSQL используя `psql`.

```shell
$ sudo docker exec -it postgres13 bash
root@345dd901f11f:/# psql postgres postgres
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

postgres=#
```
Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД

  * Выведем список БД
```shell
postgres=# \l+
                                                                   List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   |  Size   | Tablespace |                Description
-----------+----------+----------+------------+------------+-----------------------+---------+------------+--------------------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |                       | 7901 kB | pg_default | default administrative connection database
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | unmodifiable empty database
           |          |          |            |            | postgres=CTc/postgres |         |            |
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +| 7753 kB | pg_default | default template for new databases
           |          |          |            |            | postgres=CTc/postgres |         |            |
(3 rows)

postgres=#
```
- подключения к БД

  * Выведем список подключений к БД
```shell
postgres=# SELECT pid, usename, datname,backend_start FROM pg_stat_activity WHERE state = 'active';
 pid | usename  | datname  |         backend_start
-----+----------+----------+-------------------------------
  76 | postgres | postgres | 2022-06-05 13:49:18.795259+00
(1 row)

postgres=#
```
- вывода списка таблиц

  * Получаем список таблиц
```shell
postgres=# \d
Did not find any relations.
postgres=# \dS+
                                            List of relations
   Schema   |              Name               | Type  |  Owner   | Persistence |    Size    | Description
------------+---------------------------------+-------+----------+-------------+------------+-------------
 pg_catalog | pg_aggregate                    | table | postgres | permanent   | 56 kB      |
 pg_catalog | pg_am                           | table | postgres | permanent   | 40 kB      |
 pg_catalog | pg_amop                         | table | postgres | permanent   | 80 kB      |
 pg_catalog | pg_amproc                       | table | postgres | permanent   | 64 kB      |
 pg_catalog | pg_attrdef                      | table | postgres | permanent   | 8192 bytes |
 pg_catalog | pg_attribute                    | table | postgres | permanent   | 456 kB     |
...
```
- вывода описания содержимого таблиц

  * Выводим описание содержания таблицы pg_user
```shell
postgres=# \dS+ pg_user
                                     View "pg_catalog.pg_user"
    Column    |           Type           | Collation | Nullable | Default | Storage  | Description
--------------+--------------------------+-----------+----------+---------+----------+-------------
 usename      | name                     |           |          |         | plain    |
 usesysid     | oid                      |           |          |         | plain    |
 usecreatedb  | boolean                  |           |          |         | plain    |
 usesuper     | boolean                  |           |          |         | plain    |
 userepl      | boolean                  |           |          |         | plain    |
 usebypassrls | boolean                  |           |          |         | plain    |
 passwd       | text                     |           |          |         | extended |
 valuntil     | timestamp with time zone |           |          |         | plain    |
 useconfig    | text[]                   | C         |          |         | extended |
View definition:
 SELECT pg_shadow.usename,
    pg_shadow.usesysid,
    pg_shadow.usecreatedb,
    pg_shadow.usesuper,
    pg_shadow.userepl,
    pg_shadow.usebypassrls,
    '********'::text AS passwd,
    pg_shadow.valuntil,
    pg_shadow.useconfig
   FROM pg_shadow;

```
- выхода из psql
  * Выходим из PostgreSQL
```shell
postgres=# \q
root@3f436e369edf:/#

```

## Задача 2

Используя `psql` создайте БД `test_database`.
* Создаем базу данных
```shell
postgres=# create database test_database;
CREATE DATABASE
postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

postgres=#
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

- Восстановите бэкап БД в `test_database`.

  * Восстанавливаем базу из `test_dump.sql`
```shell
root@3f436e369edf:/# psql test_database postgres < /var/lib/postgresql/data/test_dump.sql
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
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
root@3f436e369edf:/#
```

- Перейдите в управляющую консоль `psql` внутри контейнера.

- Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

  * Подключаемся к восстановленной базе `test_database` и проводим ANALYZE таблицы orders
```shell
root@3f436e369edf:/# psql test_database postgres
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

test_database=# ANALYZE verbose orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=#
```

- Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
```shell
test_database=# SELECT attname, avg_width  from  pg_stats where tablename='orders' order by avg_width desc limit 1;
 attname | avg_width
---------+-----------
 title   |        16
(1 row)

test_database=#

```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

- Предложите SQL-транзакцию для проведения данной операции.
    * Выполняем транзакции для создания отдельных таблиц и правил для них
```shell
create table orders_1 (check (price > 499 )) inherits (orders);
create table orders_2 (check (price <= 499)) inherits (orders);
create rule check_price_gt_499 as on insert to orders where (price > 499) do instead insert into orders_1 values (new.*);
create rule check_price_lt_or_eq_499 as on insert to orders where (price <= 499) do instead insert into orders_2 values (new.*);
```
* 
    * Проверям корректность работы разбиения таблиц
```shell
insert into orders (id, title, price) values (default, 'bow', 500);
insert into orders (id, title, price) values (default, 'arrows', 300);

test_database=# select * from orders;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
  9 | bow                  |   500
 10 | arrows               |   300
(10 rows)

test_database=#

test_database=# select * from orders_1;
 id | title | price
----+-------+-------
  9 | bow   |   500
(1 row)

test_database=# select * from orders_2;
 id | title  | price
----+--------+-------
 10 | arrows |   300
(1 row)

test_database=#

```
* 
  * Также можно проанализировать как выполняется наш запрос
```shell
test_database=# explain analyze select * from orders;
                                                      QUERY PLAN
----------------------------------------------------------------------------------------------------------------------
 Append  (cost=0.00..32.52 rows=768 width=184) (actual time=0.047..0.074 rows=10 loops=1)
   ->  Seq Scan on orders orders_1  (cost=0.00..1.08 rows=8 width=24) (actual time=0.046..0.048 rows=8 loops=1)
   ->  Seq Scan on orders_1 orders_2  (cost=0.00..13.80 rows=380 width=186) (actual time=0.009..0.009 rows=1 loops=1)
   ->  Seq Scan on orders_2 orders_3  (cost=0.00..13.80 rows=380 width=186) (actual time=0.003..0.003 rows=1 loops=1)
 Planning Time: 0.241 ms
 Execution Time: 0.143 ms
(6 rows)

test_database=#
```

- Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
    * Ручного разбиения таблиц можно избежать при помощи заблаговременной настройки рашдинга с использованием `EXTENTION postgres_fdw`


## Задача 4

- Используя утилиту `pg_dump` создайте бекап БД `test_database`.
  * Делаем дамп
```shell
root@3f436e369edf:/# pg_dump -U postgres test_database > /var/lib/postgresql/data/my_test_database.sql
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
  * Для добавления уникальности столбцу `title` в файл дампа следует добавить следующие команды

```shell
--
-- Name: orders_1 order1_constr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_1
    ADD CONSTRAINT order1_constr UNIQUE (title);


--
-- Name: orders_2 order2_constr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_2
    ADD CONSTRAINT order2_constr UNIQUE (title);


--
-- Name: orders order_constr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT order_constr UNIQUE (title);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);



```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
