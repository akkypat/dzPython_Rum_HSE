-- H_CUSTOMER
insert into memory.dds.hub_order
select distinct
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar)))) as varchar) as order_hk,
    orderkey as order_key,
    current_timestamp as load_date,
    'tpch.tiny.orders' as record_source
from tpch.tiny.orders
where orderdate = date 'LOAD_DATE'
and cast(to_hex(md5(to_utf8(cast(orderkey as varchar)))) as varchar) not in (
    select order_hk from memory.dds.hub_order
);

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
from tpch.tiny.orders
where orderdate = date 'LOAD_DATE'
and cast(to_hex(md5(to_utf8(
    cast(to_hex(md5(to_utf8(cast(custkey as varchar)))) as varchar) || '|' ||
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar)))) as varchar)
))) as varchar) not in (
    select customer_order_hk from memory.dds.link_customer_order
);

-- S_ORDER
insert into memory.dds.sat_order
select
    cast(to_hex(md5(to_utf8(cast(o.orderkey as varchar)))) as varchar) as order_hk,
    current_timestamp as load_date,
    'tpch.tiny.orders' as record_source,
    cast(to_hex(md5(to_utf8(
        coalesce(o.orderstatus, '') || '|' ||
        coalesce(cast(o.totalprice as varchar), '') || '|' ||
        coalesce(cast(o.orderdate as varchar), '') || '|' ||
        coalesce(o.orderpriority, '') || '|' ||
        coalesce(o.clerk, '') || '|' ||
        coalesce(cast(o.shippriority as varchar), '') || '|' ||
        coalesce(o.comment, '')
    ))) as varchar) as hash_diff,
    o.orderstatus as order_status,
    o.totalprice as total_price,
    o.orderdate as order_date,
    o.orderpriority as order_priority,
    o.clerk,
    o.shippriority as ship_priority,
    o.comment
from tpch.tiny.orders o
where o.orderdate = date 'LOAD_DATE'
and cast(to_hex(md5(to_utf8(
    coalesce(o.orderstatus, '') || '|' ||
    coalesce(cast(o.totalprice as varchar), '') || '|' ||
    coalesce(cast(o.orderdate as varchar), '') || '|' ||
    coalesce(o.orderpriority, '') || '|' ||
    coalesce(o.clerk, '') || '|' ||
    coalesce(cast(o.shippriority as varchar), '') || '|' ||
    coalesce(o.comment, '')
))) as varchar) not in (
    select hash_diff 
    from memory.dds.sat_order s
    where s.order_hk = cast(to_hex(md5(to_utf8(cast(o.orderkey as varchar)))) as varchar)
);

-- H_LINEITEM
insert into memory.dds.hub_lineitem
select distinct
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar) as lineitem_hk,
    orderkey as order_key,
    linenumber as line_number,
    current_timestamp as load_date,
    'tpch.tiny.lineitem' as record_source
from tpch.tiny.lineitem
where shipdate = date 'LOAD_DATE'
and cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar) not in (
    select lineitem_hk from memory.dds.hub_lineitem
);

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
from tpch.tiny.lineitem
where shipdate = date 'LOAD_DATE'
and cast(to_hex(md5(to_utf8(
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar)))) as varchar) || '|' ||
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar)
))) as varchar) not in (
    select order_lineitem_hk from memory.dds.link_order_lineitem
);

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
from tpch.tiny.lineitem
where shipdate = date 'LOAD_DATE'
and cast(to_hex(md5(to_utf8(
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar) || '|' ||
    cast(to_hex(md5(to_utf8(cast(partkey as varchar)))) as varchar)
))) as varchar) not in (
    select lineitem_part_hk from memory.dds.link_lineitem_part
);

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
from tpch.tiny.lineitem
where shipdate = date 'LOAD_DATE'
and cast(to_hex(md5(to_utf8(
    cast(to_hex(md5(to_utf8(cast(orderkey as varchar) || '|' || cast(linenumber as varchar)))) as varchar) || '|' ||
    cast(to_hex(md5(to_utf8(cast(suppkey as varchar)))) as varchar)
))) as varchar) not in (
    select lineitem_supplier_hk from memory.dds.link_lineitem_supplier
);

-- S_LINEITEM
insert into memory.dds.sat_lineitem
select
    cast(to_hex(md5(to_utf8(cast(li.orderkey as varchar) || '|' || cast(li.linenumber as varchar)))) as varchar) as lineitem_hk,
    current_timestamp as load_date,
    'tpch.tiny.lineitem' as record_source,
    cast(to_hex(md5(to_utf8(
        coalesce(cast(li.quantity as varchar), '') || '|' ||
        coalesce(cast(li.extendedprice as varchar), '') || '|' ||
        coalesce(cast(li.discount as varchar), '') || '|' ||
        coalesce(cast(li.tax as varchar), '') || '|' ||
        coalesce(li.returnflag, '') || '|' ||
        coalesce(li.linestatus, '') || '|' ||
        coalesce(cast(li.shipdate as varchar), '') || '|' ||
        coalesce(cast(li.commitdate as varchar), '') || '|' ||
        coalesce(cast(li.receiptdate as varchar), '') || '|' ||
        coalesce(li.shipinstruct, '') || '|' ||
        coalesce(li.shipmode, '') || '|' ||
        coalesce(li.comment, '')
    ))) as varchar) as hash_diff,
    li.quantity,
    li.extendedprice as extended_price,
    li.discount,
    li.tax,
    li.returnflag as return_flag,
    li.linestatus as line_status,
    li.shipdate as ship_date,
    li.commitdate as commit_date,
    li.receiptdate as receipt_date,
    li.shipinstruct as ship_instruct,
    li.shipmode as ship_mode,
    li.comment
from tpch.tiny.lineitem li
where li.shipdate = date 'LOAD_DATE'
and cast(to_hex(md5(to_utf8(
    coalesce(cast(li.quantity as varchar), '') || '|' ||
    coalesce(cast(li.extendedprice as varchar), '') || '|' ||
    coalesce(cast(li.discount as varchar), '') || '|' ||
    coalesce(cast(li.tax as varchar), '') || '|' ||
    coalesce(li.returnflag, '') || '|' ||
    coalesce(li.linestatus, '') || '|' ||
    coalesce(cast(li.shipdate as varchar), '') || '|' ||
    coalesce(cast(li.commitdate as varchar), '') || '|' ||
    coalesce(cast(li.receiptdate as varchar), '') || '|' ||
    coalesce(li.shipinstruct, '') || '|' ||
    coalesce(li.shipmode, '') || '|' ||
    coalesce(li.comment, '')
))) as varchar) not in (
    select hash_diff 
    from memory.dds.sat_lineitem s
    where s.lineitem_hk = cast(to_hex(md5(to_utf8(cast(li.orderkey as varchar) || '|' || cast(li.linenumber as varchar)))) as varchar)
);