with customers as (

    select * from {{ ref('stg_customers') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_key,
    customer_id,
    company_name,
    contact_name,
    contact_title,
    city,
    region,
    country
from customers
