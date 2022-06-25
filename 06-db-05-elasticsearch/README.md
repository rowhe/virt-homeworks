# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [elasticsearch:7](https://hub.docker.com/_/elasticsearch) как базовый:

- составьте Dockerfile-манифест для elasticsearch
    * Файл `Dockerfile` может выглядеть следующим образом:
```shell
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN  apt update && \
    apt install --no-install-recommends -y gnupg && \
    apt install --no-install-recommends -y  openjdk-8-jdk && \
    apt install --no-install-recommends -y curl && \
    (curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elastic.gpg) && \
    (echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list) && \
    apt update && \
    apt install --no-install-recommends -y elasticsearch && \
    rm -rf /var/cache/* && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/share/elasticsearch
COPY elasticsearch.yml /etc/elasticsearch/

RUN set -ex && for path in data logs config config/scripts; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch /usr/share/elasticsearch; \
    done

USER elasticsearch

ENV PATH=$PATH:/usr/share/elasticsearch/bin

CMD ["elasticsearch"]

EXPOSE 9200 9300
```
  * Файл конфигурации `elasticsearch.yml`
```shell
node.name: "netology_test"
node.master: true
node.data: true

path:
  data: /var/lib/elasticsearch/data
  logs: /var/lib/elasticsearch/logs
cluster.name: "netology_cluster"
network.host: 0.0.0.0
discovery.seed_hosts:
  - 0.0.0.0:9300
discovery.type: single-node
```

- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
  * Собираю образ
```shell
dpopov@dpopov-test:$ sudo docker build -t rowhe:es7 .
Sending build context to Docker daemon  16.38kB
Step 1/10 : FROM ubuntu:22.04
22.04: Pulling from library/ubuntu
405f018f9d1d: Pull complete
Digest: sha256:b6b83d3c331794420340093eb706a6f152d9c1fa51b262d9bf34594887c2c7ac
Status: Downloaded newer image for ubuntu:22.04
 ---> 27941809078c
Step 2/10 : ENV DEBIAN_FRONTEND=noninteractive
 ---> Running in c3df1289477e
Removing intermediate container c3df1289477e
 ---> 498e8df2988e
...
...
Successfully built 6d7660bfd6bf
Successfully tagged rowhe:es7

```
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины
  * Запускаем получившийся контейнер
```shell
dpopov@dpopov-test:~$ sudo docker run -d --rm --name es7 -p 9200:9200 -p 9300:9300 -v esdata1:/var/lib/elasticsearch rowhe:es7
```
  * Проверяем, что о запустился
```shell
dpopov@dpopov-test:~$ sudo docker container ls -a
CONTAINER ID   IMAGE       COMMAND           CREATED          STATUS          PORTS                                                                                  NAMES
7894ad1318b0   rowhe:es7   "elasticsearch"   26 seconds ago   Up 24 seconds   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   es7
dpopov@dpopov-test:~$
```
  * Запрашиваем запрос `curl -XGET localhost:9200/`  и получаем следующий вывод:
```shell
{
  "name" : "netology_test",
  "cluster_name" : "netology_cluster",
  "cluster_uuid" : "vUUOh8DTRiWoHTVsVKAv9Q",
  "version" : {
    "number" : "7.17.4",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "79878662c54c886ae89206c685d9f1051a9d6411",
    "build_date" : "2022-05-18T18:04:20.964345128Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib` 
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения
- обратите внимание на настройки безопасности такие как `xpack.security.enabled` 
- если докер образ не запускается и падает с ошибкой 137 в этом случае может помочь настройка `-e ES_HEAP_SIZE`
- при настройке `path` возможно потребуется настройка прав доступа на директорию

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

  * Создаем индексы
```shell
dpopov@dpopov-test:~$ curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   130  100    64  100    66     75     77 --:--:-- --:--:-- --:--:--   153
{
  "acknowledged": true,
  "shards_acknowledged": true,
  "index": "ind-1"
}
dpopov@dpopov-test:~$ curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   130  100    64  100    66     41     43  0:00:01  0:00:01 --:--:--    85
{
  "acknowledged": true,
  "shards_acknowledged": true,
  "index": "ind-2"
}
dpopov@dpopov-test:~/$ curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   130  100    64  100    66     36     37  0:00:01  0:00:01 --:--:--    74
{
  "acknowledged": true,
  "shards_acknowledged": true,
  "index": "ind-3"
}
```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
  * Получаем список индексов и их статусов
