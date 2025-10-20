%sql
-- 2_bronze_layer.sql
CREATE OR REPLACE TABLE crypto_db.bronze_market_data AS
SELECT
  id,
  symbol,
  name,
  current_price,
  market_cap,
  total_volume,
  current_timestamp() AS ingestion_datetime
FROM crypto_db.raw_market_data;
