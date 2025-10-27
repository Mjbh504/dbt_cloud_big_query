{{ config(materialized='view') }}

WITH src AS (
  SELECT
    id,
    brand,
    category,
    department,
    name,
    retail_price,
    cost
  FROM {{ source('thelook', 'products') }}
),

clean AS (
  SELECT
    CAST(id AS INT64)                               AS product_id,
    -- Limpieza de textos: TRIM, convertir vacíos a NULL y luego COALESCE a 'UNKNOWN'
    COALESCE(NULLIF(TRIM(CAST(brand AS STRING)), ''), 'UNKNOWN')      AS brand,
    COALESCE(NULLIF(TRIM(CAST(category AS STRING)), ''), 'UNKNOWN')   AS category,
    COALESCE(NULLIF(TRIM(CAST(department AS STRING)), ''), 'UNKNOWN') AS department,
    COALESCE(NULLIF(TRIM(CAST(name AS STRING)), ''), 'UNKNOWN')       AS product_name,

    CAST(retail_price AS NUMERIC)                  AS retail_price,
    CAST(cost AS NUMERIC)                          AS cost
  FROM src
)

SELECT * FROM clean