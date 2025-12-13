-- HUBS

-- HUB_CUSTOMER
INSERT INTO memory.dds.hub_customer
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(custkey AS VARCHAR)))) AS VARCHAR) AS customer_hk,
    custkey,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.customer' AS record_source
FROM tpch.tiny.customer;

-- HUB_ORDER
INSERT INTO memory.dds.hub_order
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR)))) AS VARCHAR) AS order_hk,
    orderkey,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.orders' AS record_source
FROM tpch.tiny.orders;

-- HUB_PART
INSERT INTO memory.dds.hub_part
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(partkey AS VARCHAR)))) AS VARCHAR) AS part_hk,
    partkey,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.part' AS record_source
FROM tpch.tiny.part;

-- HUB_SUPPLIER
INSERT INTO memory.dds.hub_supplier
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(suppkey AS VARCHAR)))) AS VARCHAR) AS supplier_hk,
    suppkey,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.supplier' AS record_source
FROM tpch.tiny.supplier;

-- HUB_NATION
INSERT INTO memory.dds.hub_nation
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(nationkey AS VARCHAR)))) AS VARCHAR) AS nation_hk,
    nationkey,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.nation' AS record_source
FROM tpch.tiny.nation;

-- HUB_REGION
INSERT INTO memory.dds.hub_region
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(regionkey AS VARCHAR)))) AS VARCHAR) AS region_hk,
    regionkey,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.region' AS record_source
FROM tpch.tiny.region;

-- HUB_LINEITEM
INSERT INTO memory.dds.hub_lineitem
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR) || '|' || CAST(linenumber AS VARCHAR)))) AS VARCHAR) AS lineitem_hk,
    orderkey,
    linenumber,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.lineitem' AS record_source
FROM tpch.tiny.lineitem;

-- HUB_PARTSUPP
INSERT INTO memory.dds.hub_partsupp
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(partkey AS VARCHAR) || '|' || CAST(suppkey AS VARCHAR)))) AS VARCHAR) AS partsupp_hk,
    partkey,
    suppkey,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.partsupp' AS record_source
FROM tpch.tiny.partsupp;

-- LINKS (оптимизированные, по бизнес-ключам)

-- LINK_ORDER_CUSTOMER
INSERT INTO memory.dds.link_order_customer
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(
        CAST(o.custkey AS VARCHAR) || '|' || CAST(o.orderkey AS VARCHAR)
    ))) AS VARCHAR) AS order_customer_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(o.custkey AS VARCHAR)))) AS VARCHAR) AS customer_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(o.orderkey AS VARCHAR)))) AS VARCHAR) AS order_hk,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.orders' AS record_source
FROM tpch.tiny.orders o;

-- LINK_LINEITEM_PARTSUPP
INSERT INTO memory.dds.link_lineitem_partsupp
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(
        CAST(l.orderkey AS VARCHAR) || '|' || CAST(l.linenumber AS VARCHAR) || '|' ||
        CAST(l.partkey AS VARCHAR) || '|' || CAST(l.suppkey AS VARCHAR)
    ))) AS VARCHAR) AS lineitem_partsupp_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(l.orderkey AS VARCHAR) || '|' || CAST(l.linenumber AS VARCHAR)))) AS VARCHAR) AS lineitem_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(l.partkey AS VARCHAR) || '|' || CAST(l.suppkey AS VARCHAR)))) AS VARCHAR) AS partsupp_hk,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.lineitem' AS record_source
FROM tpch.tiny.lineitem l;

-- LINK_PARTSUPP_PART
INSERT INTO memory.dds.link_partsupp_part
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(
        CAST(ps.partkey AS VARCHAR) || '|' || CAST(ps.suppkey AS VARCHAR) || '|' ||
        CAST(ps.partkey AS VARCHAR)
    ))) AS VARCHAR) AS partsupp_part_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(ps.partkey AS VARCHAR) || '|' || CAST(ps.suppkey AS VARCHAR)))) AS VARCHAR) AS partsupp_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(ps.partkey AS VARCHAR)))) AS VARCHAR) AS part_hk,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.partsupp' AS record_source
FROM tpch.tiny.partsupp ps;

