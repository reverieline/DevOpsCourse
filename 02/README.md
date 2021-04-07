# Домашнее задание по СУБД PostgreSQL

1. Поднять 2 сервера PostgreSQL в конфигурации primary standby с
использованием physical streaming replication.
https://wiki.postgresql.org/wiki/Streaming_Replication
Репликация должны быть асинхронной.
Создать простую таблицу.
Заполнить таблицу при помощи generate_series и засечь время исполнения. В
это время мониторить replication lag.
Переключить репликацию на синхронную.
Заполнить таблицу при помощи generate_series и засечь время исполнения.

2. Настроить postgresql для использования с pgbadger (https://pgbadger.darold.net/)
Запустить pgbench. Сформировать отчет pgbadger.

Где запускаются инстансы postgresql - не принципиально: docker, VM. Не использовать
сервисы RDS или аналогичные.

# Solution

## Setup
The script creates two postgresql docker containers, configured to serve as primary and standby db servers.
```sh
sudo ./setup.sh
```
## Test
There are two scripts to test streaming replication in sync and async mode.
Output shows current mode of replication and timewise analysis of big insert query.
An optional argument could be used to specify number of records to be writen to the primary database during test.
```sh
sudo ./test_sync.sh
sudo ./test_async.sh 100000
```
## Report
Database statistic is available on pgBadger report.
Generated presentation is available on http://localhost:8080/postgresql.html
'''sh
sudo ./pgbadger.sh
'''
