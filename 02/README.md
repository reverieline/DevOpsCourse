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
