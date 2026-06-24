with source as (

    select * from {{ ref('employees') }}

),

renamed as (

    select
        employee_id,
        first_name,
        last_name,
        first_name || ' ' || last_name as full_name,
        title,
        cast(hire_date as date) as hire_date,
        city,
        country,
        reports_to as manager_id
    from source

)

select * from renamed
