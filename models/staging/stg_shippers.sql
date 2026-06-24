with source as (

    select * from {{ ref('shippers') }}

),

renamed as (

    select
        shipper_id,
        company_name as shipper_name
    from source

)

select * from renamed
