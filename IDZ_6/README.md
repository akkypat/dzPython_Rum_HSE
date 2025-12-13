📦 Data Vault (DDS) слой для TPC-H в Trino
Реализация Detail Data Storage (DDS) по методологии Data Vault 2.0 на основе бенчмарка TPC-H.

✅ Поддержка всех 8 таблиц TPC-H (customer, orders, part, supplier, partsupp, lineitem, nation, region)
✅ Корректная модель: hub_partsupp как отдельная сущность
✅ Инкрементальная загрузка по датам (orderdate, shipdate)
✅ Готов к запуску в Docker + Trino CLI
🚀 Быстрый старт
1. Запустите Trino в Docker
bash
1
docker run --name trino -d -p 8080:8080 trinodb/trino:latest

💡 Рекомендуется использовать :latest или :449+ (поддержка to_utf8, to_hex).

2. Создайте схему и таблицы (DDS-слой)
bash
12
docker exec -i trino trino --catalog memory --execute "CREATE SCHEMA IF NOT EXISTS memory.dds;"docker exec -i trino trino --catalog memory < 1.create_tables.sql

Проверка:

bash
1
docker exec -it trino trino --catalog memory --execute "SHOW TABLES FROM memory.dds;"

3. Выполните полную загрузку (initial load)
bash
1
docker exec -i trino trino --catalog memory < 2.load_full.sql

⚠️ Загрузка может занять 1–2 минуты (зависит от мощности машины).
✅ После загрузки:

hub_customer — 150 строк
hub_order — 1500 строк
hub_lineitem — 60175 строк
4. Инкрементальная загрузка за день
🔹 Вариант A: за указанную дату
bash
12
chmod +x 3.load_incremental.sh./3.load_incremental.sh 1997-10-10

🔹 Вариант B: за сегодняшний день
bash
123
./3.load_incremental.sh# или явно:./3.load_incremental.sh $(date +%Y-%m-%d)

✅ Скрипт загружает:

новые заказы (orderdate = ?) и связанные сущности (customer, links, sat_order)
новые позиции (shipdate = ?) и связанные сущности (partsupp, links, sat_lineitem)
— с дедупликацией и поддержкой SCD2 (через hash_diff).
📁 Структура файлов
Файл
Назначение
1.create_tables.sql
DDL: создание memory.dds схемы и всех таблиц (8 hubs, 7 links, 8 satellites)
2.load_full.sql
Полная загрузка данных из tpch.tiny.* в memory.dds.*
3.load_incremental.sh
Bash-скрипт для инкрементальной загрузки за день
3.load_incremental.sql.template
Шаблон SQL с подстановкой {{LOAD_DATE}} (используется скриптом)
🛠 Как работает инкрементальная загрузка
Скрипт принимает дату в формате YYYY-MM-DD (по умолчанию — сегодня).
Подставляет её в шаблон SQL (sed "s/LOAD_DATE/$DATE/g").
Выполняет INSERT с проверкой:
для hubs/links: NOT IN (SELECT *_hk FROM ...) — избегаем дублей хеш-ключей
для satellites: NOT EXISTS (... WHERE *_hk = ? AND hash_diff = ?) — SCD2, только при изменении содержимого
Источники:
заказы → tpch.tiny.orders WHERE orderdate = ?
позиции → tpch.tiny.lineitem WHERE shipdate = ?
⚠️ Требования
Docker
Bash (для инкрементального скрипта)
Trino ≥ 400 (для функций to_utf8, to_hex, md5)