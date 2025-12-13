-- Создание схемы
CREATE SCHEMA IF NOT EXISTS memory.dds;

-- HUBS

CREATE TABLE memory.dds.hub_customer (
    customer_hk VARCHAR(32) NOT NULL,
    custkey BIGINT NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE memory.dds.hub_order (
    order_hk VARCHAR(32) NOT NULL,
    orderkey BIGINT NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE memory.dds.hub_part (
    part_hk VARCHAR(32) NOT NULL,
    partkey BIGINT NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE memory.dds.hub_supplier (
    supplier_hk VARCHAR(32) NOT NULL,
    suppkey BIGINT NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE memory.dds.hub_nation (
    nation_hk VARCHAR(32) NOT NULL,
    nationkey BIGINT NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE memory.dds.hub_region (
    region_hk VARCHAR(32) NOT NULL,
    regionkey BIGINT NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE memory.dds.hub_lineitem (
    lineitem_hk VARCHAR(32) NOT NULL,
    orderkey BIGINT NOT NULL,
    linenumber INTEGER NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

CREATE TABLE memory.dds.hub_partsupp (
    partsupp_hk VARCHAR(32) NOT NULL,
    partkey BIGINT NOT NULL,
    suppkey BIGINT NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- LINKS

-- ORDER to CUSTOMER
CREATE TABLE memory.dds.link_order_customer (
    order_customer_hk VARCHAR(32) NOT NULL,
    order_hk VARCHAR(32) NOT NULL,
    customer_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- LINEITEM to PARTSUPP
CREATE TABLE memory.dds.link_lineitem_partsupp (
    lineitem_partsupp_hk VARCHAR(32) NOT NULL,
    lineitem_hk VARCHAR(32) NOT NULL,
    partsupp_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- PARTSUPP to PART
CREATE TABLE memory.dds.link_partsupp_part (
    partsupp_part_hk VARCHAR(32) NOT NULL,
    partsupp_hk VARCHAR(32) NOT NULL,
    part_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- PARTSUPP to SUPPLIER
CREATE TABLE memory.dds.link_partsupp_supplier (
    partsupp_supplier_hk VARCHAR(32) NOT NULL,
    partsupp_hk VARCHAR(32) NOT NULL,
    supplier_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- CUSTOMER to NATION
CREATE TABLE memory.dds.link_customer_nation (
    customer_nation_hk VARCHAR(32) NOT NULL,
    customer_hk VARCHAR(32) NOT NULL,
    nation_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- SUPPLIER to NATION
CREATE TABLE memory.dds.link_supplier_nation (
    supplier_nation_hk VARCHAR(32) NOT NULL,
    supplier_hk VARCHAR(32) NOT NULL,
    nation_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- NATION to REGION
CREATE TABLE memory.dds.link_nation_region (
    nation_region_hk VARCHAR(32) NOT NULL,
    nation_hk VARCHAR(32) NOT NULL,
    region_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    record_source VARCHAR(50) NOT NULL
);

-- SATELLITES

-- SAT_CUSTOMER
CREATE TABLE memory.dds.sat_customer (
    customer_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    hash_diff VARCHAR(32) NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    name VARCHAR(25) NOT NULL,
    address VARCHAR(40) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    acctbal DOUBLE NOT NULL,
    mktsegment VARCHAR(10) NOT NULL,
    comment VARCHAR(117) NOT NULL
);

-- SAT_ORDER
CREATE TABLE memory.dds.sat_order (
    order_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    hash_diff VARCHAR(32) NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    orderstatus VARCHAR(1) NOT NULL,
    totalprice DOUBLE NOT NULL,
    orderdate DATE NOT NULL,
    orderpriority VARCHAR(15) NOT NULL,
    clerk VARCHAR(15) NOT NULL,
    shippriority INTEGER NOT NULL,
    comment VARCHAR(79) NOT NULL
);

-- SAT_PART
CREATE TABLE memory.dds.sat_part (
    part_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    hash_diff VARCHAR(32) NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    name VARCHAR(55) NOT NULL,
    mfgr VARCHAR(25) NOT NULL,
    brand VARCHAR(10) NOT NULL,
    type VARCHAR(25) NOT NULL,
    size INTEGER NOT NULL,
    container VARCHAR(10) NOT NULL,
    retailprice DOUBLE NOT NULL,
    comment VARCHAR(23) NOT NULL
);

-- SAT_SUPPLIER
CREATE TABLE memory.dds.sat_supplier (
    supplier_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    hash_diff VARCHAR(32) NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    name VARCHAR(25) NOT NULL,
    address VARCHAR(40) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    acctbal DOUBLE NOT NULL,
    comment VARCHAR(101) NOT NULL
);

-- SAT_NATION
CREATE TABLE memory.dds.sat_nation (
    nation_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    hash_diff VARCHAR(32) NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    name VARCHAR(25) NOT NULL,
    comment VARCHAR(152) NOT NULL
);

-- SAT_REGION
CREATE TABLE memory.dds.sat_region (
    region_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    hash_diff VARCHAR(32) NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    name VARCHAR(25) NOT NULL,
    comment VARCHAR(152) NOT NULL
);

-- SAT_LINEITEM
CREATE TABLE memory.dds.sat_lineitem (
    lineitem_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    hash_diff VARCHAR(32) NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    quantity DOUBLE NOT NULL,
    extendedprice DOUBLE NOT NULL,
    discount DOUBLE NOT NULL,
    tax DOUBLE NOT NULL,
    returnflag VARCHAR(1) NOT NULL,
    linestatus VARCHAR(1) NOT NULL,
    shipdate DATE NOT NULL,
    commitdate DATE NOT NULL,
    receiptdate DATE NOT NULL,
    shipinstruct VARCHAR(25) NOT NULL,
    shipmode VARCHAR(10) NOT NULL,
    comment VARCHAR(44) NOT NULL
);

-- SAT_PARTSUPP
CREATE TABLE memory.dds.sat_partsupp (
    partsupp_hk VARCHAR(32) NOT NULL,
    load_date TIMESTAMP NOT NULL,
    hash_diff VARCHAR(32) NOT NULL,
    record_source VARCHAR(50) NOT NULL,
    availqty INTEGER NOT NULL,
    supplycost DOUBLE NOT NULL,
    comment VARCHAR(199) NOT NULL
);