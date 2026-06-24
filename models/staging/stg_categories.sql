with source as (

    select * from {{ ref('categories') }}

),

renamed as (

    select
        category_id,
        category_name,
        description as category_description
    from source

)

select * from renamed
