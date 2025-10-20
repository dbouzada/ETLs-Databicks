# Databricks notebook source
# MAGIC %sql
# MAGIC -- 4_gold_layer.sql
# MAGIC CREATE OR REPLACE TABLE crypto_db.gold_crypto_metrics AS
# MAGIC SELECT
# MAGIC   name,
# MAGIC   symbol,
# MAGIC   ROUND(price_usd, 2) AS price_usd,
# MAGIC   ROUND(marketcap_usd / 1e9, 2) AS marketcap_billions,
# MAGIC   ROUND(volume_usd / 1e6, 2) AS volume_millions,
# MAGIC   ingestion_datetime
# MAGIC FROM crypto_db.silver_market_data
# MAGIC ORDER BY marketcap_billions DESC;
# MAGIC