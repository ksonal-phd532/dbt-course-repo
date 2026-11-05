INSERT INTO user_ksonal.dbt_airbnb.raw_reviews 
VALUES (3176, CURRENT_TIMESTAMP(), 'Zoltan', 'excellent stay!', 'positive')

SELECT * FROM user_ksonal.dbt_airbnb.fct_reviews
WHERE listing_id = 3176;

DROP VIEW user_ksonal.dbt_airbnb.src_listings;
DROP VIEW user_ksonal.dbt_airbnb.src_hosts;
DROP VIEW user_ksonal.dbt_airbnb.src_reviews;
