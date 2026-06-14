{{
  config(
    materialized='table',
    schema='marts_shared',
  )
}}
with date_spine as (
  {{ dbt_utils.date_spine(
      datepart="day",
      start_date="cast('2010-01-01' as date)",
      end_date="cast('2030-12-31' as date)"
  ) }}
),
final as (
  select
    to_char(date_day, 'YYYYMMDD')::int as date_key,
    date_day as calendar_date,
    extract(isodow from date_day)::int as day_of_week,
    extract(day from date_day)::int as day_of_month,
    extract(month from date_day)::int as month,
    extract(quarter from date_day)::int as quarter,
    extract(year from date_day)::int as year,
    to_char(date_day, 'Month') as month_name,
    'Q' || extract(quarter from date_day)::text as quarter_name,
    extract(isodow from date_day) in (6, 7) as is_weekend,
    extract(year from date_day)::int as fiscal_year,
    extract(quarter from date_day)::int as fiscal_quarter
  from date_spine
)
select * from final
