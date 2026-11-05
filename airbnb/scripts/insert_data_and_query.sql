INSERT INTO user_ksonal.dbt_airbnb.raw_reviews 
VALUES (3176, CURRENT_TIMESTAMP(), 'Zoltan', 'excellent stay!', 'positive')

SELECT * FROM user_ksonal.dbt_airbnb.fct_reviews
WHERE listing_id = 3176;

DROP VIEW user_ksonal.dbt_airbnb.src_listings;
DROP VIEW user_ksonal.dbt_airbnb.src_hosts;
DROP VIEW user_ksonal.dbt_airbnb.src_reviews;


UPDATE user_ksonal.dbt_airbnb.raw_listings SET minimum_nights=30, updated_at=CURRENT_TIMESTAMP() WHERE id=3176; 

SELECT * FROM user_ksonal.dbt_airbnb.scd_raw_listings WHERE id=3176;