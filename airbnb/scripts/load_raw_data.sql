-- Create the raw Airbnb tables in USER_KSONAL.DBT_AIRBNB and load them from local CSVs.
-- Run with the Snowflake CLI (PUT needs a client, it does not work in Snowsight):
--   snow sql -c PHDATAPARTNER-AWS -f airbnb/scripts/load_raw_data.sql

USE ROLE ALL_DE_ARCHITECTS;
USE WAREHOUSE COMPUTE_WH;
USE SCHEMA USER_KSONAL.DBT_AIRBNB;

-- File format: headered CSV, quoted fields (review comments contain commas)
CREATE OR REPLACE FILE FORMAT airbnb_csv
  TYPE = CSV
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  EMPTY_FIELD_AS_NULL = TRUE
  NULL_IF = ('', 'NULL');

CREATE STAGE IF NOT EXISTS airbnb_raw_stage FILE_FORMAT = airbnb_csv;

-- Upload local files from airbnb/data (auto-compressed to .gz).
-- Paths are relative to the repo root, so run the script from there.
PUT 'file://airbnb/data/hosts.csv'    @airbnb_raw_stage/hosts/    AUTO_COMPRESS = TRUE OVERWRITE = TRUE;
PUT 'file://airbnb/data/listings.csv' @airbnb_raw_stage/listings/ AUTO_COMPRESS = TRUE OVERWRITE = TRUE;
PUT 'file://airbnb/data/reviews.csv'  @airbnb_raw_stage/reviews/  AUTO_COMPRESS = TRUE OVERWRITE = TRUE;

-- Tables
CREATE OR REPLACE TABLE raw_hosts (
    id           INTEGER,
    name         STRING,
    is_superhost STRING,
    created_at   DATETIME,
    updated_at   DATETIME
);

CREATE OR REPLACE TABLE raw_listings (
    id             INTEGER,
    listing_url    STRING,
    name           STRING,
    room_type      STRING,
    minimum_nights INTEGER,
    host_id        INTEGER,
    price          STRING,
    created_at     DATETIME,
    updated_at     DATETIME
);

CREATE OR REPLACE TABLE raw_reviews (
    listing_id    INTEGER,
    date          DATETIME,
    reviewer_name STRING,
    comments      STRING,
    sentiment     STRING
);

-- Load
COPY INTO raw_hosts (id, name, is_superhost, created_at, updated_at)
  FROM @airbnb_raw_stage/hosts/
  ON_ERROR = ABORT_STATEMENT;

COPY INTO raw_listings (id, listing_url, name, room_type, minimum_nights, host_id, price, created_at, updated_at)
  FROM @airbnb_raw_stage/listings/
  ON_ERROR = ABORT_STATEMENT;

COPY INTO raw_reviews (listing_id, date, reviewer_name, comments, sentiment)
  FROM @airbnb_raw_stage/reviews/
  ON_ERROR = ABORT_STATEMENT;

-- Verify
SELECT 'raw_hosts' AS table_name, COUNT(*) AS row_count FROM raw_hosts
UNION ALL SELECT 'raw_listings', COUNT(*) FROM raw_listings
UNION ALL SELECT 'raw_reviews',  COUNT(*) FROM raw_reviews;
