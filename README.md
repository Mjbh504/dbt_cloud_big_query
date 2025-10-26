# Proyecto BI con dbt Cloud y BigQuery

## 📉 Descripción general

Este proyecto implementa un flujo de datos analítico completo utilizando **dbt Cloud** sobre **BigQuery**, modelando el dataset público `thelook_ecommerce`. El objetivo es construir un **Data Mart** optimizado para análisis de ventas, clientes y productos, y exponerlo en una herramienta de visualización (Looker Studio o Power BI).

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
 Looker Studio / Power BI (dashboard final)
```

---

## 🔧 Componentes principales

### **1. Staging Layer (`stg_*`)**

Estandariza y limpia las tablas de origen:

* `stg_users`
* `stg_products`
* `stg_orders`
* `stg_order_items`

### **2. Data Mart (`marts/core`)**

Modelos dimensionales:

* `dim_customer` → Datos de clientes
* `dim_product` → Catálogo de productos
* `dim_date` → Calendario analítico
* `fact_sales` → Métricas de ventas y rentabilidad (nivel de detalle: `order_item_id`)

### **3. Tests y Calidad de Datos**

Se ejecutaron **45 pruebas** automáticas con dbt:

* **Not Null:** validación de claves y campos obligatorios.
* **Unique:** verificación de unicidad de identificadores.
* **Relationships:** integridad referencial entre dimensiones y hechos.

Resultado final:

```
Total tests: 45
✅ Passed: 41
⚠️ Warning: 0
❌ Errors: 4 (modelos de prueba inicial no usados en marts)
```

---

## 🔢 Métricas claves (fact_sales)

| Métrica      | Definición                                |
| ------------ | ----------------------------------------- |
| **Revenue**  | `sale_price * num_of_item`                |
| **Cost**     | `cost * num_of_item`                      |
| **Profit**   | `Revenue - Cost`                          |
| **Margin %** | `(Profit / Revenue) * 100`                |
| **AOV**      | `SUM(Revenue) / COUNT(DISTINCT order_id)` |

---

## 📊 Dashboard (Looker Studio / Power BI)

**Conexión:** BigQuery → Dataset `dbt_mbonilla_marts`

**Visualizaciones sugeridas:**

1. Ventas por día (gráfica de línea)
2. Top 10 productos por revenue
3. Margen promedio por categoría
4. Ventas por género de cliente
5. KPIs globales: ingresos totales, margen total, número de pedidos, AOV

---

## 🛠️ Orquestación en dbt Cloud

**Job de producción (ejemplo):**

```bash
dbt source freshness
dbt build --select +marts
```

**Configuración:**

* Environment: `Production`
* Schedule: diario 07:00 AM
* Generate Docs: activado
* Run on merge to main: activado

---

## 📃 Documentación generada

Documentación y linaje disponibles en dbt Cloud (Docs → Generate Docs):

* Descripciones de modelos, columnas y tests.
* Gráfico de linaje completo (`stg_*` → `dim_*` → `fact_sales`).

---

## 🗒 Autor

**Mauricio Bonilla**
Proyecto BI — dbt Cloud & BigQuery
San Pedro Sula, 2025.