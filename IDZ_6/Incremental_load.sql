-- HUB_ORDER
INSERT INTO memory.dds.hub_order
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR)))) AS VARCHAR) AS order_hk,
    orderkey,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.orders' AS record_source
FROM tpch.tiny.orders
WHERE orderdate = DATE 'LOAD_DATE'
  AND CAST(TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR)))) AS VARCHAR)
      NOT IN (SELECT order_hk FROM memory.dds.hub_order);

-- HUB_CUSTOMER
INSERT INTO memory.dds.hub_customer
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(custkey AS VARCHAR)))) AS VARCHAR) AS customer_hk,
    custkey,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.orders' AS record_source  -- источник — orders, т.к. инкремент по заказам
FROM tpch.tiny.orders o
WHERE o.orderdate = DATE 'LOAD_DATE'
  AND CAST(TO_HEX(MD5(TO_UTF8(CAST(custkey AS VARCHAR)))) AS VARCHAR)
      NOT IN (SELECT customer_hk FROM memory.dds.hub_customer);

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
FROM tpch.tiny.orders o
WHERE o.orderdate = DATE 'LOAD_DATE'
  AND CAST(TO_HEX(MD5(TO_UTF8(
        CAST(o.custkey AS VARCHAR) || '|' || CAST(o.orderkey AS VARCHAR)
    ))) AS VARCHAR)
      NOT IN (SELECT order_customer_hk FROM memory.dds.link_order_customer);

-- SAT_ORDER
INSERT INTO memory.dds.sat_order
SELECT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(o.orderkey AS VARCHAR)))) AS VARCHAR) AS order_hk,
    CURRENT_TIMESTAMP AS load_date,
    CAST(TO_HEX(MD5(TO_UTF8(
        COALESCE(o.orderstatus, '') || '|' ||
        COALESCE(CAST(o.totalprice AS VARCHAR), '') || '|' ||
        COALESCE(CAST(o.orderdate AS VARCHAR), '') || '|' ||
        COALESCE(o.orderpriority, '') || '|' ||
        COALESCE(o.clerk, '') || '|' ||
        COALESCE(CAST(o.shippriority AS VARCHAR), '') || '|' ||
        COALESCE(o.comment, '')
    ))) AS VARCHAR) AS hash_diff,
    'tpch.tiny.orders' AS record_source,
    o.orderstatus,
    o.totalprice,
    o.orderdate,
    o.orderpriority,
    o.clerk,
    o.shippriority,
    o.comment
FROM tpch.tiny.orders o
WHERE o.orderdate = DATE 'LOAD_DATE'
  AND NOT EXISTS (
      SELECT 1
      FROM memory.dds.sat_order s
      WHERE s.order_hk = CAST(TO_HEX(MD5(TO_UTF8(CAST(o.orderkey AS VARCHAR)))) AS VARCHAR)
        AND s.hash_diff = CAST(TO_HEX(MD5(TO_UTF8(
            COALESCE(o.orderstatus, '') || '|' ||
            COALESCE(CAST(o.totalprice AS VARCHAR), '') || '|' ||
            COALESCE(CAST(o.orderdate AS VARCHAR), '') || '|' ||
            COALESCE(o.orderpriority, '') || '|' ||
            COALESCE(o.clerk, '') || '|' ||
            COALESCE(CAST(o.shippriority AS VARCHAR), '') || '|' ||
            COALESCE(o.comment, '')
        ))) AS VARCHAR)
  );

-- HUB_LINEITEM
INSERT INTO memory.dds.hub_lineitem
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR) || '|' || CAST(linenumber AS VARCHAR)))) AS VARCHAR) AS lineitem_hk,
    orderkey,
    linenumber,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.lineitem' AS record_source
FROM tpch.tiny.lineitem
WHERE shipdate = DATE 'LOAD_DATE'
  AND CAST(TO_HEX(MD5(TO_UTF8(CAST(orderkey AS VARCHAR) || '|' || CAST(linenumber AS VARCHAR)))) AS VARCHAR)
      NOT IN (SELECT lineitem_hk FROM memory.dds.hub_lineitem);

-- HUB_PARTSUPP
INSERT INTO memory.dds.hub_partsupp
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(partkey AS VARCHAR) || '|' || CAST(suppkey AS VARCHAR)))) AS VARCHAR) AS partsupp_hk,
    partkey,
    suppkey,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.lineitem' AS record_source
FROM tpch.tiny.lineitem li
WHERE li.shipdate = DATE 'LOAD_DATE'
  AND CAST(TO_HEX(MD5(TO_UTF8(CAST(partkey AS VARCHAR) || '|' || CAST(suppkey AS VARCHAR)))) AS VARCHAR)
      NOT IN (SELECT partsupp_hk FROM memory.dds.hub_partsupp);

-- LINK_LINEITEM_PARTSUPP
INSERT INTO memory.dds.link_lineitem_partsupp
SELECT DISTINCT
    CAST(TO_HEX(MD5(TO_UTF8(
        CAST(li.orderkey AS VARCHAR) || '|' || CAST(li.linenumber AS VARCHAR) || '|' ||
        CAST(li.partkey AS VARCHAR) || '|' || CAST(li.suppkey AS VARCHAR)
    ))) AS VARCHAR) AS lineitem_partsupp_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(li.orderkey AS VARCHAR) || '|' || CAST(li.linenumber AS VARCHAR)))) AS VARCHAR) AS lineitem_hk,
    CAST(TO_HEX(MD5(TO_UTF8(CAST(li.partkey AS VARCHAR) || '|' || CAST(li.suppkey AS VARCHAR)))) AS VARCHAR) AS partsupp_hk,
    CURRENT_TIMESTAMP AS load_date,
    'tpch.tiny.lineitem' AS record_source
