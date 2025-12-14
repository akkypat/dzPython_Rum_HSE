create schema if not exists memory.dds;

-- Hubs

-- H_CUSTOMER
create table memory.dds.hub_customer (
    customer_hk varchar,
    customer_id bigint,
    load_date timestamp,
    record_source varchar
);

-- H_ORDERS
create table memory.dds.hub_order (
    order_hk varchar,
    order_key bigint,
    load_date timestamp,
    record_source varchar
);

-- H_PART
create table memory.dds.hub_part (
    part_hk varchar,
    part_key bigint,
    load_date timestamp,
    record_source varchar
);

-- H_SUPPLIER
create table memory.dds.hub_supplier (
    supplier_hk varchar,
    supplier_key bigint,
    load_date timestamp,
    record_source varchar
);

-- H_PARTSUPP
create table  memory.dds.hub_partsupp (
    partsupp_hk varchar,
    part_key bigint,
    supp_key bigint,
    load_date timestamp,
    record_source varchar
);

-- H_LINEITEM
create table memory.dds.hub_lineitem (
    lineitem_hk varchar,
    order_key bigint,
    line_number integer,
    load_date timestamp,
    record_source varchar
);

-- H_NATION
create table memory.dds.hub_nation (
    nation_hk varchar,
    nation_key bigint,
    load_date timestamp,
    record_source varchar
);

-- H_REGION
create table memory.dds.hub_region (
    region_hk varchar,
    region_key bigint,
    load_date timestamp,
    record_source varchar
);

-- Links

-- L_CUSTOMER_ORDER
create table memory.dds.link_customer_order (
    customer_order_hk varchar,
    customer_hk varchar,
    order_hk varchar,
    load_date timestamp,
    record_source varchar
);

-- L_ORDER_LINEITEM
create table memory.dds.link_order_lineitem (
    order_lineitem_hk varchar,
    order_hk varchar,
    lineitem_hk varchar,
    load_date timestamp,
    record_source varchar
);

-- L_LINEITEM_PART
create table memory.dds.link_lineitem_part (
    lineitem_part_hk varchar,
    lineitem_hk varchar,
    part_hk varchar,
    load_date timestamp,
    record_source varchar
);

-- L_LINEITEM_SPPLIER
create table  memory.dds.link_lineitem_supplier (
    lineitem_supplier_hk varchar,
    lineitem_hk varchar,
    supplier_hk varchar,
    load_date timestamp,
    record_source varchar
);

-- L_PARTSUPP
create table memory.dds.link_part_supplier (
    part_supplier_hk varchar,
    part_hk varchar,
    supplier_hk varchar,
    partsupp_hk varchar,
    load_date timestamp,
    record_source varchar
);

-- L_CUSTOMER_NATION
create table memory.dds.link_customer_nation (
    customer_nation_hk varchar,
    customer_hk varchar,
    nation_hk varchar,
    load_date timestamp,
    record_source varchar
);

-- L_SPPLIER_NATION
create table memory.dds.link_supplier_nation (
    supplier_nation_hk varchar,
    supplier_hk varchar,
    nation_hk varchar,
    load_date timestamp,
    record_source varchar
);

-- L_NATION_REGION
create table memory.dds.link_nation_region (
    nation_region_hk varchar,
    nation_hk varchar,
    region_hk varchar,
    load_date timestamp,
    record_source varchar
);

-- Satellites

-- S_CUSTOMER
create table memory.dds.sat_customer (
    customer_hk varchar,
    load_date timestamp,
    record_source varchar,
    hash_diff varchar,
    name varchar,
    address varchar,
    phone varchar,
    acctbal double,
    mktsegment varchar,
    comment varchar
);

-- S_ORDER
create table memory.dds.sat_order (
    order_hk varchar,
    load_date timestamp,
    record_source varchar,
    hash_diff varchar,
    order_status varchar,
    total_price double,
    order_date date,
    order_priority varchar,
    clerk varchar,
    ship_priority integer,
    comment varchar
);

-- S_PART
create table memory.dds.sat_part (
    part_hk varchar,
    load_date timestamp,
    record_source varchar,
    hash_diff varchar,
    name varchar,
    mfgr varchar,
    brand varchar,
    type varchar,
    size integer,
    container varchar,
    retail_price double,
    comment varchar
);

-- S_SUPPLIER
create table memory.dds.sat_supplier (
    supplier_hk varchar,
    load_date timestamp,
    record_source varchar,
    hash_diff varchar,
    name varchar,
    address varchar,
    phone varchar,
    acctbal double,
    comment varchar
);

-- S_PARTSUPP
create table memory.dds.sat_partsupp (
    partsupp_hk varchar,
    load_date timestamp,
    record_source varchar,
    hash_diff varchar,
    availqty integer,
    supplycost double,
    comment varchar
);

-- S_LINEITEM
create table memory.dds.sat_lineitem (
    lineitem_hk varchar,
    load_date timestamp,
    record_source varchar,
    hash_diff varchar,
    quantity double,
    extended_price double,
    discount double,
    tax double,
    return_flag varchar,
    line_status varchar,
    ship_date date,
    commit_date date,
    receipt_date date,
    ship_instruct varchar,
    ship_mode varchar,
    comment varchar
);

-- S_NATION
create table memory.dds.sat_nation (
    nation_hk varchar,
    load_date timestamp,
    record_source varchar,
    hash_diff varchar,
    name varchar,
    comment varchar
);

-- S_REGION
create table memory.dds.sat_region (
    region_hk varchar,
    load_date timestamp,
    record_source varchar,
    hash_diff varchar,
    name varchar,
    comment varchar
);