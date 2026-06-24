-- Reconciliación entre los dos granos: el total de cada pedido (fact_orders)
-- debe coincidir con la suma de los importes de sus líneas (fact_order_details).
-- Pasa si no devuelve filas.

with order_level as (
    select order_id, order_total
    from {{ ref('fact_orders') }}
),

line_level as (
    select order_id, sum(net_amount) as lines_total
    from {{ ref('fact_order_details') }}
    group by order_id
)

select
    o.order_id,
    o.order_total,
    l.lines_total
from order_level o
join line_level l on o.order_id = l.order_id
where abs(o.order_total - l.lines_total) > 0.01
