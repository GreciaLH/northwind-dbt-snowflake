with products as (

    select * from {{ ref('stg_products') }}

),

categories as (

    select * from {{ ref('stg_categories') }}

),

suppliers as (

    select * from {{ ref('stg_suppliers') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    products.product_id,
    products.product_name,
    products.unit_price,
    products.is_discontinued,

    -- atributos de categoría (desnormalizados)
    categories.category_name,
    categories.category_description,

    -- atributos de proveedor (desnormalizados)
    suppliers.supplier_name,
    suppliers.supplier_country

from products
left join categories on products.category_id = categories.category_id
left join suppliers  on products.supplier_id = suppliers.supplier_id
