-- Cálculo de ganancia (profit)

{% macro calc_profit(sale_price, cost) -%}
    -- Usa COALESCE para evitar valores nulos
    (COALESCE({{ sale_price }}, 0) - COALESCE({{ cost }}, 0))
{%- endmacro %}

-- Cálculo de margen porcentual (profit / revenue)

{% macro calc_margin_pct(sale_price, cost) -%}
    -- SAFE_DIVIDE evita error por división entre 0 o NULL
    SAFE_DIVIDE({{ calc_profit(sale_price, cost) }}, NULLIF({{ sale_price }}, 0))
{%- endmacro %}

-- Macro para controlar el rango de fechas (colchón)

{% macro date_bounds_padding_days() -%}
    -- Usa variable global, por defecto 60 días si no está definida
    {{ var('date_padding_days', 60) }}
{%- endmacro %}