FROM tpch.tiny.lineitem li
WHERE li.shipdate = DATE 'LOAD_DATE'
  AND CAST(TO_HEX(MD5(TO_UTF8(
        CAST(li.orderkey AS VARCHAR) || '|' || CAST(li.linenumber AS VARCHAR) || '|' ||
        CAST(li.partkey AS VARCHAR) || '|' || CAST(li.suppkey AS VARCHAR)
    ))) AS VARCHAR)
      NOT IN (SELECT lineitem_partsupp_hk FROM memory.dds.link_lineitem_partsupp);

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
    'tpch.tiny.lineitem' AS record_source
FROM tpch.tiny.lineitem ps
WHERE ps.shipdate = DATE 'LOAD_DATE'
  AND CAST(TO_HEX(MD5(TO_UTF8(
        CAST(ps.partkey AS VARCHAR) || '|' || CAST(ps.suppkey AS VARCHAR) || '|' ||
        CAST(ps.partkey AS VARCHAR)
    ))) AS VARCHAR)
      NOT IN (SELECT partsupp_part_hk FROM memory.dds.link_partsupp_part);

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
    'tpch.tiny.lineitem' AS record_source
FROM tpch.tiny.lineitem ps
WHERE ps.shipdate = DATE 'LOAD_DATE'
  AND CAST(TO_HEX(MD5(TO_UTF8(
        CAST(ps.partkey AS VARCHAR) || '|' || CAST(ps.suppkey AS VARCHAR) || '|' ||
        CAST(ps.suppkey AS VARCHAR)
    ))) AS VARCHAR)
      NOT IN (SELECT partsupp_supplier_hk FROM memory.dds.link_partsupp_supplier);

-- SAT_LINEITEM
INSERT INTO memory.dds.sat_lineitem
SELECT
    CAST(TO_HEX(MD5(TO_UTF8(CAST(li.orderkey AS VARCHAR) || '|' || CAST(li.linenumber AS VARCHAR)))) AS VARCHAR) AS lineitem_hk,
    CURRENT_TIMESTAMP AS load_date,
    CAST(TO_HEX(MD5(TO_UTF8(
        COALESCE(CAST(li.quantity AS VARCHAR), '') || '|' ||
        COALESCE(CAST(li.extendedprice AS VARCHAR), '') || '|' ||
        COALESCE(CAST(li.discount AS VARCHAR), '') || '|' ||
        COALESCE(CAST(li.tax AS VARCHAR), '') || '|' ||
        COALESCE(li.returnflag, '') || '|' ||
        COALESCE(li.linestatus, '') || '|' ||
        COALESCE(CAST(li.shipdate AS VARCHAR), '') || '|' ||
        COALESCE(CAST(li.commitdate AS VARCHAR), '') || '|' ||
        COALESCE(CAST(li.receiptdate AS VARCHAR), '') || '|' ||
        COALESCE(li.shipinstruct, '') || '|' ||
        COALESCE(li.shipmode, '') || '|' ||
        COALESCE(li.comment, '')
    ))) AS VARCHAR) AS hash_diff,
    'tpch.tiny.lineitem' AS record_source,
    li.quantity,
    li.extendedprice,
    li.discount,
    li.tax,
    li.returnflag,
    li.linestatus,
    li.shipdate,
    li.commitdate,
    li.receiptdate,
    li.shipinstruct,
    li.shipmode,
    li.comment
FROM tpch.tiny.lineitem li
WHERE li.shipdate = DATE 'LOAD_DATE'
  AND NOT EXISTS (
      SELECT 1
      FROM memory.dds.sat_lineitem s
      WHERE s.lineitem_hk = CAST(TO_HEX(MD5(TO_UTF8(CAST(li.orderkey AS VARCHAR) || '|' || CAST(li.linenumber AS VARCHAR)))) AS VARCHAR)
        AND s.hash_diff = CAST(TO_HEX(MD5(TO_UTF8(
            COALESCE(CAST(li.quantity AS VARCHAR), '') || '|' ||
            COALESCE(CAST(li.extendedprice AS VARCHAR), '') || '|' ||
            COALESCE(CAST(li.discount AS VARCHAR), '') || '|' ||
            COALESCE(CAST(li.tax AS VARCHAR), '') || '|' ||
            COALESCE(li.returnflag, '') || '|' ||
            COALESCE(li.linestatus, '') || '|' ||
            COALESCE(CAST(li.shipdate AS VARCHAR), '') || '|' ||
            COALESCE(CAST(li.commitdate AS VARCHAR), '') || '|' ||
            COALESCE(CAST(li.receiptdate AS VARCHAR), '') || '|' ||
            COALESCE(li.shipinstruct, '') || '|' ||
            COALESCE(li.shipmode, '') || '|' ||
            COALESCE(li.comment, '')
        ))) AS VARCHAR)
  );