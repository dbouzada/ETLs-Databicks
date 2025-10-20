%sql
-- 4_gold_layer.sql
CREATE OR REPLACE TABLE crypto_db.gold_crypto_metrics AS
SELECT
  name,
  symbol,
  ROUND(price_usd, 2) AS price_usd,
  ROUND(marketcap_usd / 1e9, 2) AS marketcap_billions,
  ROUND(volume_usd / 1e6, 2) AS volume_millions,
  ingestion_datetime
FROM crypto_db.silver_market_data
ORDER BY marketcap_billions DESC;