```shell
dpopov@dpopov-test:~$ curl -XGET localhost:9200/_cat/indices/ind-*?v=true&s=index
[1] 2842290
dpopov@dpopov-test:~$ health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 3WCb67tITIqJ61zlGMI7Zg   1   0          0            0       226b           226b
yellow open   ind-3 PHcoR4fBTUWlIuq6p9UrQA   4   2          0            0       904b           904b
yellow open   ind-2 eWp06Y13QkWx_2YzgQPXMA   2   1          0            0       452b           452b

dpopov@dpopov-test:~$ curl -XGET localhost:9200/_cluster/health/ind-1?pretty|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   469  100   469    0     0  93800      0 --:--:-- --:--:-- --:--:--  114k
{
  "cluster_name": "netology_cluster",
  "status": "green",
  "timed_out": false,
  "number_of_nodes": 1,
  "number_of_data_nodes": 1,
  "active_primary_shards": 1,
  "active_shards": 1,
  "relocating_shards": 0,
  "initializing_shards": 0,
  "unassigned_shards": 0,
  "delayed_unassigned_shards": 0,
  "number_of_pending_tasks": 0,
  "number_of_in_flight_fetch": 0,
  "task_max_waiting_in_queue_millis": 0,
  "active_shards_percent_as_number": 100
}
dpopov@dpopov-test:~$ curl -XGET localhost:9200/_cluster/health/ind-2?pretty|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   469  100   469    0     0  78166      0 --:--:-- --:--:-- --:--:-- 78166
{
  "cluster_name": "netology_cluster",
  "status": "yellow",
  "timed_out": false,
  "number_of_nodes": 1,
  "number_of_data_nodes": 1,
  "active_primary_shards": 2,
  "active_shards": 2,
  "relocating_shards": 0,
  "initializing_shards": 0,
  "unassigned_shards": 2,
  "delayed_unassigned_shards": 0,
  "number_of_pending_tasks": 0,
  "number_of_in_flight_fetch": 0,
  "task_max_waiting_in_queue_millis": 0,
  "active_shards_percent_as_number": 50
}
dpopov@dpopov-test:~$ curl -XGET localhost:9200/_cluster/health/ind-3?pretty|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   469  100   469    0     0  52111      0 --:--:-- --:--:-- --:--:-- 52111
{
  "cluster_name": "netology_cluster",
  "status": "yellow",
  "timed_out": false,
  "number_of_nodes": 1,
  "number_of_data_nodes": 1,
  "active_primary_shards": 4,
  "active_shards": 4,
  "relocating_shards": 0,
  "initializing_shards": 0,
  "unassigned_shards": 8,
  "delayed_unassigned_shards": 0,
  "number_of_pending_tasks": 0,
  "number_of_in_flight_fetch": 0,
  "task_max_waiting_in_queue_millis": 0,
  "active_shards_percent_as_number": 50
}

```

Получите состояние кластера `elasticsearch`, используя API.
  * Получаем информацию о состоянии кластера
```shell
dpopov@dpopov-test:~$ curl -XGET localhost:9200/_cluster/health/ind-1?pretty
{
  "cluster_name" : "netology_cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}

```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

  * Статус `yellow` для индексов указывает, что количество реплик не совпадает с количеством нод

Удалите все индексы.
  * Удаляем все индексы 
```shell
dpopov@dpopov-test:~$ curl -XDELETE localhost:9200/ind-1|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    21  100    21    0     0     80      0 --:--:-- --:--:-- --:--:--    80
{
  "acknowledged": true
}
dpopov@dpopov-test:~$ curl -XDELETE localhost:9200/ind-2|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    21  100    21    0     0     61      0 --:--:-- --:--:-- --:--:--    61
{
  "acknowledged": true
}
dpopov@dpopov-test:~$ curl -XDELETE localhost:9200/ind-3|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    21  100    21    0     0     96      0 --:--:-- --:--:-- --:--:--    96
{
  "acknowledged": true
}

```
**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`. 
  * Сперва добавляем в `elasticsearch.yml` следующую настройку
```shell

repo:
    - /usr/share/elasticsearch/snapshots
