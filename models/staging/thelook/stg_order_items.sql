{{ config(materialized='view') }}

WITH src AS (
  SELECT
    id,
    order_id,
    user_id,
    product_id,
    sale_price,
    status,
    created_at
  FROM {{ source('thelook', 'order_items') }}
),

clean AS (
  SELECT
    CAST(id AS INT64)           AS order_item_id,
    CAST(order_id AS INT64)     AS order_id,
    CAST(user_id AS INT64)      AS user_id,
    CAST(product_id AS INT64)   AS product_id,
    CAST(sale_price AS NUMERIC) AS sale_price,
    CAST(status AS STRING)      AS item_status,
    created_at                  AS created_at,      -- TIMESTAMP
    DATE(created_at)            AS order_item_date
  FROM src
)

SELECT * FROM clean