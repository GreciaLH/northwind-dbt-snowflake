with source as (

    select * from {{ ref('suppliers') }}

),

renamed as (

    select
        supplier_id,
        company_name as supplier_name,
        country      as supplier_country
    from source

)

select * from renamed
