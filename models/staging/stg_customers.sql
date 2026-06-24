with source as (

    select * from {{ ref('customers') }}

),

renamed as (

    select
        customer_id,
        company_name,
        contact_name,
        contact_title,
        city,
        region,
        country
    from source

)

select * from renamed
