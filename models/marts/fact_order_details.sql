with order_details as (

    select * from {{ ref('stg_order_details') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

dim_product as (

    select * from {{ ref('dim_product') }}

),

dim_customer as (

    select * from {{ ref('dim_customer') }}

),

dim_employee as (

    select * from {{ ref('dim_employee') }}

),

joined as (

    select
        -- clave subrogada del hecho (grano = order_id + product_id)
        {{ dbt_utils.generate_surrogate_key(['od.order_id', 'od.product_id']) }} as order_detail_key,

        -- dimensión degenerada
        od.order_id,

        -- claves foráneas al modelo estrella
        dim_product.product_key,
        dim_customer.customer_key,
        dim_employee.employee_key,
        cast(to_char(orders.order_date, 'YYYYMMDD') as integer) as order_date_key,

        -- medidas
        od.quantity,
        od.unit_price,
        od.discount,
        od.quantity * od.unit_price                     as gross_amount,
        od.quantity * od.unit_price * od.discount        as discount_amount,
        od.quantity * od.unit_price * (1 - od.discount)  as net_amount

    from order_details od
    inner join orders       on od.order_id   = orders.order_id
    left  join dim_product  on od.product_id = dim_product.product_id
    left  join dim_customer on orders.customer_id = dim_customer.customer_id
    left  join dim_employee on orders.employee_id = dim_employee.employee_id

)

select * from joined
