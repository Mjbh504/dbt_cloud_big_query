{{ config(materialized='table') }}

SELECT
  user_id,                   -- PK
  full_name,
  gender,
  email,
  state,
  country,
  created_at,
  created_date
FROM {{ ref('stg_users') }}
