# 🧠 Databricks End-to-End Data Engineering Project

Este proyecto demuestra un pipeline completo de **Ingeniería de Datos en Databricks Community Edition**, conectándose a una API pública de criptomonedas y procesando los datos a través de las capas **Bronze, Silver y Gold**, con visualización final en **Power BI**.

---

## ⚙️ Tecnologías utilizadas
- **Databricks Community Edition**
- **PySpark / SQL**
- **Delta Lake**
- **Power BI**
- **API REST (CoinGecko)**

---

## 🧩 Arquitectura del pipeline

El flujo sigue una estructura de *medallion architecture*:

1. **Ingesta (1_ingestion_api)**  
   Se conecta a la API de CoinGecko y descarga los datos en formato JSON.

2. **Capa Bronze (2_bronze_layer)**  
   Almacena los datos crudos con tipado definido en un DataFrame o tabla.

3. **Capa Silver (3_silver_layer)**  
   Limpieza, normalización y tipificación de campos (por ejemplo: fechas, numéricos, strings).

4. **Capa Gold (4_gold_layer)**  
   Cálculo de métricas agregadas (ej. variación de precio 24h, promedio de market cap, top 10 cryptos, etc.)  
   Esta tabla se conecta luego con **Power BI** para visualización.

---

## 📂 Estructura del repositorio

