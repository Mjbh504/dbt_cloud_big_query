{{ config(materialized='table') }}

WITH bounds AS (
  SELECT
    DATE_SUB(DATE(MIN(dt)), INTERVAL {{ date_bounds_padding_days() }} DAY) AS start_date,
    DATE_ADD(DATE(MAX(dt)), INTERVAL {{ date_bounds_padding_days() }} DAY) AS end_date
  FROM (
    SELECT created_at AS dt FROM {{ ref('stg_orders') }}
    UNION ALL
    SELECT created_at AS dt FROM {{ ref('stg_order_items') }}
  )
),
calendar AS (
  SELECT day
  FROM bounds,
  UNNEST(GENERATE_DATE_ARRAY(start_date, end_date)) AS day
)
SELECT
  day AS date_day,
  EXTRACT(YEAR FROM day)     AS year,
  EXTRACT(QUARTER FROM day)  AS quarter,
  EXTRACT(MONTH FROM day)    AS month,
  FORMAT_DATE('%Y-%m', day)  AS year_month,
  EXTRACT(WEEK FROM day)     AS week_iso,
  EXTRACT(DAY FROM day)      AS day_of_month,
  FORMAT_DATE('%A', day)     AS day_name,
  CASE WHEN EXTRACT(DAYOFWEEK FROM day) IN (1,7) THEN TRUE ELSE FALSE END AS is_weekend
FROM calendar