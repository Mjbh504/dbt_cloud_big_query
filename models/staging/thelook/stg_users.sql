{{ config(materialized='view') }}

WITH src AS (
  SELECT
    id,
    first_name,
    last_name,
    gender,
    email,
    state,
    country,
    created_at
  FROM {{ source('thelook', 'users') }}
)

SELECT
  CAST(id AS INT64)             AS user_id,
  CAST(first_name AS STRING)    AS first_name,
  CAST(last_name AS STRING)     AS last_name,
  CAST(gender AS STRING)        AS gender,
  CAST(email AS STRING)         AS email,
  CAST(state AS STRING)         AS state,
  CAST(country AS STRING)       AS country,
  created_at                    AS created_at,        -- TIMESTAMP
  CONCAT(first_name, ' ', last_name) AS full_name,
  DATE(created_at)              AS created_date
FROM src
