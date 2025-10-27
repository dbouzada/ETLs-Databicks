🛍️ Olist E-Commerce Analytics — Databricks + Power BI

Este proyecto desarrolla una solución punta a punta de ingesta, modelado, curación y análisis de datos del dataset de Olist (Brasil), aplicando un enfoque Medallion Architecture en Databricks y visualizando métricas clave de negocio en Power BI.

✅ Objetivos del Proyecto

Construir una arquitectura Bronze → Silver → Gold optimizada para Analytics.

Limpiar, transformar y normalizar las principales entidades del e-commerce.

Diseñar un modelo analítico en estrella con tabla de hechos f_sales.

Crear visualizaciones que respondan preguntas de negocio sobre ventas, logística y clientes.

🧱 Arquitectura del Data Lakehouse (Medallion)
Capa	Objetivo	Resultado
Bronze	Ingesta Raw del dataset (sin modificaciones)	Tablas originales Olist
Silver	Transformación, cast de tipos, eliminación de duplicados, ZIP como INT, fechas como TIMESTAMP	Tablas limpias para Analytics
Gold	Modelo dimensional	⭐ f_sales + Dimensiones (d_customers, d_sellers, d_products, d_dates)
🧩 Modelo Dimensional

Tabla de hechos

olist_gold.f_sales
Contiene métricas transaccionales de ventas (revenue, freight, payment, review score) y claves de relación.

Dimensiones

d_customers (Localización del cliente)

d_sellers (Localización del vendedor)

d_products (Categoría de producto traducida al inglés)

d_dates (Calendario desde min/max fecha real)

📌 d_dates generada dinámicamente con sequence() → evita años incorrectos y asegura continuidad temporal.

📊 Análisis en Power BI

2 reportes creados:

1️⃣ KPIs comerciales

Ingresos totales

Cantidad de productos vendidos

Ticket promedio

Distribución por método de pago

2️⃣ Performance logística

SLA de entrega vs estimado

Revenue por estado (UF)

Satisfacción del cliente (Review Score)

📍 Relaciones en Estrella: f_sales como tabla central

🛠️ Tecnologías Utilizadas
Componente	Tecnología
Data Lakehouse	Databricks + Spark SQL
Orquestación	Notebooks dentro de workspace
Modelado	Star Schema
Análisis	Power BI Desktop
Dataset	Olist E-Commerce (Kaggle)
🚀 Próximos Pasos (Backlog)

Incorporar geolocalización a nivel lat/lng

Agregar indicadores de tiempo (Año fiscal, Periodos móviles)

Implementar Delta Lake + Auto Loader para escenarios incrementales
