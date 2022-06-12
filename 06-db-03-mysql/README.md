# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

    * Запускаю контейнер:
```shell
dpopov@dpopov-test:~/virt-homeworks/06-db-03-mysql$ sudo docker pull mysql:8.0
8.0: Pulling from library/mysql
c1ad9731b2c7: Pull complete
54f6eb0ee84d: Pull complete
cffcf8691bc5: Pull complete
89a783b5ac8a: Pull complete
6a8393c7be5f: Pull complete
af768d0b181e: Pull complete
810d6aaaf54a: Pull complete
2e014a8ae4c9: Pull complete
a821425a3341: Pull complete
3a10c2652132: Pull complete
4419638feac4: Pull complete
681aeed97dfe: Pull complete
Digest: sha256:548da4c67fd8a71908f17c308b8ddb098acf5191d3d7694e56801c6a8b2072cc
Status: Downloaded newer image for mysql:8.0
docker.io/library/mysql:8.0
dpopov@dpopov-test:~/virt-homeworks/06-db-03-mysql$  sudo docker image ls -a
REPOSITORY   TAG       IMAGE ID       CREATED      SIZE
mysql        8.0       65b636d5542b   5 days ago   524MB
dpopov@dpopov-test:~/virt-homeworks/06-db-03-mysql$ sudo docker run -d --name test_mysql8 -e MYSQL_ROOT_PASSWORD=password -v /home/dpopov/virt-homeworks/06-db-03-mysql/volume1:/var/lib/mysql -p 3306:3306 65b636d5542b
9ed9caa003b7e257617de43d549835038fa989953596174c5ce65c1a33ed7a48
dpopov@dpopov-test:~/virt-homeworks/06-db-03-mysql$ sudo docker container ls -a
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                                  NAMES
9ed9caa003b7   65b636d5542b   "docker-entrypoint.s…"   15 seconds ago   Up 14 seconds   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   test_mysql8
dpopov@dpopov-test:~/virt-homeworks/06-db-03-mysql$
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

  * Подключаюсь к контейнеру, чтобы восстановить БД:
```shell
sudo docker exec -it test_mysql8 bash
```
  * Восстанавливаю базу:
```shell
/var/lib/mysql/test_data# mysql -u root -p test_db < /var/lib/mysql/test_data/test_dump.sql
Enter password:
root@9ed9caa003b7:/var/lib/mysql/test_data#
```

Перейдите в управляющую консоль `mysql` внутри контейнера.
```shell

root@9ed9caa003b7:/var/lib/mysql/test_data# mysql -u root -p test_db < /var/lib/mysql/test_data/test_dump.sql
Enter password:
root@9ed9caa003b7:/var/lib/mysql/test_data# exit
dpopov@dpopov-test:~/virt-homeworks/06-db-03-mysql$ sudo docker exec -it test_mysql8 bash
[sudo] password for dpopov:
root@9ed9caa003b7:/# mysql -u root -p test_db
Enter password:
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 23
Server version: 8.0.29 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

Используя команду `\h` получите список управляющих команд.

```shell
root@9ed9caa003b7:/# mysql -u root -p test_db
Enter password:
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 23
Server version: 8.0.29 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.
ssl_session_data_print Serializes the current SSL session data to stdout or file

For server side help, type 'help contents'

```

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

```
mysql> \s
--------------
`mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)`

...
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.
```shell
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql>
```

**Приведите в ответе** количество записей с `price` > 300.

```shell
mysql> select * from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

mysql>

```


В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

  * Загружаем плагин контроля подключений:
```shell

INSTALL PLUGIN 
INSTALL PLUGIN CONNECTION_CONTROL
  SONAME 'connection_control.so';
INSTALL PLUGIN CONNECTION_CONTROL_FAILED_LOGIN_ATTEMPTS
  SONAME 'connection_control.so';
```
  * или добавляем в my.cnf c с последующей перезагрузкой mysql :

```shell
[mysqld]
default-authentication-plugin=mysql_native_password
plugin-load-add=connection_control.so

```
  * Создаем пользователя:
```shell
CREATE USER test
IDENTIFIED WITH mysql_native_password BY 'password'
WITH MAX_QUERIES_PER_HOUR 100
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 3
ATTRIBUTE '{"Name":"John","sName": "Pretty"}';
```
Предоставьте привилегии пользователю `test` на операции SELECT базы `test_db`.

  * Даем пользователю test право на выполнение запроса SELECT:

```shell
mysql> grant SELECT on * to test;
Query OK, 0 rows affected (0.06 sec)

mysql> flush privileges;
Query OK, 0 rows affected (0.03 sec)

