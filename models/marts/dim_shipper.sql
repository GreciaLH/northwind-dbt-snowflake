with shippers as (

    select * from {{ ref('stg_shippers') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['shipper_id']) }} as shipper_key,
    shipper_id,
    shipper_name
from shippers
