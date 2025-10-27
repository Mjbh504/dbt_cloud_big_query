{{ config(materialized='view') }}

WITH src AS (
  SELECT
    order_id,
    user_id,
    status,
    gender,
    created_at,
    returned_at,
    shipped_at,
    delivered_at,
    num_of_item
  FROM {{ source('thelook', 'orders') }}
)

SELECT
  CAST(order_id AS INT64)  AS order_id,
  CAST(user_id AS INT64)   AS user_id,
  CAST(status AS STRING)   AS order_status,
  CAST(gender AS STRING)   AS user_gender,
  created_at               AS created_at,     
  returned_at              AS returned_at,    
  shipped_at               AS shipped_at,     
  delivered_at             AS delivered_at,  
  CAST(num_of_item AS INT64) AS num_items,

  -- derivadas útiles
  DATE(created_at)                         AS order_date,
  FORMAT_DATE('%Y-%m', DATE(created_at))   AS order_month
FROM src