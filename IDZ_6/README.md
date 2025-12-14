# Data Vault (DDS) слой для TPC-H в Trino

## 📦 Описание проекта
Реализация Detail Data Storage (DDS) по методологии Data Vault 2.0 на основе бенчмарка TPC-H.

## 📊 Технологический стек

- **Trino** - распределенный SQL-движок
- **Docker** - контейнеризация
- **DBeaver** - SQL-клиент для подключения
- **TPC-H** - тестовые данные (схема tiny)
- **Data Vault 2.0** - методология моделирования данных

## 🚀 Быстрый старт
1. Запустите Trino в Docker
docker run --name trino -d -p 8080:8080 trinodb/trino:latest

💡 Рекомендуется использовать :latest или :449+ (поддержка to_utf8, to_hex).

2. Создайте схему и таблицы (DDS-слой)
docker exec -i trino trino --catalog memory --execute "CREATE SCHEMA IF NOT EXISTS memory.dds;"docker exec -i trino trino --catalog memory < Create_rq.sql

Проверка:

docker exec -it trino trino --catalog memory --execute "SHOW TABLES FROM memory.dds;"

3. Выполните полную загрузку (initial load)
docker exec -i trino trino --catalog memory < Insert_rq.sql

4. Инкрементальная загрузка за день

🔹 Вариант A: за указанную дату
chmod +x Incremental_rq.sh | ./Incremental_rq.sh 1997-10-10

🔹 Вариант B: за сегодняшний день
chmod +x Incremental_rq.sh | ./Incremental_rq.sh

✅ Скрипт загружает:

новые заказы (orderdate) и связанные сущности (customer, links, sat_order)

новые позиции (shipdate) и связанные сущности (partsupp, links, sat_lineitem)


## 📁 Структура файлов

1.Create_rq.sql
DDL: создание memory.dds схемы и всех таблиц 

2.Insert_rq.sql
Полная загрузка данных из tpch.tiny.* в memory.dds.*

3.Incremental_rq.sh
Bash-скрипт для инкрементальной загрузки за день

4.Incremental_rq.sql.template
Шаблон SQL с подстановкой {{LOAD_DATE}} (используется скриптом)
