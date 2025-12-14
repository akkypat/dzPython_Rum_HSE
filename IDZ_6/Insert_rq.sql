-- Hubs

-- H_CUSTOMER
insert into memory.dds.hub_customer
select distinct
    cast(to_hex(md5(to_utf8(cast(custkey as varchar)))) as varchar) as customer_hk,
    custkey as customer_id,
    current_timestamp as load_date,
    'tpch.tiny.customer' as record_source
from tpch.tiny.customer;

-- H_ORDERS
insert into memory.dds.hub_order
select distinct
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar)))) as varchar) as order_hk,
    orderkey as order_key,
    current_timestamp as load_date,
    'tpch.tiny.orders' as record_source
from tpch.tiny.orders;

-- H_PART
insert into memory.dds.hub_part
select distinct
    cast(to_hex(md5(to_utf8(cast(partkey as varchar)))) as varchar) as part_hk,
    partkey as part_key,
    current_timestamp as load_date,
    'tpch.tiny.part' as record_source
from tpch.tiny.part;

-- H_SUPPLIER
insert into memory.dds.hub_supplier
select distinct
    cast(to_hex(md5(to_utf8(cast(suppkey as varchar)))) as varchar) as supplier_hk,
    suppkey as supplier_key,
    current_timestamp as load_date,
    'tpch.tiny.supplier' as record_source
from tpch.tiny.supplier;

-- H_PARTSUPP
insert into memory.dds.hub_partsupp
select distinct
    cast(to_hex(md5(to_utf8(cast(partkey as varchar) || '|' || cast(suppkey as varchar)))) as varchar) as partsupp_hk,
    partkey as part_key,
    suppkey as supp_key,
    current_timestamp as load_date,
    'tpch.tiny.partsupp' as record_source
from tpch.tiny.partsupp;

--H_LINEITEM
insert into memory.dds.hub_lineitem
select distinct
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar) as lineitem_hk,
    orderkey as order_key,
    linenumber as line_number,
    current_timestamp as load_date,
    'tpch.tiny.lineitem' as record_source
from tpch.tiny.lineitem;

-- H_NATION
insert into memory.dds.hub_nation
select distinct
    cast(to_hex(md5(to_utf8(cast(nationkey as varchar)))) as varchar) as nation_hk,
    nationkey as nation_key,
    current_timestamp as load_date,
    'tpch.tiny.nation' as record_source
from tpch.tiny.nation;

-- H_REGION
insert into memory.dds.hub_region
select distinct
    cast(to_hex(md5(to_utf8(cast(regionkey as varchar)))) as varchar) as region_hk,
    regionkey as region_key,
    current_timestamp as load_date,
    'tpch.tiny.region' as record_source
from tpch.tiny.region;

-- Links

-- L_CUSTOMER_ORDER
insert into memory.dds.link_customer_order
select distinct
    cast(to_hex(md5(to_utf8(
        cast(to_hex(md5(to_utf8(cast(custkey as varchar)))) as varchar) || '|' ||
        cast(to_hex(md5(to_utf8(cast(orderkey as varchar)))) as varchar)
    ))) as varchar) as customer_order_hk,
    cast(to_hex(md5(to_utf8(cast(custkey as varchar)))) as varchar) as customer_hk,
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar)))) as varchar) as order_hk,
    current_timestamp as load_date,
    'tpch.tiny.orders' as record_source
from tpch.tiny.orders;

-- L_ORDER_LINEITEM
insert into memory.dds.link_order_lineitem
select distinct
    cast(to_hex(md5(to_utf8(
        cast(to_hex(md5(to_utf8(cast(orderkey as varchar)))) as varchar) || '|' ||
        cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar)
    ))) as varchar) as order_lineitem_hk,
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar)))) as varchar) as order_hk,
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar) as lineitem_hk,
    current_timestamp as load_date,
    'tpch.tiny.lineitem' as record_source
from tpch.tiny.lineitem;

-- L_LINEITEM_PART
insert into memory.dds.link_lineitem_part
select distinct
    cast(to_hex(md5(to_utf8(
        cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar) || '|' ||
        cast(to_hex(md5(to_utf8(cast(partkey as varchar)))) as varchar)
    ))) as varchar) as lineitem_part_hk,
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar) as lineitem_hk,
    cast(to_hex(md5(to_utf8(cast(partkey as varchar)))) as varchar) as part_hk,
    current_timestamp as load_date,
    'tpch.tiny.lineitem' as record_source
from tpch.tiny.lineitem;