mysql> show grants for test;
+-------------------------------------------+
| Grants for test@%                         |
+-------------------------------------------+
| GRANT USAGE ON *.* TO `test`@`%`          |
| GRANT SELECT ON `test_db`.* TO `test`@`%` |
+-------------------------------------------+
2 rows in set (0.00 sec)

mysql>
```
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

  * Получаем информацию по пользователю test:

```shell
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+------+-------------------------------------+
| USER | HOST | ATTRIBUTE                           |
+------+------+-------------------------------------+
| test | %    | {"Name": "John", "sName": "Pretty"} |
+------+------+-------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

```shell
mysql> set profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> show profile;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000349 |
| Executing hook on transaction  | 0.000013 |
| starting                       | 0.000326 |
| checking permissions           | 0.000015 |
| checking permissions           | 0.000012 |
| Opening tables                 | 0.001905 |
| init                           | 0.000021 |
| System lock                    | 0.000069 |
| optimizing                     | 0.000065 |
| statistics                     | 0.000305 |
| preparing                      | 0.000138 |
| executing                      | 0.000169 |
| checking permissions           | 0.000307 |
| end                            | 0.000024 |
| query end                      | 0.000021 |
| waiting for handler commit     | 0.000034 |
| closing tables                 | 0.000038 |
| freeing items                  | 0.000100 |
| cleaning up                    | 0.000023 |
+--------------------------------+----------+
19 rows in set, 1 warning (0.00 sec)

mysql>
```
Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.
```shell

mysql> show table status where name  = 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | MyISAM |      10 | Dynamic    |    5 |             31 |         156 | 281474976710655 |         2048 |         0 |              6 | 2022-06-02 10:44:15 | 2022-06-02 10:44:15 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)

mysql>

```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

```shell
mysql> alter table orders engine = InnoDB;
Query OK, 5 rows affected (0.95 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profile;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000362 |
| Executing hook on transaction  | 0.000034 |
| starting                       | 0.000030 |
| checking permissions           | 0.000012 |
| checking permissions           | 0.000009 |
| init                           | 0.000019 |
| Opening tables                 | 0.000370 |
| setup                          | 0.000211 |
| creating table                 | 0.000112 |
| After create                   | 0.000069 |
| System lock                    | 0.000009 |
| preparing for alter table      | 0.236796 |
| altering table                 | 0.085166 |
| committing alter table to stor | 0.691397 |
| end                            | 0.000084 |
| waiting for handler commit     | 0.000012 |
| waiting for handler commit     | 0.234709 |
| query end                      | 0.000026 |
| closing tables                 | 0.000007 |
| waiting for handler commit     | 0.000021 |
| freeing items                  | 0.000044 |
| cleaning up                    | 0.000018 |
+--------------------------------+----------+
22 rows in set, 1 warning (0.00 sec)

mysql> alter table orders engine = MyISAM;
Query OK, 5 rows affected (1.00 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profile;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000145 |
| Executing hook on transaction  | 0.000011 |
| starting                       | 0.000037 |
| checking permissions           | 0.000021 |
| checking permissions           | 0.000010 |
| init                           | 0.000035 |
| Opening tables                 | 0.000577 |
| setup                          | 0.000165 |
| creating table                 | 0.001366 |
| waiting for handler commit     | 0.000019 |
| waiting for handler commit     | 0.081330 |
| After create                   | 0.000879 |
| System lock                    | 0.000024 |
| copy to tmp table              | 0.000172 |
| waiting for handler commit     | 0.000013 |
| waiting for handler commit     | 0.000020 |
| waiting for handler commit     | 0.000046 |
| rename result table            | 0.000123 |
| waiting for handler commit     | 0.207892 |
| waiting for handler commit     | 0.000022 |
| waiting for handler commit     | 0.076636 |
| waiting for handler commit     | 0.000029 |
| waiting for handler commit     | 0.199747 |
| waiting for handler commit     | 0.000023 |
| waiting for handler commit     | 0.074439 |
| end                            | 0.285030 |
| query end                      | 0.066138 |
| closing tables                 | 0.000024 |
| waiting for handler commit     | 0.000037 |
| freeing items                  | 0.000041 |
| cleaning up                    | 0.000067 |
+--------------------------------+----------+
31 rows in set, 1 warning (0.00 sec)

mysql>
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

  * Проверяем наличие свободной памяти:
```shell
root@9ed9caa003b7:/etc/mysql# cat /proc/meminfo
MemTotal:        8142732 kB
MemFree:         1013856 kB
MemAvailable:    6001332 kB
```
  * Устанавливаем параметры в `my.cnf`
```shell
innodb_file_per_table = 1
innodb_file_format = Barracuda
innodb_flush_method = O_DIRECT
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 1048576
innodb_log_file_size = 104857600
innodb_default_row_format = COMPRESSED
```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
