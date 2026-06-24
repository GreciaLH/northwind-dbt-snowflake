with source as (

    select * from {{ ref('orders') }}

),

renamed as (

    select
        -- claves
        order_id,
        customer_id,
        employee_id,
        ship_via as shipper_id,          -- renombrado para que case con dim_shipper

        -- fechas (texto -> date)
        cast(order_date as date)    as order_date,
        cast(required_date as date) as required_date,
        cast(nullif(cast(shipped_date as varchar), '') as date) as shipped_date,

        -- medidas / atributos
        cast(freight as number(10,2)) as freight,
        ship_name,
        ship_city,
        ship_region,
        ship_country

    from source

)

select * from renamed
