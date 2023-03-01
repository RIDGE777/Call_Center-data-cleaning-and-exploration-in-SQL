-- CallCenter VIEWING THE DATA AND CLEANING

SELECT * FROM CallCenter..call_center


-- Check table data types
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'call_center'

-- Change data type of call_timestamp into date data type
ALTER TABLE call_center
ALTER COLUMN call_timestamp DATE;

-- Change data type of call_duration_minutes into int data type
ALTER TABLE call_center
ALTER COLUMN call_duration_minutes int;


-- Check and count NULLS in the dataset
--- We discover that 20670 rows have NULLS for the csat_score, customer satisfaction score
SELECT COUNT (id) FROM CallCenter..call_center
WHERE csat_score IS NULL;

--This means that we will create a new column csat_rating and use the sentiment column to rate
--- Very Negative = 1, Negative = 2, Neutral = 3, Positive = 4, Very Positive = 5

--- Create a new column csat_rating
ALTER TABLE call_center
ADD csat_rating INT;

UPDATE call_center
SET csat_rating = 
    CASE sentiment
        WHEN 'Very Negative' THEN 1
        WHEN 'Negative' THEN 2
        WHEN 'Neutral' THEN 3
        WHEN 'Positive' THEN 4
        WHEN 'Very Positive' THEN 5
        ELSE NULL
    END;


--- Drop customer_name and csat_score columns since we will not need them
ALTER TABLE call_center
DROP COLUMN customer_name;

ALTER TABLE call_center
DROP COLUMN csat_score;


-- DATA EXPLORATION

--- Check number of customer reachouts to call center - 32941
SELECT COUNT (DISTINCT id) FROM call_center


--- Check customer sentiments- They are 5, Very Negative, Negative, Neutral, Positive, Very Positive.
SELECT COUNT (DISTINCT sentiment) FROM call_center

---- How did 32941 customer reachouts speak	about the service
---- Very Negative = 6026 
SELECT COUNT (DISTINCT id) FROM call_center
WHERE sentiment = 'Very Negative'

---- Negative = 11063
SELECT COUNT (DISTINCT id) FROM call_center
WHERE sentiment = 'Negative'

---- Neutral = 8754
SELECT COUNT (DISTINCT id) FROM call_center
WHERE sentiment = 'Neutral'

---- Positive = 3928
SELECT COUNT (DISTINCT id) FROM call_center
WHERE sentiment = 'Positive'

---- Very Positive = 3170
SELECT COUNT (DISTINCT id) FROM call_center
WHERE sentiment = 'Very Positive'


--- Check period of time for the call_center data
---- This data is between 1st and 31st of October, 2020
SELECT * FROM call_center
ORDER BY call_timestamp ASC


--- Check the day with the highest number of customer reachouts
---- The day with the highest customer reachouts had 1170 and the minimum was 1
SELECT call_timestamp, COUNT(DISTINCT id) AS daily_customers 
FROM call_center 
GROUP BY call_timestamp 
ORDER BY daily_customers DESC;

--- Check reason why customers contacted call centers, 3 reason: Service Outage, Billing Question, Payments
SELECT DISTINCT reason FROM call_center

---- What is the distribution of these reasons
---- Billing Question = 23462, Payments = 4749, Service Outage = 4730
SELECT reason, COUNT(DISTINCT id) AS customer_count
FROM call_center AS reason_numbers
GROUP BY reason
ORDER BY customer_count DESC;


--- Check customer reachouts from the cities and states
---- How many cities from which did the customers reachout - 461 cities and 51 states
SELECT COUNT (DISTINCT city) FROM call_center
SELECT COUNT (DISTINCT state) FROM call_center

---- To view customer reachout distribution by city
---- Wshington had the highest number with 1110  
SELECT city, COUNT(DISTINCT id) AS city_count
FROM call_center AS city_numbers
GROUP BY city
ORDER BY city_count DESC;

---- To view customer reachout distribution by state
---- California had the highest number with 331
SELECT state, COUNT(DISTINCT id) AS state_count
FROM call_center AS state_numbers
GROUP BY state
ORDER BY state_count DESC;


--- Check channels used by customers- 4 channels used, Call-Center, Web, Email, Chatbot 
SELECT DISTINCT channel FROM call_center

---- View the numbers for each channel
---- Call-Center = 10639, Chatbot = 8256, Email = 7470, Web = 6576
SELECT channel, COUNT(DISTINCT id) AS channel_count
FROM call_center AS channel_numbers
GROUP BY channel
ORDER BY channel_count DESC;


--- Check Service Level Agreement (SLA) column, 3 levels- Below SLA, Above SLA, Within SLA
SELECT DISTINCT response_time FROM call_center

---- View the numbers for each response_time
----Within SLA = 20625, Below SLA = 8148, Above SLA = 4168
SELECT response_time, COUNT(DISTINCT id) AS response_time_count
FROM call_center AS response_time_numbers
GROUP BY response_time
ORDER BY response_time_count DESC;


--- Check the call_duration_minutes column
---- Check the avg call duration - 25 minutes
SELECT AVG (call_duration_minutes) FROM call_center

---- Check the minimum call duration - 5 minutes
SELECT MIN (call_duration_minutes) FROM call_center

---- Check the maximum call duration - 45 minutes
SELECT MAX (call_duration_minutes) FROM call_center


--- Check the call_center_city and state columns
---- 4 cities, Baltimore, Chicago, Denver, Los Angeles in 4 different states, MD, IL, CO, CA
SELECT DISTINCT call_center_city FROM call_center

SELECT DISTINCT call_center_state FROM call_center

---- Check the call center data distribution by city
---- Los Angeles = 13734, Baltimore = 11012, Chicago = 5419, Denver = 2776
SELECT call_center_city, COUNT(DISTINCT id) AS call_center_city_count
FROM call_center AS call_center_city_numbers
GROUP BY call_center_city
ORDER BY call_center_city_count DESC;



