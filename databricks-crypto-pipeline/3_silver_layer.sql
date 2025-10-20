%sql
-- 3_silver_layer.sql
CREATE OR REPLACE TABLE crypto_db.silver_market_data AS
SELECT
  id,
  UPPER(symbol) AS symbol,
  INITCAP(name) AS name,
  CAST(current_price AS DOUBLE) AS price_usd,
  CAST(market_cap AS DOUBLE) AS marketcap_usd,
  CAST(total_volume AS DOUBLE) AS volume_usd,
  ingestion_datetime
FROM crypto_db.bronze_market_data
WHERE current_price IS NOT NULL
  AND market_cap IS NOT NULL;
