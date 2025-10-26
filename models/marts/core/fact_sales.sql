{{ config(
    materialized='table',
    partition_by={'field': 'order_date', 'data_type': 'date'},
    cluster_by=['product_id','user_id','order_id']
) }}

WITH oi AS (
  SELECT * FROM {{ ref('stg_order_items') }}
),
o AS (
  SELECT * FROM {{ ref('stg_orders') }}
),
p AS (
  SELECT * FROM {{ ref('stg_products') }}
)

SELECT
  oi.order_item_id,                 -- PK de hecho
  oi.order_id,
  oi.user_id,
  oi.product_id,

  DATE(oi.created_at)     AS order_date,      -- clave de fecha
  oi.item_status          AS item_status,

  -- Métricas
  oi.sale_price           AS revenue,         -- ingreso por ítem
  p.cost                  AS cost,            -- costo unitario (desde producto)
  (oi.sale_price - p.cost)           AS profit,
  SAFE_DIVIDE(oi.sale_price - p.cost, oi.sale_price) AS margin_pct,

  -- Extras útiles
  o.order_status          AS order_status,
  o.num_items             AS order_items_count
FROM oi
LEFT JOIN o ON oi.order_id  = o.order_id
LEFT JOIN p ON oi.product_id = p.product_id
