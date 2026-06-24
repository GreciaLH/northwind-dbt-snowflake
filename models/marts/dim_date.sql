with date_spine as (

    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="to_date('1996-01-01')",
        end_date="to_date('1999-01-01')"
    ) }}

),

calendar as (

    select cast(date_day as date) as date_day
    from date_spine

)

select
    cast(to_char(date_day, 'YYYYMMDD') as integer) as date_key,
    date_day,
    year(date_day)       as year,
    quarter(date_day)    as quarter,
    month(date_day)      as month,
    monthname(date_day)  as month_name,
    day(date_day)        as day_of_month,
    dayname(date_day)    as day_name,
    case when dayname(date_day) in ('Sat', 'Sun') then true else false end as is_weekend
from calendar
