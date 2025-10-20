# Databricks notebook source
# MAGIC %sql
# MAGIC -- 3_silver_layer.sql
# MAGIC CREATE OR REPLACE TABLE crypto_db.silver_market_data AS
# MAGIC SELECT
# MAGIC   id,
# MAGIC   UPPER(symbol) AS symbol,
# MAGIC   INITCAP(name) AS name,
# MAGIC   CAST(current_price AS DOUBLE) AS price_usd,
# MAGIC   CAST(market_cap AS DOUBLE) AS marketcap_usd,
# MAGIC   CAST(total_volume AS DOUBLE) AS volume_usd,
# MAGIC   ingestion_datetime
# MAGIC FROM crypto_db.bronze_market_data
# MAGIC WHERE current_price IS NOT NULL
# MAGIC   AND market_cap IS NOT NULL;
# MAGIC