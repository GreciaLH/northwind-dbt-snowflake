-- Reconciliación de volumen: fact_orders no debe perder ni duplicar pedidos.
-- Pasa si no devuelve filas (es decir, si los conteos coinciden).

with fact as (
    select count(*) as n_fact from {{ ref('fact_orders') }}
),

staging as (
    select count(*) as n_stg from {{ ref('stg_orders') }}
)

select fact.n_fact, staging.n_stg
from fact
cross join staging
where fact.n_fact != staging.n_stg
