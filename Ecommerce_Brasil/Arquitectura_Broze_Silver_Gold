CREATE DATABASE olist_bronze;

SHOW TABLES IN olist_bronze;

CREATE DATABASE IF NOT EXISTS olist_silver;



-- 🧹 Customers → Silver

CREATE OR REPLACE TABLE olist_silver.customers AS
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    CAST(customer_zip_code_prefix AS INT) AS customer_zip_code_prefix,
    customer_city,
    customer_state
FROM olist_bronze.olist_customers_dataset_raw;


-- 🧹 Sellers → Silver

CREATE OR REPLACE TABLE olist_silver.sellers AS
SELECT DISTINCT
    seller_id,
    CAST(seller_zip_code_prefix AS INT) AS seller_zip_code_prefix,
    seller_city,
    seller_state
FROM olist_bronze.olist_sellers_dataset_raw;



-- 🧹 Products → Silver

CREATE OR REPLACE TABLE olist_silver.products AS
SELECT DISTINCT
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_bronze.olist_products_dataset_raw;

--🧹 Orders → Silver
CREATE OR REPLACE TABLE olist_silver.orders AS
SELECT DISTINCT
    order_id,
    customer_id,
    order_status,
    CAST(order_purchase_timestamp AS TIMESTAMP) AS order_purchase_timestamp,
    CAST(order_approved_at AS TIMESTAMP) AS order_approved_at,
    CAST(order_delivered_carrier_date AS TIMESTAMP) AS order_delivered_carrier_date,
    CAST(order_delivered_customer_date AS TIMESTAMP) AS order_delivered_customer_date,
    CAST(order_estimated_delivery_date AS DATE) AS order_estimated_delivery_date
FROM olist_bronze.olist_orders_dataset_raw;

-- 🧹 Order Items → Silver

CREATE OR REPLACE TABLE olist_silver.order_items AS
SELECT DISTINCT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    CAST(shipping_limit_date AS TIMESTAMP) AS shipping_limit_date,
    CAST(price AS DECIMAL(10,2)) AS price,
    CAST(freight_value AS DECIMAL(10,2)) AS freight_value
FROM olist_bronze.olist_order_items_dataset_raw;


-- 🧹 Payments → Silver

CREATE OR REPLACE TABLE olist_silver.payments AS
SELECT DISTINCT
    order_id,
    payment_sequential,
    payment_type,
    CAST(payment_installments AS INT) AS payment_installments,
    CAST(payment_value AS DECIMAL(10,2)) AS payment_value
FROM olist_bronze.olist_order_payments_dataset_raw;

-- 🧹 Reviews → Silver
CREATE OR REPLACE TABLE olist_silver.reviews AS
SELECT DISTINCT
    review_id,
    order_id,
    CAST(review_score AS INT) AS review_score,
    CAST(review_comment_title AS STRING) AS review_comment_title,
    CAST(review_comment_message AS STRING) AS review_comment_message,
    CAST(review_creation_date AS TIMESTAMP) AS review_creation_date,
    CAST(review_answer_timestamp AS TIMESTAMP) AS review_answer_timestamp
FROM olist_bronze.olist_order_reviews_dataset_raw;

-- 📍 Geolocation (Lookup ZIP)
CREATE OR REPLACE TABLE olist_silver.geolocation AS
SELECT DISTINCT
    CAST(geolocation_zip_code_prefix AS INT) AS geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
FROM olist_bronze.olist_geolocation_dataset_raw;


-- Traducir products al ingles

CREATE OR REPLACE TABLE olist_silver.products_translation AS
SELECT
  TRIM(product_category_name) AS product_category_name,
  TRIM(product_category_name_english) AS product_category_name_english
FROM olist_bronze.product_category_name_translation_raw;



-- 
SHOW TABLES IN olist_silver;


--- GOLD

CREATE DATABASE IF NOT EXISTS olist_gold;

/*
⭐ Tabla de hechos

olist_gold.f_sales

🧩 Dimensiones

olist_gold.d_customers

olist_gold.d_sellers

olist_gold.d_products

olist_gold.d_dates

olist_gold.d_geolocation (opcional)
*/




CREATE OR REPLACE TABLE olist_gold.d_customers AS
SELECT DISTINCT
  customer_id,
  customer_unique_id,
  customer_city,
  customer_state
FROM olist_silver.customers;



CREATE OR REPLACE TABLE olist_gold.d_sellers AS
SELECT DISTINCT
  seller_id,
  seller_city,
  seller_state
FROM olist_silver.sellers;