-- L_LINEITEM_SPPLIER
insert into memory.dds.link_lineitem_supplier
select distinct
    cast(to_hex(md5(to_utf8(
        cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar) || '|' ||
        cast(to_hex(md5(to_utf8(cast(suppkey as varchar)))) as varchar)
    ))) as varchar) as lineitem_supplier_hk,
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar) as lineitem_hk,
    cast(to_hex(md5(to_utf8(cast(suppkey as varchar)))) as varchar) as supplier_hk,
    current_timestamp as load_date,
    'tpch.tiny.lineitem' as record_source
from tpch.tiny.lineitem;

-- L_PARTSUPP
insert into memory.dds.link_part_supplier
select distinct
    cast(to_hex(md5(to_utf8(
        cast(to_hex(md5(to_utf8(cast(partkey as varchar)))) as varchar) || '|' ||
        cast(to_hex(md5(to_utf8(cast(suppkey as varchar)))) as varchar)
    ))) as varchar) as part_supplier_hk,
    cast(to_hex(md5(to_utf8(cast(partkey as varchar)))) as varchar) as part_hk,
    cast(to_hex(md5(to_utf8(cast(suppkey as varchar)))) as varchar) as supplier_hk,
    cast(to_hex(md5(to_utf8(cast(partkey as varchar) || '|' || cast(suppkey as varchar)))) as varchar) as partsupp_hk,
    current_timestamp as load_date,
    'tpch.tiny.partsupp' as record_source
from tpch.tiny.partsupp;

-- L_CUSTOMER_NATION
insert into memory.dds.link_customer_nation
select distinct
    cast(to_hex(md5(to_utf8(
        cast(to_hex(md5(to_utf8(cast(custkey as varchar)))) as varchar) || '|' ||
        cast(to_hex(md5(to_utf8(cast(nationkey as varchar)))) as varchar)
    ))) as varchar) as customer_nation_hk,
    cast(to_hex(md5(to_utf8(cast(custkey as varchar)))) as varchar) as customer_hk,
    cast(to_hex(md5(to_utf8(cast(nationkey as varchar)))) as varchar) as nation_hk,
    current_timestamp as load_date,
    'tpch.tiny.customer' as record_source
from tpch.tiny.customer;

-- L_SPPLIER_NATION
insert into memory.dds.link_supplier_nation
select distinct
    cast(to_hex(md5(to_utf8(
        cast(to_hex(md5(to_utf8(cast(suppkey as varchar)))) as varchar) || '|' ||
        cast(to_hex(md5(to_utf8(cast(nationkey as varchar)))) as varchar)
    ))) as varchar) as supplier_nation_hk,
    cast(to_hex(md5(to_utf8(cast(suppkey as varchar)))) as varchar) as supplier_hk,
    cast(to_hex(md5(to_utf8(cast(nationkey as varchar)))) as varchar) as nation_hk,
    current_timestamp as load_date,
    'tpch.tiny.supplier' as record_source
from tpch.tiny.supplier;

-- L_NATION_REGION
insert into memory.dds.link_nation_region
select distinct
    cast(to_hex(md5(to_utf8(
        cast(to_hex(md5(to_utf8(cast(nationkey as varchar)))) as varchar) || '|' ||
        cast(to_hex(md5(to_utf8(cast(regionkey as varchar)))) as varchar)
    ))) as varchar) as nation_region_hk,
    cast(to_hex(md5(to_utf8(cast(nationkey as varchar)))) as varchar) as nation_hk,
    cast(to_hex(md5(to_utf8(cast(regionkey as varchar)))) as varchar) as region_hk,
    current_timestamp as load_date,
    'tpch.tiny.nation' as record_source
from tpch.tiny.nation;

-- Satellites

-- S_CUSTOMER
insert into memory.dds.sat_customer
select
    cast(to_hex(md5(to_utf8(cast(custkey as varchar)))) as varchar) as customer_hk,
    current_timestamp as load_date,
    'tpch.tiny.customer' as record_source,
    cast(to_hex(md5(to_utf8(
        coalesce(name, '') || '|' ||
        coalesce(address, '') || '|' ||
        coalesce(phone, '') || '|' ||
        coalesce(cast(acctbal as varchar), '') || '|' ||
        coalesce(mktsegment, '') || '|' ||
        coalesce(comment, '')
    ))) as varchar) as hash_diff,
    name,
    address,
    phone,
    acctbal,
    mktsegment,
    comment
from tpch.tiny.customer;

-- S_ORDER
insert into memory.dds.sat_order
select
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar)))) as varchar) as order_hk,
    current_timestamp as load_date,
    'tpch.tiny.orders' as record_source,
    cast(to_hex(md5(to_utf8(
        coalesce(orderstatus, '') || '|' ||
        coalesce(cast(totalprice as varchar), '') || '|' ||
        coalesce(cast(orderdate as varchar), '') || '|' ||
        coalesce(orderpriority, '') || '|' ||
        coalesce(clerk, '') || '|' ||
        coalesce(cast(shippriority as varchar), '') || '|' ||
        coalesce(comment, '')
    ))) as varchar) as hash_diff,
    orderstatus as order_status,
    totalprice as total_price,
    orderdate as order_date,
    orderpriority as order_priority,
    clerk,
    shippriority as ship_priority,
    comment