-- LINK_PARTSUPP_SUPPLIER
INSERT INTO memory.dds.link_partsupp_supplier
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(
        CAST(ps.partkey AS VARCHAR) || '|' || CAST(ps.suppkey AS VARCHAR) || '|' ||
        CAST(ps.suppkey AS VARCHAR)
    ))) AS VARCHAR) AS partsupp_supplier_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(ps.partkey AS VARCHAR) || '|' || CAST(ps.suppkey AS VARCHAR)))) AS VARCHAR) AS partsupp_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(ps.suppkey AS VARCHAR)))) AS VARCHAR) AS supplier_hk,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.partsupp' AS record_source
FROM tpch.tiny.partsupp ps;

-- LINK_CUSTOMER_NATION
INSERT INTO memory.dds.link_customer_nation
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(
        CAST(c.custkey AS VARCHAR) || '|' || CAST(c.nationkey AS VARCHAR)
    ))) AS VARCHAR) AS customer_nation_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(c.custkey AS VARCHAR)))) AS VARCHAR) AS customer_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(c.nationkey AS VARCHAR)))) AS VARCHAR) AS nation_hk,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.customer' AS record_source
FROM tpch.tiny.customer c;

-- LINK_SUPPLIER_NATION
INSERT INTO memory.dds.link_supplier_nation
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(
        CAST(s.suppkey AS VARCHAR) || '|' || CAST(s.nationkey AS VARCHAR)
    ))) AS VARCHAR) AS supplier_nation_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(s.suppkey AS VARCHAR)))) AS VARCHAR) AS supplier_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(s.nationkey AS VARCHAR)))) AS VARCHAR) AS nation_hk,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.supplier' AS record_source
FROM tpch.tiny.supplier s;

-- LINK_NATION_REGION
INSERT INTO memory.dds.link_nation_region
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(
        CAST(n.nationkey AS VARCHAR) || '|' || CAST(n.regionkey AS VARCHAR)
    ))) AS VARCHAR) AS nation_region_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(n.nationkey AS VARCHAR)))) AS VARCHAR) AS nation_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(n.regionkey AS VARCHAR)))) AS VARCHAR) AS region_hk,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.nation' AS record_source
FROM tpch.tiny.nation n;

-- SATELLITES (порядок полей: *_hk, load_date, hash_diff, record_source, ...)

-- SAT_CUSTOMER
INSERT INTO memory.dds.sat_customer
SELECT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(custkey AS VARCHAR)))) AS VARCHAR) AS customer_hk,
    CURRENT_TIMESTAMP AS load_date,
    CAST(TO_HEX(MD5(TO_UTF8(
        COALESCE(name, '') || '|' ||
        COALESCE(address, '') || '|' ||
        COALESCE(phone, '') || '|' ||
        COALESCE(CAST(acctbal AS VARCHAR), '') || '|' ||
        COALESCE(mktsegment, '') || '|' ||
        COALESCE(comment, '')
    ))) AS VARCHAR) AS hash_diff,
    'tpch.tiny.customer' AS record_source,
    name,
    address,
    phone,
    acctbal,
    mktsegment,
    comment
FROM tpch.tiny.customer;

-- SAT_ORDER
INSERT INTO memory.dds.sat_order
SELECT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR)))) AS VARCHAR) AS order_hk,
    CURRENT_TIMESTAMP AS load_date,
    CAST(TO_HEX(MD5(TO_UTF8(
        COALESCE(orderstatus, '') || '|' ||
        COALESCE(CAST(totalprice AS VARCHAR), '') || '|' ||
        COALESCE(CAST(orderdate AS VARCHAR), '') || '|' ||
        COALESCE(orderpriority, '') || '|' ||
        COALESCE(clerk, '') || '|' ||
        COALESCE(CAST(shippriority AS VARCHAR), '') || '|' ||
        COALESCE(comment, '')
    ))) AS VARCHAR) AS hash_diff,
    'tpch.tiny.orders' AS record_source,
    orderstatus,
    totalprice,
    orderdate,
    orderpriority,
    clerk,
    shippriority,
    comment
FROM tpch.tiny.orders;

-- SAT_PART
INSERT INTO memory.dds.sat_part
SELECT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(partkey AS VARCHAR)))) AS VARCHAR) AS part_hk,
    CURRENT_TIMESTAMP AS load_date,
    CAST(TO_HEX(MD5(TO_UTF8(
        COALESCE(name, '') || '|' ||
        COALESCE(mfgr, '') || '|' ||
        COALESCE(brand, '') || '|' ||
        COALESCE(type, '') || '|' ||
        COALESCE(CAST(size AS VARCHAR), '') || '|' ||
        COALESCE(container, '') || '|' ||
        COALESCE(CAST(retailprice AS VARCHAR), '') || '|' ||
        COALESCE(comment, '')
    ))) AS VARCHAR) AS hash_diff,
    'tpch.tiny.part' AS record_source,
    name,
    mfgr,
    brand,
    type,
    size,
    container,
    retailprice,
    comment
