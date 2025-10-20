# Databricks notebook source
# 1_ingestion_api - Notebook (Python)
# Adjuntar el cluster antes de correr

import requests
import pandas as pd
from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()

# --- Llamada a la API CoinGecko (ejemplo) ---
url = "https://api.coingecko.com/api/v3/coins/markets"
params = {
    "vs_currency": "usd",
    "order": "market_cap_desc",
    "per_page": 50,   # ajustá la cantidad
    "page": 1,
    "sparkline": "false"
}

resp = requests.get(url, params=params)
data = resp.json()

# Convertir a pandas y luego a spark
df = pd.DataFrame(data)
# Seleccionar columnas de interés
df = df[["id","symbol","name","current_price","market_cap","total_volume"]]

spark_df = spark.createDataFrame(df)
# Guardar como tabla en la db
spark_df.write.mode("overwrite").saveAsTable("crypto_db.raw_market_data")

print("Ingesta finalizada. Registros:", spark_df.count())
