# Databricks notebook source
# MAGIC %sql
# MAGIC -- 2_bronze_layer.sql
# MAGIC CREATE OR REPLACE TABLE crypto_db.bronze_market_data AS
# MAGIC SELECT
# MAGIC   id,
# MAGIC   symbol,
# MAGIC   name,
# MAGIC   current_price,
# MAGIC   market_cap,
# MAGIC   total_volume,
# MAGIC   current_timestamp() AS ingestion_datetime
# MAGIC FROM crypto_db.raw_market_data;
# MAGIC