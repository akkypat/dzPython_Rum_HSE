-- Хаб-таблицы для хранения бизнес-ключей сущностей
CREATE TABLE H_CUSTOMER (
    H_Hash_Customer VARCHAR(64) NOT NULL PRIMARY KEY,
    Customer_Id VARCHAR(50) NOT NULL,
    H_Load_Source VARCHAR(100) NOT NULL,
    H_Load_Date DATETIME NOT NULL,
    UNIQUE KEY uk_customer_id (Customer_Id)
);

-- Хаб для уникальных продуктов
CREATE TABLE H_PRODUCT (
    H_Hash_Product VARCHAR(64) NOT NULL PRIMARY KEY,
    Product_Id VARCHAR(50) NOT NULL,
    H_Load_Source VARCHAR(100) NOT NULL,
    H_Load_Date DATETIME NOT NULL,
    UNIQUE KEY uk_product_id (Product_Id)
);

-- Хаб для уникальных заказов
CREATE TABLE H_ORDER (
    H_Hash_Order VARCHAR(64) NOT NULL PRIMARY KEY,
    Order_Id VARCHAR(50) NOT NULL,
    H_Load_Source VARCHAR(100) NOT NULL,
    H_Load_Date DATETIME NOT NULL,
    UNIQUE KEY uk_order_id (Order_Id)
);

-- Хаб для уникальных локаций
CREATE TABLE H_LOCATION (
    H_Hash_Location VARCHAR(64) NOT NULL PRIMARY KEY,
    Location_Id VARCHAR(50) NOT NULL,
    H_Load_Source VARCHAR(100) NOT NULL,
    H_Load_Date DATETIME NOT NULL,
    UNIQUE KEY uk_location_id (Location_Id)
);

-- Хаб для способов доставки
CREATE TABLE H_SHIP_MODE (
    H_Hash_Ship_Mode VARCHAR(64) NOT NULL PRIMARY KEY,
    Ship_Mode_Id VARCHAR(50) NOT NULL,
    H_Load_Source VARCHAR(100) NOT NULL,
    H_Load_Date DATETIME NOT NULL,
    UNIQUE KEY uk_ship_mode_id (Ship_Mode_Id)
);

-- Хаб для сегментов клиентов
CREATE TABLE H_SEGMENT (
    H_Hash_Segment VARCHAR(64) NOT NULL PRIMARY KEY,
    Segment_Id VARCHAR(50) NOT NULL,
    H_Load_Source VARCHAR(100) NOT NULL,
    H_Load_Date DATETIME NOT NULL,
    UNIQUE KEY uk_segment_id (Segment_Id)
);

-- Хаб для регионов
CREATE TABLE H_REGION (
    H_Hash_Region VARCHAR(64) NOT NULL PRIMARY KEY,
    Region_Id VARCHAR(50) NOT NULL,
    H_Load_Source VARCHAR(100) NOT NULL,
    H_Load_Date DATETIME NOT NULL,
    UNIQUE KEY uk_region_id (Region_Id)
);

-- Линк для соединения заказов, клиентов, продуктов и способов доставки
CREATE TABLE LINK_SALES_TRANSACTION (
    L_Sales_Transaction_HK VARCHAR(64) NOT NULL PRIMARY KEY,
    H_Order_HK VARCHAR(64) NOT NULL,
    H_Customer_HK VARCHAR(64) NOT NULL,
    H_Product_HK VARCHAR(64) NOT NULL,
    H_Ship_Mode_HK VARCHAR(64) NOT NULL,
    Load_Source VARCHAR(100) NOT NULL,
    Load_Date DATETIME NOT NULL,
    UNIQUE KEY uk_sales_transaction (H_Order_HK, H_Customer_HK, H_Product_HK, H_Ship_Mode_HK),
    FOREIGN KEY (H_Order_HK) REFERENCES H_ORDER(H_Hash_Order),
    FOREIGN KEY (H_Customer_HK) REFERENCES H_CUSTOMER(H_Hash_Customer),
    FOREIGN KEY (H_Product_HK) REFERENCES H_PRODUCT(H_Hash_Product),
    FOREIGN KEY (H_Ship_Mode_HK) REFERENCES H_SHIP_MODE(H_Hash_Ship_Mode)
);

-- Линк для связи заказов с локациями
CREATE TABLE LINK_ORDER_LOCATION (
    L_Order_Location_HK VARCHAR(64) NOT NULL PRIMARY KEY,
    H_Order_HK VARCHAR(64) NOT NULL,
    H_Location_HK VARCHAR(64) NOT NULL,
    Load_Source VARCHAR(100) NOT NULL,
    Load_Date DATETIME NOT NULL,
    UNIQUE KEY uk_order_location (H_Order_HK, H_Location_HK),
    FOREIGN KEY (H_Order_HK) REFERENCES H_ORDER(H_Hash_Order),
    FOREIGN KEY (H_Location_HK) REFERENCES H_LOCATION(H_Hash_Location)
);

-- Линк для определения принадлежности клиентов к сегментам
CREATE TABLE LINK_CUSTOMER_SEGMENT (
    L_Customer_Segment_HK VARCHAR(64) NOT NULL PRIMARY KEY,
    H_Customer_HK VARCHAR(64) NOT NULL,
    H_Segment_HK VARCHAR(64) NOT NULL,
    Load_Source VARCHAR(100) NOT NULL,
    Load_Date DATETIME NOT NULL,
    UNIQUE KEY uk_customer_segment (H_Customer_HK, H_Segment_HK),
    FOREIGN KEY (H_Customer_HK) REFERENCES H_CUSTOMER(H_Hash_Customer),
    FOREIGN KEY (H_Segment_HK) REFERENCES H_SEGMENT(H_Hash_Segment)
);

