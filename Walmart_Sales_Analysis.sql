-- Walmart Sales Analysis with SQL - Business Insights Case Study
-- Create the Table
CREATE TABLE walmart_sales(
	User_ID INT,
	Product_ID VARCHAR(10),
	Gender CHAR(1),
	Age VARCHAR(10),
	Occupation SMALLINT,
	City_Category VARCHAR(10),
	Stay_In_Current_City_Years VARCHAR(10),
	Marital_Status SMALLINT,
	Product_Category INT,
	Purchase NUMERIC (10,2)
)

-- Data Exploration and cleaning
-- Checking for NULL values
SELECT * FROM walmart_sales
WHERE
	user_id IS NULL
	OR product_id IS NULL
	OR gender IS NULL
	OR age IS NULL
	OR occupation IS NULL
	OR city_category IS NULL
	OR stay_in_current_city_years IS NULL
	OR marital_status IS NULL
	OR product_category IS NULL
	OR purchase IS NULL

-- Customer Insights
-- 1. Who are the top 10 customers by total purchase value (Customer Lifetime Value)?
SELECT user_id, SUM(purchase) AS total_spent
FROM walmart_sales
GROUP BY user_id
ORDER BY total_spent DESC
LIMIT 10;

-- 2. Do male or female customers spend more on average?
SELECT gender, ROUND(AVG(purchase),2) AS avg_purchase, SUM(purchase) AS total_spent
FROM walmart_sales
GROUP BY gender;

-- 3. Which age group contributes the most revenue?
SELECT age, SUM(purchase) AS total_revenue
FROM walmart_sales
GROUP BY age
ORDER BY total_revenue DESC;

-- 4. Does marital status impact spending patterns?
SELECT marital_status, ROUND(AVG(purchase),2) AS avg_purchase, SUM(purchase) AS total_spent
FROM walmart_sales
GROUP BY marital_status;

-- 5. Which city category drives the highest sales?
SELECT city_category, SUM(purchase) AS total_revenue, ROUND(AVG(purchase),2) AS avg_purchase
FROM walmart_sales
GROUP BY city_category
ORDER BY total_revenue DESC;

-- Product Performance
-- 1. Which products generate the highest revenue overall?
SELECT product_id, SUM(purchase) AS total_revenue
FROM walmart_sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;

-- 2. Which product categories are most popular by sales volume?
SELECT product_category, COUNT(*) AS units_sold, SUM(purchase) AS revenue
FROM walmart_sales
GROUP BY product_category
ORDER BY units_sold DESC;

--3. What are the low-performing products that bring in little revenue?
SELECT product_id, SUM(purchase) AS total_revenue
FROM walmart_sales
GROUP BY product_id
HAVING SUM(purchase) < 1000
ORDER BY total_revenue ASC
LIMIT 10;

-- 4. What are the top 5 products bought by each age group?
SELECT * FROM (
  SELECT age, product_id, SUM(purchase) AS revenue,
         RANK() OVER (PARTITION BY age ORDER BY SUM(purchase) DESC) AS rnk
  FROM walmart_sales
  GROUP BY age, product_id
) sub
WHERE rnk <= 5;

-- 5. Which product categories are more popular among men vs. women?
SELECT gender, product_category, SUM(purchase) AS revenue
FROM walmart_sales
GROUP BY gender, product_category
ORDER BY gender, revenue DESC;

-- Sales & Revenue Trends
-- 1. What is the average purchase amount per transaction?
SELECT ROUND(AVG(purchase),2) AS avg_purchase
FROM walmart_sales;


-- 2. What is the distribution of purchase values?
SELECT width_bucket(purchase, 0, 20000, 10) AS bucket, COUNT(*) AS transactions
FROM walmart_sales
GROUP BY bucket
ORDER BY bucket;

-- 3. Which occupation group spends the most?
SELECT occupation, SUM(purchase) AS total_revenue, ROUND(AVG(purchase),2) AS avg_purchase
FROM walmart_sales
GROUP BY occupation
ORDER BY total_revenue DESC;

-- 4. Is there correlation between stay in city and spending?
SELECT stay_in_current_city_years, SUM(purchase) AS total_revenue, ROUND(AVG(purchase),2) AS avg_purchase
FROM walmart_sales
GROUP BY stay_in_current_city_years
ORDER BY total_revenue DESC;

-- 5. Which combination of city + age group brings maximum revenue?
SELECT city_category, age, SUM(purchase) AS total_revenue
FROM walmart_sales
GROUP BY city_category, age
ORDER BY total_revenue DESC
LIMIT 5;

-- Customer Segmentation
-- 1. Classify customers into High-Value, Medium-Value, and Low-Value segments based on their total purchase amount.
SELECT 
       user_id,
       SUM(purchase) AS total_spent,
       CASE
         WHEN SUM(purchase) >= 15000 THEN 'High-Value'
         WHEN SUM(purchase) BETWEEN 5000 AND 14999 THEN 'Medium-Value'
         ELSE 'Low-Value'
       END AS customer_segment
FROM walmart_sales
GROUP BY user_id
ORDER BY total_spent DESC;

-- 2. Which occupation + city category groups represent biggest customers?
SELECT occupation, city_category, SUM(purchase) AS revenue
FROM walmart_sales
GROUP BY occupation, city_category
ORDER BY revenue DESC
LIMIT 10;

-- 3. Who are top repeat buyers (most transactions)?
SELECT user_id, COUNT(*) AS num_transactions, SUM(purchase) AS total_spent
FROM walmart_sales
GROUP BY user_id
ORDER BY num_transactions DESC
LIMIT 10;

-- 4. Average revenue per customer by demographics
SELECT gender, age, marital_status,
       ROUND(AVG(purchase),2) AS avg_txn_value,
       ROUND(SUM(purchase)/COUNT(DISTINCT user_id),2) AS avg_revenue_per_customer
FROM walmart_sales
GROUP BY gender, age, marital_status;


-- 5. Which demographic groups are underserved (low spending vs size)?
SELECT age, gender, COUNT(DISTINCT user_id) AS customers, SUM(purchase) AS total_spent,
       ROUND(SUM(purchase)::numeric / COUNT(DISTINCT user_id),2) AS revenue_per_customer
FROM walmart_sales
GROUP BY age, gender
ORDER BY revenue_per_customer ASC;