CREATE OR REPLACE TABLE olist_gold.d_products AS
SELECT DISTINCT
  p.product_id,
  t.product_category_name_english AS product_category,
  p.product_weight_g,
  p.product_length_cm,
  p.product_height_cm,
  p.product_width_cm
FROM olist_silver.products p
LEFT JOIN olist_silver.products_translation t
  ON p.product_category_name = t.product_category_name;


CREATE OR REPLACE TABLE olist_gold.f_sales AS
SELECT
  i.order_id,
  i.product_id,
  i.seller_id,
  o.customer_id,
  
  -- Métricas principales
  i.price AS item_price,
  i.freight_value,
  (i.price + i.freight_value) AS revenue,
  1 AS quantity,

  -- Fechas
  o.order_purchase_timestamp AS purchase_date,
  o.order_approved_at AS approved_date,
  o.order_delivered_carrier_date AS carrier_date,
  o.order_delivered_customer_date AS delivered_date,
  o.order_estimated_delivery_date AS estimated_delivery_date,

  -- Payment
  p.payment_type,
  p.payment_installments,
  p.payment_value,
  
  --8 Reviews
  r.review_score

FROM olist_silver.order_items i
LEFT JOIN olist_silver.orders o 
  ON i.order_id = o.order_id
LEFT JOIN olist_silver.payments p
  ON i.order_id = p.order_id
LEFT JOIN olist_silver.reviews r
  ON i.order_id = r.order_id;




CREATE OR REPLACE TABLE olist_gold.d_dates AS
WITH dates AS (
  SELECT explode(
    -- Usamos la función sequence() con el rango dinámico
    sequence(
      (SELECT MIN(purchase_date) FROM olist_gold.f_sales), -- Fecha mínima real
      (SELECT MAX(purchase_date) FROM olist_gold.f_sales), -- Fecha máxima real
      interval 1 day
    )
  ) AS date
)
SELECT
  date,
  -- Componentes básicos de fecha
  year(date) AS year,
  month(date) AS month,
  day(date) AS day,
  -- Componentes de calendario
  weekofyear(date) AS week_of_year,
  quarter(date) AS quarter,
  -- Formatos útiles
  date_format(date, 'yyyyMM') AS year_month,
  date_format(date, 'MMMM') AS month_name,
  date_format(date, 'EEEE') AS day_name,
  -- Indicadores binarios y de orden
  (dayofweek(date) IN (1, 7)) AS is_weekend -- 1 (Domingo) y 7 (Sábado)
FROM dates
ORDER BY date ASC;


SELECT COUNT(*) FROM olist_gold.f_sales;

SELECT * FROM workspace.olist_gold.f_sales


--- cambios en dates

CREATE OR REPLACE TABLE olist_gold.f_sales AS
SELECT
  i.order_id,
  i.product_id,
  i.seller_id,
  o.customer_id,
  
  -- Métricas principales
  i.price AS item_price,
  i.freight_value,
  (i.price + i.freight_value) AS revenue,
  1 AS quantity,

  -- Fechas (convertidas a DATE)
  CAST(o.order_purchase_timestamp AS DATE) AS purchase_date,
  CAST(o.order_approved_at AS DATE) AS approved_date,
  CAST(o.order_delivered_carrier_date AS DATE) AS carrier_date,
  CAST(o.order_delivered_customer_date AS DATE) AS delivered_date,
  CAST(o.order_estimated_delivery_date AS DATE) AS estimated_delivery_date,

  -- Payment
  p.payment_type,
  p.payment_installments,
  p.payment_value,
  
  -- Reviews
  r.review_score

FROM olist_silver.order_items i
LEFT JOIN olist_silver.orders o 
  ON i.order_id = o.order_id
LEFT JOIN olist_silver.payments p
  ON i.order_id = p.order_id
LEFT JOIN olist_silver.reviews r
  ON i.order_id = r.order_id;


CREATE OR REPLACE TABLE olist_gold.d_dates AS
WITH dates AS (
  SELECT explode(
    sequence(
      (SELECT MIN(purchase_date) FROM olist_gold.f_sales),
      (SELECT MAX(purchase_date) FROM olist_gold.f_sales),
      interval 1 day
    )
  ) AS date
)
SELECT
  date AS date,
  year(date) AS year,
  month(date) AS month,
  day(date) AS day,
  weekofyear(date) AS week_of_year,
  quarter(date) AS quarter,
  date_format(date, 'yyyyMM') AS year_month,
  date_format(date, 'MMMM') AS month_name,
  date_format(date, 'EEEE') AS day_name,
  (dayofweek(date) IN (1, 7)) AS is_weekend
FROM dates
ORDER BY date;