```
  * Заходим в контейнер и создаем директорию `snapshots`
```shell
dpopov@dpopov-test:~$ sudo docker exec -it es7 mkdir snapshots
dpopov@dpopov-test:~$ sudo docker exec -it es7 ls -al
total 680
drwxr-xr-x 1 elasticsearch elasticsearch   4096 Jun 25 17:24 .
drwxr-xr-x 1 root          root            4096 Jun 25 16:29 ..
-rw-rw-r-- 1 elasticsearch elasticsearch 640930 May 18 18:09 NOTICE.txt
-rw-r--r-- 1 elasticsearch elasticsearch   2710 May 18 18:09 README.asciidoc
drwxr-xr-x 1 elasticsearch elasticsearch   4096 Jun 25 16:29 bin
drwxr-xr-x 3 elasticsearch elasticsearch   4096 Jun 25 16:30 config
drwxr-xr-x 2 elasticsearch elasticsearch   4096 Jun 25 16:30 data
drwxr-xr-x 1 elasticsearch elasticsearch   4096 Jun 25 16:29 jdk
drwxr-xr-x 1 elasticsearch elasticsearch   4096 Jun 25 16:29 lib
drwxr-xr-x 2 elasticsearch elasticsearch   4096 Jun 25 16:30 logs
drwxr-xr-x 1 elasticsearch elasticsearch   4096 Jun 25 16:29 modules
drwxr-xr-x 1 elasticsearch elasticsearch   4096 May 18 18:09 plugins
drwxr-xr-x 2 elasticsearch elasticsearch   4096 Jun 25 17:24 snapshots

```
Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.
  * Регистрируем директорию `snapshots`
```shell
dpopov@dpopov-test:~$ curl -X PUT localhost:9200/_snapshot/netology_backup -H 'Content-Type: application/json' -d'{ "type": "fs", "settings": { "location": "/usr/share/elasticsearch/snapshots" }}'|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   102  100    21  100    81     38    149 --:--:-- --:--:-- --:--:--   187
{
  "acknowledged": true
}

```

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
  * Создаем индекс `test`
```shell
dpopov@dpopov-test:~$ curl -XPUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   129  100    63  100    66     77     81 --:--:-- --:--:-- --:--:--   159
{
  "acknowledged": true,
  "shards_acknowledged": true,
  "index": "test"
}
dpopov@dpopov-test:~$ curl -XGET localhost:9200/test?pretty
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1656182113302",
        "number_of_replicas" : "0",
        "uuid" : "_hDda00gQI-R3NKCF7Op1Q",
        "version" : {
          "created" : "7170499"
        }
      }
    }
  }
}

```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.
  * Создаем снапшот кластера
```shell
dpopov@dpopov-test:~$ curl -XPUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true |jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   717  100   717    0     0    209      0  0:00:03  0:00:03 --:--:--   209
{
  "snapshot": {
    "snapshot": "elasticsearch",
    "uuid": "HL1JrByrRh-IDA3wrg8iiw",
    "repository": "netology_backup",
    "version_id": 7170499,
    "version": "7.17.4",
    "indices": [
      ".geoip_databases",
      ".ds-ilm-history-5-2022.06.25-000001",
      ".ds-.logs-deprecation.elasticsearch-default-2022.06.25-000001",
      "test"
    ],
    "data_streams": [
      "ilm-history-5",
      ".logs-deprecation.elasticsearch-default"
    ],
    "include_global_state": true,
    "state": "SUCCESS",
    "start_time": "2022-06-25T20:17:46.561Z",
    "start_time_in_millis": 1656188266561,
    "end_time": "2022-06-25T20:17:49.163Z",
    "end_time_in_millis": 1656188269163,
    "duration_in_millis": 2602,
    "failures": [],
    "shards": {
      "total": 4,
      "failed": 0,
      "successful": 4
    },
    "feature_states": [
      {
        "feature_name": "geoip",
        "indices": [
          ".geoip_databases"
        ]
      }
    ]
  }
}

