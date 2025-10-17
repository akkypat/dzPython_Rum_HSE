# Итоговое задание по модулю 5 Data Vault 2.0 - Superstore Румянцев Иван

1. ## 📊 Исходные данные

**Файл:** `SampleSuperstore.csv` (9,994 записей)

**Поля:**
- `Ship Mode`, `Segment`, `Country`, `City`, `State`, `Postal Code`
- `Region`, `Category`, `Sub-Category`, `Sales`, `Quantity`, `Discount`, `Profit`

2. ## 🔄 Преобразованные данные

**Файл:** `prepared_data.csv` с бизнес-ключами:

- 'Customer_BK', 'Customer_HK',
- 'Product_BK', 'Product_HK', 
- 'Order_BK', 'Order_HK',
- 'Location_BK', 'Location_HK',
- 'ShipMode_BK', 'ShipMode_HK',
- 'Segment_BK', 'Segment_HK',
- 'Region_BK', 'Region_HK',

3. ## 🗃️ Схема Data Vault 2.0

### Хабы (7 таблиц)
- `H_CUSTOMER` - клиенты
- `H_PRODUCT` - продукты  
- `H_ORDER` - заказы
- `H_LOCATION` - локации
- `H_SHIP_MODE` - способы доставки
- `H_SEGMENT` - сегменты
- `H_REGION` - регионы

### Связи (4 таблицы)
- `LINK_SALES_TRANSACTION` - заказ + клиент + продукт + доставка
- `LINK_ORDER_LOCATION` - заказ + локация
- `LINK_CUSTOMER_SEGMENT` - клиент + сегмент  
- `LINK_LOCATION_REGION` - локация + регион

### Спутники (7 таблиц)
- `S_CUSTOMER_DETAILS` - детали клиентов
- `S_PRODUCT_DETAILS` - детали продуктов
- `S_SALES_METRICS` - метрики продаж (на связи)
- `S_LOCATION_DETAILS` - детали локаций
- Остальные: детали доставки, сегментов, регионов

4. ## 🚀 Использование

1. `python loader.py` - подготовка ключей
2. `diagram.md` - создание схемы
3. `storage_data.sql` - создание БД
