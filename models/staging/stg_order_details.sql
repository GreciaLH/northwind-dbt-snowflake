with source as (

    select * from {{ ref('order_details') }}

),

renamed as (

    select
        order_id,
        product_id,
        cast(unit_price as number(10,4)) as unit_price,
        cast(quantity as integer)        as quantity,
        cast(discount as number(5,4))    as discount
    from source

)

select * from renamed