```

**Приведите в ответе** список файлов в директории со `snapshot`ами.
  * Выводим список файлов из директории `snapshots`
```shell
dpopov@dpopov-test:~$ sudo docker exec es7 ls -al snapshots
total 56
drwxr-xr-x 3 elasticsearch elasticsearch  4096 Jun 25 20:17 .
drwxr-xr-x 1 elasticsearch elasticsearch  4096 Jun 25 19:54 ..
-rw-r--r-- 1 elasticsearch elasticsearch  1425 Jun 25 20:17 index-2
-rw-r--r-- 1 elasticsearch elasticsearch     8 Jun 25 20:17 index.latest
drwxr-xr-x 6 elasticsearch elasticsearch  4096 Jun 25 20:17 indices
-rw-r--r-- 1 elasticsearch elasticsearch 29257 Jun 25 20:17 meta-HL1JrByrRh-IDA3wrg8iiw.dat
-rw-r--r-- 1 elasticsearch elasticsearch   712 Jun 25 20:17 snap-HL1JrByrRh-IDA3wrg8iiw.dat
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
  * Удаляем индекс `test`и создаем `test-2`
```shell
dpopov@dpopov-test:~$ curl -XDELETE localhost:9200/test
dpopov@dpopov-test:~$ curl -XPUT localhost:9200/test-2 -H 'Content-Type: application/json' -d ' {"settings": {"number_of_shards":1, "number_of_replicas": 0}}' | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   127  100    65  100    62     48     46  0:00:01  0:00:01 --:--:--    95
{
  "acknowledged": true,
  "shards_acknowledged": true,
  "index": "test-2"
}
dpopov@dpopov-test:~$ curl -XGET localhost:9200/_cat/indices
green open test-2           yuX65CmHQdmi2GEQE10D2g 1 0  0 0 226b 226b
green open .geoip_databases 8RfvgO7fRyq278crVHsPoA 1 0 40 0 38mb 38mb
```
[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 
  * Восстанавлить кластер из снапшота не удается, вываливает вот такая ошибка:
```shell
dpopov@dpopov-test:~/virt-homeworks/06-db-05-elasticsearch$ curl -XPOST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?wait_for_completion |jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   735  100   735    0     0  10652      0 --:--:-- --:--:-- --:--:-- 10652
{
  "error": {
    "root_cause": [
      {
        "type": "snapshot_restore_exception",
        "reason": "[netology_backup:elasticsearch/HL1JrByrRh-IDA3wrg8iiw] cannot restore index [.geoip_databases] because an open index with same name already exists in the cluster. Either close or delete the existing index or restore the index under a different name by providing a rename pattern and replacement name"
      }
    ],
    "type": "snapshot_restore_exception",
    "reason": "[netology_backup:elasticsearch/HL1JrByrRh-IDA3wrg8iiw] cannot restore index [.geoip_databases] because an open index with same name already exists in the cluster. Either close or delete the existing index or restore the index under a different name by providing a rename pattern and replacement name"
  },
  "status": 500
}
dpopov@dpopov-test:~/virt-homeworks/06-db-05-elasticsearch$ curl -XGET localhost:9200/_cat/indices
green open test-2           yuX65CmHQdmi2GEQE10D2g 1 0  0 0 226b 226b
green open .geoip_databases 8RfvgO7fRyq278crVHsPoA 1 0 40 0 38mb 38mb
```
  * Ни закрыть ни удалить индекс `.geoip_databases` не удается
```shell
dpopov@dpopov-test:~/virt-homeworks/06-db-05-elasticsearch$ curl -XPOST localhost:9200/.geoip_databases/_close |jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   287  100   287    0     0  31888      0 --:--:-- --:--:-- --:--:-- 31888
{
  "error": {
    "root_cause": [
      {
        "type": "illegal_argument_exception",
        "reason": "Indices [.geoip_databases] use and access is reserved for system operations"
      }
    ],
    "type": "illegal_argument_exception",
    "reason": "Indices [.geoip_databases] use and access is reserved for system operations"
  },
  "status": 400
}
dpopov@dpopov-test:~/virt-homeworks/06-db-05-elasticsearch$ curl -XDELETE localhost:9200/.geoip_databases |jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   287  100   287    0     0  57400      0 --:--:-- --:--:-- --:--:-- 57400
{
  "error": {
    "root_cause": [
      {
        "type": "illegal_argument_exception",
        "reason": "Indices [.geoip_databases] use and access is reserved for system operations"
      }
    ],
    "type": "illegal_argument_exception",
    "reason": "Indices [.geoip_databases] use and access is reserved for system operations"
  },
  "status": 400
}
```

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
