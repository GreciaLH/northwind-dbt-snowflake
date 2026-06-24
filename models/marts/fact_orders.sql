with orders as (

    select * from {{ ref('stg_orders') }}

),

order_details as (

    select * from {{ ref('stg_order_details') }}

),

dim_customer as (

    select * from {{ ref('dim_customer') }}

),

dim_employee as (

    select * from {{ ref('dim_employee') }}

),

dim_shipper as (

    select * from {{ ref('dim_shipper') }}

),

-- pre-agregamos las líneas a nivel de pedido
order_amounts as (

    select
        order_id,
        count(*)                                      as num_line_items,
        sum(quantity)                                 as total_quantity,
        sum(quantity * unit_price * (1 - discount))   as order_total
    from order_details
    group by order_id

),

final as (

    select
        {{ dbt_utils.generate_surrogate_key(['orders.order_id']) }} as order_key,

        -- dimensión degenerada
        orders.order_id,

        -- claves foráneas
        dim_customer.customer_key,
        dim_employee.employee_key,
        dim_shipper.shipper_key,
        cast(to_char(orders.order_date, 'YYYYMMDD') as integer) as order_date_key,

        -- medidas
        orders.freight,
        coalesce(order_amounts.order_total, 0)    as order_total,
        coalesce(order_amounts.num_line_items, 0) as num_line_items,
        coalesce(order_amounts.total_quantity, 0) as total_quantity,
        datediff('day', orders.order_date, orders.shipped_date) as days_to_ship

    from orders
    left join order_amounts on orders.order_id    = order_amounts.order_id
    left join dim_customer  on orders.customer_id = dim_customer.customer_id
    left join dim_employee  on orders.employee_id = dim_employee.employee_id
    left join dim_shipper   on orders.shipper_id  = dim_shipper.shipper_id

)

select * from final
