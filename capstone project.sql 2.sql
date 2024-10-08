SELECT * FROM capstone_project.cryptopunkdata;
use capstone_project.cryptopunkdata;

1)How many sales occurred during this time period? 

SELECT COUNT(DISTINCT transaction_hash)
FROM capstone_project.cryptopunkdata;

2) Return the top 5 most expensive transactions (by USD price) for this data set. Return the name, ETH price, and USD price, as well as the date.
SELECT name, ETH_price, USD_price, day, transaction_hash
FROM capstone_project.cryptopunkdata
ORDER BY USD_price DESC
LIMIT 5;

3) Return a table with a row for each transaction with an event column, a USD price column, and a moving average of USD price that averages the last 50 transactions.
SELECT
    USD_price,
    AVG(USD_price) OVER (ORDER BY transaction_hash ROWS BETWEEN 49 PRECEDING AND CURRENT ROW) AS moving_avg
FROM
    capstone_project.cryptopunkdata;
    
  4)  Return all the NFT names and their average sale price in USD. Sort descending. Name the average column as average_price.
SELECT
    name,
    AVG(USD_price) AS average_price
FROM capstone_project.cryptopunkdata
GROUP BY name
ORDER BY average_price DESC; 

5) Return each day of the week and the number of sales that occurred on that day of the week, as well as the average price in ETH. Order by the count of transactions in ascending order.

SELECT
    ('Day') AS day_of_week,
    COUNT(*) AS sales_count,
    AVG(ETH_price) AS avg_ETH_price
FROM capstone_project.cryptopunkdata
GROUP BY day_of_week
ORDER BY sales_count ASC;

6) Construct a column that describes each sale and is called summary. The sentence should include who sold the NFT name, who bought the NFT, who sold the NFT, the date, and what price it was sold for in USD rounded to the nearest thousandth.

SELECT
    CONCAT(
        name, ' was sold for $',
        ROUND(USD_price, 3), ' to ', seller_address,
        ' from ', seller_address, ' on ',
        (day, 'YYYY-MM-DD')
    ) AS summary
FROM capstone_project.cryptopunkdata;


7) Create a view called “1919_purchases” and contains any sales where
CREATE VIEW 1919_purchases AS
SELECT *
FROM capstone_project.cryptopunkdata
WHERE seller_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';

8) Create a histogram of ETH price ranges. Round to the nearest hundred value. 

SELECT
    FLOOR(ETH_price / 100) * 100 AS eth_range,
    COUNT(*) AS frequency
FROM capstone_project.cryptopunkdata
GROUP BY eth_range
ORDER BY eth_range;  

9) Return a unioned query that contains the highest price each NFT was bought for and a new column called status saying “highest” with a query that has the lowest price each NFT was bought for and the status column saying “lowest”. The table should have a name column, a price column called price, and a status column. Order the result set by the name of the NFT, and the status, in ascending order. 
(
    SELECT name, MAX(USD_price) AS price, 'highest' AS status
    FROM capstone_project.cryptopunkdata
    GROUP BY name
)
UNION ALL
(
    SELECT name, MIN(USD_price) AS price, 'lowest' AS status
    FROM capstone_project2
    GROUP BY name
)
ORDER BY name, status ASC;

10) What NFT sold the most each month / year combination? Also, what was the name and the price in USD? Order in chronological format. 

SELECT
    (MONTH FROM day) AS month,
    (YEAR FROM day) AS year,
    name,
    MAX(USD_price) AS max_price
FROM capstone_project.cryptopunkdata
GROUP BY month, year
ORDER BY year, month;

11) Return the total volume (sum of all sales), round to the nearest hundred on a monthly basis (month/year).

SELECT
    (day) AS month_year,
    ROUND(SUM(USD_price), 2) AS total_volume
FROM capstone_project.cryptopunkdata
GROUP BY month_year
ORDER BY month_year;  

12) Count how many transactions the wallet "0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685"had over this time period.
SELECT COUNT(*) AS transaction_hash
FROM capstone_project.cryptopunkdata
WHERE seller_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685'; 

13 A) a) First create a query that will be used as a subquery. Select the event date, the USD price, and the average USD price for each day using a window function. Save it as a temporary table.
CREATE TEMPORARY TABLE daily_average_prices AS
SELECT
    event_date,
    USD_price,
    AVG(USD_price) OVER (PARTITION BY event_date) AS daily_average
FROM capstone_project.cryptopunkdata

    
13 b) Use the table you created in Part A to filter out rows where the USD prices is below 10% of the daily average and return a new estimated value which is just the daily average of the filtered data.


SELECT
    AVG(USD_price) AS estimated_average_value
FROM capstone_project.cryptopunkdata
WHERE USD_price >= 0.1 * daily_average;