from tpch.tiny.orders;

-- S_PART
insert into memory.dds.sat_part
select
    cast(to_hex(md5(to_utf8(cast(partkey as varchar)))) as varchar) as part_hk,
    current_timestamp as load_date,
    'tpch.tiny.part' as record_source,
    cast(to_hex(md5(to_utf8(
        coalesce(name, '') || '|' ||
        coalesce(mfgr, '') || '|' ||
        coalesce(brand, '') || '|' ||
        coalesce(type, '') || '|' ||
        coalesce(cast(size as varchar), '') || '|' ||
        coalesce(container, '') || '|' ||
        coalesce(cast(retailprice as varchar), '') || '|' ||
        coalesce(comment, '')
    ))) as varchar) as hash_diff,
    name,
    mfgr,
    brand,
    type,
    size,
    container,
    retailprice as retail_price,
    comment
from tpch.tiny.part;

-- S_SUPPLIER
insert into memory.dds.sat_supplier
select
    cast(to_hex(md5(to_utf8(cast(suppkey as varchar)))) as varchar) as supplier_hk,
    current_timestamp as load_date,
    'tpch.tiny.supplier' as record_source,
    cast(to_hex(md5(to_utf8(
        coalesce(name, '') || '|' ||
        coalesce(address, '') || '|' ||
        coalesce(phone, '') || '|' ||
        coalesce(cast(acctbal as varchar), '') || '|' ||
        coalesce(comment, '')
    ))) as varchar) as hash_diff,
    name,
    address,
    phone,
    acctbal,
    comment
from tpch.tiny.supplier;

-- S_PARTSUPP
insert into memory.dds.sat_partsupp
select
    cast(to_hex(md5(to_utf8(cast(partkey as varchar) || '|' || cast(suppkey as varchar)))) as varchar) as partsupp_hk,
    current_timestamp as load_date,
    'tpch.tiny.partsupp' as record_source,
    cast(to_hex(md5(to_utf8(
        coalesce(cast(availqty as varchar), '') || '|' ||
        coalesce(cast(supplycost as varchar), '') || '|' ||
        coalesce(comment, '')
    ))) as varchar) as hash_diff,
    availqty,
    supplycost,
    comment
from tpch.tiny.partsupp;

-- S_LINEITEM
insert into memory.dds.sat_lineitem
select
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar) as lineitem_hk,
    current_timestamp as load_date,
    'tpch.tiny.lineitem' as record_source,
    cast(to_hex(md5(to_utf8(
        coalesce(cast(quantity as varchar), '') || '|' ||
        coalesce(cast(extendedprice as varchar), '') || '|' ||
        coalesce(cast(discount as varchar), '') || '|' ||
        coalesce(cast(tax as varchar), '') || '|' ||
        coalesce(returnflag, '') || '|' ||
        coalesce(linestatus, '') || '|' ||
        coalesce(cast(shipdate as varchar), '') || '|' ||
        coalesce(cast(commitdate as varchar), '') || '|' ||
        coalesce(cast(receiptdate as varchar), '') || '|' ||
        coalesce(shipinstruct, '') || '|' ||
        coalesce(shipmode, '') || '|' ||
        coalesce(comment, '')
    ))) as varchar) as hash_diff,
    quantity,
    extendedprice as extended_price,
    discount,
    tax,
    returnflag as return_flag,
    linestatus as line_status,
    shipdate as ship_date,
    commitdate as commit_date,
    receiptdate as receipt_date,
    shipinstruct as ship_instruct,
    shipmode as ship_mode,
    comment
from tpch.tiny.lineitem;

-- S_NATION
insert into memory.dds.sat_nation
select
    cast(to_hex(md5(to_utf8(cast(nationkey as varchar)))) as varchar) as nation_hk,
    current_timestamp as load_date,
    'tpch.tiny.nation' as record_source,
    cast(to_hex(md5(to_utf8(
        coalesce(name, '') || '|' ||
        coalesce(comment, '')
    ))) as varchar) as hash_diff,
    name,
    comment
from tpch.tiny.nation;

-- S_REGION
insert into memory.dds.sat_region
select
    cast(to_hex(md5(to_utf8(cast(regionkey as varchar)))) as varchar) as region_hk,
    current_timestamp as load_date,
    'tpch.tiny.region' as record_source,
    cast(to_hex(md5(to_utf8(
        coalesce(name, '') || '|' ||
        coalesce(comment, '')
    ))) as varchar) as hash_diff,
    name,
    comment
from tpch.tiny.region;