FROM tpch.tiny.part;

-- SAT_SUPPLIER
INSERT INTO memory.dds.sat_supplier
SELECT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(suppkey AS VARCHAR)))) AS VARCHAR) AS supplier_hk,
    CURRENT_TIMESTAMP AS load_date,
    CAST(TO_HEX(MD5(TO_UTF8(
        COALESCE(name, '') || '|' ||
        COALESCE(address, '') || '|' ||
        COALESCE(phone, '') || '|' ||
        COALESCE(CAST(acctbal AS VARCHAR), '') || '|' ||
        COALESCE(comment, '')
    ))) AS VARCHAR) AS hash_diff,
    'tpch.tiny.supplier' AS record_source,
    name,
    address,
    phone,
    acctbal,
    comment
FROM tpch.tiny.supplier;

-- SAT_NATION
INSERT INTO memory.dds.sat_nation
SELECT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(nationkey AS VARCHAR)))) AS VARCHAR) AS nation_hk,
    CURRENT_TIMESTAMP AS load_date,
    CAST(TO_HEX(MD5(TO_UTF8(
        COALESCE(name, '') || '|' ||
        COALESCE(comment, '')
    ))) AS VARCHAR) AS hash_diff,
    'tpch.tiny.nation' AS record_source,
    name,
    comment
FROM tpch.tiny.nation;

-- SAT_REGION
INSERT INTO memory.dds.sat_region
SELECT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(regionkey AS VARCHAR)))) AS VARCHAR) AS region_hk,
    CURRENT_TIMESTAMP AS load_date,
    CAST(TO_HEX(MD5(TO_UTF8(
        COALESCE(name, '') || '|' ||
        COALESCE(comment, '')
    ))) AS VARCHAR) AS hash_diff,
    'tpch.tiny.region' AS record_source,
    name,
    comment
FROM tpch.tiny.region;

-- SAT_LINEITEM
INSERT INTO memory.dds.sat_lineitem
SELECT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR) || '|' || CAST(linenumber AS VARCHAR)))) AS VARCHAR) AS lineitem_hk,
    CURRENT_TIMESTAMP AS load_date,
    CAST(TO_HEX(MD5(TO_UTF8(
        COALESCE(CAST(quantity AS VARCHAR), '') || '|' ||
        COALESCE(CAST(extendedprice AS VARCHAR), '') || '|' ||
        COALESCE(CAST(discount AS VARCHAR), '') || '|' ||
        COALESCE(CAST(tax AS VARCHAR), '') || '|' ||
        COALESCE(returnflag, '') || '|' ||
        COALESCE(linestatus, '') || '|' ||
        COALESCE(CAST(shipdate AS VARCHAR), '') || '|' ||
        COALESCE(CAST(commitdate AS VARCHAR), '') || '|' ||
        COALESCE(CAST(receiptdate AS VARCHAR), '') || '|' ||
        COALESCE(shipinstruct, '') || '|' ||
        COALESCE(shipmode, '') || '|' ||
        COALESCE(comment, '')
    ))) AS VARCHAR) AS hash_diff,
    'tpch.tiny.lineitem' AS record_source,
    quantity,
    extendedprice,
    discount,
    tax,
    returnflag,
    linestatus,
    shipdate,
    commitdate,
    receiptdate,
    shipinstruct,
    shipmode,
    comment
FROM tpch.tiny.lineitem;

-- SAT_PARTSUPP
INSERT INTO memory.dds.sat_partsupp
SELECT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(partkey AS VARCHAR) || '|' || CAST(suppkey AS VARCHAR)))) AS VARCHAR) AS partsupp_hk,
    CURRENT_TIMESTAMP AS load_date,
    CAST(TO_HEX(MD5(TO_UTF8(
        COALESCE(CAST(availqty AS VARCHAR), '') || '|' ||
        COALESCE(CAST(supplycost AS VARCHAR), '') || '|' ||
        COALESCE(comment, '')
    ))) AS VARCHAR) AS hash_diff,
    'tpch.tiny.partsupp' AS record_source,
    availqty,
    supplycost,
    comment
FROM tpch.tiny.partsupp;