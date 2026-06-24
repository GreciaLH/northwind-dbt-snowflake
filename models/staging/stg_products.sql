with source as (

    select * from {{ ref('products') }}

),

renamed as (

    select
        product_id,
        product_name,
        supplier_id,
        category_id,
        cast(unit_price as number(10,4)) as unit_price,
        cast(discontinued as boolean)    as is_discontinued
    from source

)

select * from renamed