-- Линк для связи локаций с регионами
CREATE TABLE LINK_LOCATION_REGION (
    L_Location_Region_HK VARCHAR(64) NOT NULL PRIMARY KEY,
    H_Location_HK VARCHAR(64) NOT NULL,
    H_Region_HK VARCHAR(64) NOT NULL,
    Load_Source VARCHAR(100) NOT NULL,
    Load_Date DATETIME NOT NULL,
    UNIQUE KEY uk_location_region (H_Location_HK, H_Region_HK),
    FOREIGN KEY (H_Location_HK) REFERENCES H_LOCATION(H_Hash_Location),
    FOREIGN KEY (H_Region_HK) REFERENCES H_REGION(H_Hash_Region)
);

-- Сателлит с детальной информацией о клиентах и историей изменений
CREATE TABLE S_CUSTOMER_DETAILS (
    H_Customer_HK VARCHAR(64) NOT NULL,
    Load_Date DATETIME NOT NULL,
    Segment VARCHAR(50),
    City VARCHAR(100),
    State VARCHAR(100),
    Postal_Code VARCHAR(20),
    Country VARCHAR(100),
    Hash_Diff VARCHAR(64) NOT NULL,
    Load_Source VARCHAR(100) NOT NULL,
    PRIMARY KEY (H_Customer_HK, Load_Date),
    FOREIGN KEY (H_Customer_HK) REFERENCES H_CUSTOMER(H_Hash_Customer)
);

-- Сателлит с категориями продуктов и историей изменений
CREATE TABLE S_PRODUCT_DETAILS (
    H_Product_HK VARCHAR(64) NOT NULL,
    Load_Date DATETIME NOT NULL,
    Category VARCHAR(100),
    Sub_Category VARCHAR(100),
    Hash_Diff VARCHAR(64) NOT NULL,
    Load_Source VARCHAR(100) NOT NULL,
    PRIMARY KEY (H_Product_HK, Load_Date),
    FOREIGN KEY (H_Product_HK) REFERENCES H_PRODUCT(H_Hash_Product)
);

-- Сателлит с географическими данными локаций и историей изменений
CREATE TABLE S_LOCATION_DETAILS (
    H_Location_HK VARCHAR(64) NOT NULL,
    Load_Date DATETIME NOT NULL,
    Postal_Code VARCHAR(20),
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100),
    Hash_Diff VARCHAR(64) NOT NULL,
    Load_Source VARCHAR(100) NOT NULL,
    PRIMARY KEY (H_Location_HK, Load_Date),
    FOREIGN KEY (H_Location_HK) REFERENCES H_LOCATION(H_Hash_Location)
);

-- Сателлит с финансовыми показателями транзакций продаж
CREATE TABLE S_SALES_METRICS (
    L_Sales_Transaction_HK VARCHAR(64) NOT NULL,
    Load_Date DATETIME NOT NULL,
    Sales DECIMAL(15,2) NOT NULL,
    Quantity INTEGER NOT NULL,
    Discount DECIMAL(5,4),
    Profit DECIMAL(15,2),
    Hash_Diff VARCHAR(64) NOT NULL,
    Load_Source VARCHAR(100) NOT NULL,
    PRIMARY KEY (L_Sales_Transaction_HK, Load_Date),
    FOREIGN KEY (L_Sales_Transaction_HK) REFERENCES LINK_SALES_TRANSACTION(L_Sales_Transaction_HK),
    CHECK (Discount >= 0 AND Discount <= 1),
    CHECK (Quantity > 0)
);

-- Сателлит с названиями способов доставки
CREATE TABLE S_SHIP_MODE_DETAILS (
    H_Ship_Mode_HK VARCHAR(64) NOT NULL,
    Load_Date DATETIME NOT NULL,
    Ship_Mode_Name VARCHAR(100) NOT NULL,
    Hash_Diff VARCHAR(64) NOT NULL,
    Load_Source VARCHAR(100) NOT NULL,
    PRIMARY KEY (H_Ship_Mode_HK, Load_Date),
    FOREIGN KEY (H_Ship_Mode_HK) REFERENCES H_SHIP_MODE(H_Hash_Ship_Mode)
);

-- Сателлит с названиями сегментов клиентов
CREATE TABLE S_SEGMENT_DETAILS (
    H_Segment_HK VARCHAR(64) NOT NULL,
    Load_Date DATETIME NOT NULL,
    Segment_Name VARCHAR(100) NOT NULL,
    Hash_Diff VARCHAR(64) NOT NULL,
    Load_Source VARCHAR(100) NOT NULL,
    PRIMARY KEY (H_Segment_HK, Load_Date),
    FOREIGN KEY (H_Segment_HK) REFERENCES H_SEGMENT(H_Hash_Segment)
);

-- Сателлит с названиями регионов
CREATE TABLE S_REGION_DETAILS (
    H_Region_HK VARCHAR(64) NOT NULL,
    Load_Date DATETIME NOT NULL,
    Region_Name VARCHAR(100) NOT NULL,
    Hash_Diff VARCHAR(64) NOT NULL,
    Load_Source VARCHAR(100) NOT NULL,
    PRIMARY KEY (H_Region_HK, Load_Date),
    FOREIGN KEY (H_Region_HK) REFERENCES H_REGION(H_Hash_Region)
);