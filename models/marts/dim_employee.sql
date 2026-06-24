with employees as (

    select * from {{ ref('stg_employees') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['employee_id']) }} as employee_key,
    employee_id,
    full_name,
    title,
    hire_date,
    city,
    country,
    manager_id
from employees
