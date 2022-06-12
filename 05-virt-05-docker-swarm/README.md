# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

Дайте письменные ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
    * При работе в режиме `replicated` копии сервиса запускаются в указанном нами количестве, в то время как при работе в режиме `global` копия сервиса будет запущена на каждом воркере кластера docker-swarm.
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
    * Для выбора лидера применяется алгоритм Raft Consensus. Он позволяет менеджерам кластера продолжать управлять кластером в случает отказа лидера при помощи выбора нового лидера среди действующих менеджеров.
- Что такое Overlay Network?
    * Эта сеть создается между демонами Docker поверх сети хоста и позволяет демонам Docker взаимодействовать между собой.

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```
* Вывод этой команды даст нам следующую информацию:
```shell
[root@node02 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
vu920w2vyppjt2355s2pb20b4     node01.netology.yc   Ready     Active         Reachable        20.10.14
l9hmj3tp48eacxqx6bqbspnu8 *   node02.netology.yc   Ready     Active         Reachable        20.10.14
odgupbg1zhuz1vl1mzawq3yy5     node03.netology.yc   Ready     Active         Leader           20.10.14
qxxj6ncmx94eb2i8um5o31u1r     node04.netology.yc   Ready     Active                          20.10.14
v8ie1jgjaz74j654i0pqwq813     node05.netology.yc   Ready     Active                          20.10.14
iuakr8fx3j2igx4wp8lrw2yhk     node06.netology.yc   Ready     Active                          20.10.14
[root@node02 ~]#
```

## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```
* Получаем такой вывод:
```shell
[root@node02 ~]#  docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
246pl3c1shjd   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
c4f663tksnoh   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
97u9kt8s4vfa   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
ssxqs3gci9zr   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
uspmumvr1dkp   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
hbwvoa0eqsb9   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
04xtedjgw9nv   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
rwb1798759yk   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
[root@node02 ~]#

```
## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```
* Вывод:
```shell
 [root@node02 ~]# docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-6NsWlHFvxeMs1uoCnFVVY48rkwtceUejwI5Gxed5gKI

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
[root@node02 ~]#
```

* Параметр  `--autolock=true` применяется для защиты данных кластера Docker Swarm от взлома и изменения конфигурации. Для этого используется TLS ключ, который потребуется ввести в случае перезапуска кластера. С его помощью будут расшифрованы логи менеджеров кластера и комуникация между нодами кластера. 
