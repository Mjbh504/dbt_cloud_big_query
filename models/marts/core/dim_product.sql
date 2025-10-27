{{ config(materialized='table') }}

SELECT
  product_id,                -- PK
  brand,
  category,
  department,
  product_name,
  retail_price,
  cost
FROM {{ ref('stg_products') }}