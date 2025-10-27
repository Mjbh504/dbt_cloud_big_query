# Proyecto BI con dbt Cloud, BigQuery y Looker Studio

## 📉 Descripción general

Este proyecto implementa un flujo de datos analítico completo utilizando **dbt Cloud** sobre **BigQuery**, modelando el dataset público `thelook_ecommerce`.
El objetivo es construir un **Data Mart moderno** optimizado para el análisis de **ventas, productos y clientes**, validado con pruebas automáticas y visualizado en **Looker Studio** mediante un dashboard interactivo.

---

## 🔄 Arquitectura del proyecto

```
BigQuery (fuente: thelook_ecommerce)
        ↓
    dbt Cloud (transformaciones)
        ├─ staging layer   (stg_*)
        └─ marts layer     (dim_*, fact_sales)
        ↓
 BigQuery datasets (dbt_mbonilla_staging, dbt_mbonilla_marts)
        ↓
 Looker Studio (dashboard analítico)
```

---

## 🔧 Componentes principales

### **1. Staging Layer (`stg_*`)**

Estandariza y limpia las tablas de origen:

- `stg_users`
- `stg_products`
- `stg_orders`
- `stg_order_items`

### **2. Data Mart (`marts/core`)**

Modelos dimensionales y hechos:

- `dim_customer` → Información de clientes
- `dim_product` → Catálogo de productos
- `dim_date` → Calendario analítico
- `fact_sales` → Hechos de ventas, márgenes y rentabilidad

### **3. Macro personalizada**

Se creó la macro `calc_profit.sql` para centralizar el cálculo de utilidades y márgenes, mejorando la mantenibilidad y trazabilidad de las métricas clave.

---

## ✅ Tests y Calidad de Datos

Se ejecutaron **45 pruebas automáticas** en dbt para validar consistencia e integridad:

- **Not Null** → Verifica campos clave obligatorios.
- **Unique** → Garantiza unicidad en identificadores.
- **Relationships** → Asegura integridad entre tablas de hechos y dimensiones.

**Resultado final:**

```
Total tests: 45
✅ Passed: 45
⚠️ Warnings: 0
❌ Errors: 0
```

---

## 💰 Métricas claves (`fact_sales`)

| Métrica      | Definición                                |
| ------------ | ----------------------------------------- |
| **Revenue**  | `sale_price * num_of_item`                |
| **Cost**     | `cost * num_of_item`                      |
| **Profit**   | `Revenue - Cost`                          |
| **Margin %** | `(Profit / Revenue) * 100`                |
| **AOV**      | `SUM(Revenue) / COUNT(DISTINCT order_id)` |

Estas métricas se utilizan tanto en los modelos dbt como en las visualizaciones de Looker Studio.

---

## 📊 Dashboard en Looker Studio

**Fuente:** BigQuery → Dataset `dbt_mbonilla_marts`

El dashboard se estructura en **3 páginas temáticas**:

### 🔹 Página 1 – _Resumen Ejecutivo_

- KPIs globales: Ingresos, margen total, pedidos y AOV.
- Evolución temporal de ventas.
- Distribución general de ingresos y rentabilidad.

### 🔹 Página 2 – _Análisis de Productos_

- Top 10 productos por ingresos.
- Rentabilidad promedio por categoría.
- Heatmap de margen mensual por categoría.
- Evolución del margen y ventas.

### 🔹 Página 3 – _Análisis de Clientes_

- Ventas por género.
- Mapa geográfico de ingresos por país.
- Top 20 clientes con métricas de rentabilidad.
- Línea temporal de ingresos acumulados por segmento.

---

## ⚙️ Orquestación en dbt Cloud

**Job de Producción (programado):**

```bash
dbt source freshness
dbt build --select +marts
```

**Configuración del job:**

- **Environment:** `Production`
- **Schedule:** Diario a las **07:00 AM**
- **Generate Docs:** Activado
- **Run on merge to main:** Activado

Esto garantiza que el modelo se actualice automáticamente cada día antes de alimentar Looker Studio.

---

## 📚 Documentación y Linaje

**Docs generados en dbt Cloud**:

- Descripciones de modelos, columnas y tests.
- Gráfico de linaje completo desde `stg_*` → `dim_*` → `fact_sales`.
- Validación de dependencias entre fuentes y modelos.

---

## 🗒 Autor

**Mauricio Bonilla**
Proyecto BI — dbt Cloud, BigQuery & Looker Studio
San Pedro Sula, 2025.
