# Walmart-Sales-Analysis-with-SQL-Business-Insights-Case-Study
# Project Overview
This project analyzes Walmart sales data using SQL to uncover meaningful business insights. The analysis focuses on key areas such as customer behavior, product performance, sales trends, segmentation, and cross-selling opportunities. The project demonstrates how SQL can be leveraged not just for querying data but also for answering business-critical questions that drive decision-making.
# Objectives
- To perform data-driven business analysis on Walmart sales data using SQL.
- To explore customer insights and purchasing patterns.
- To evaluate product performance across different categories.
- To analyze sales and revenue trends over time.
- To conduct customer segmentation based on behavior and demographics.
# Project Structure
The project is divided into the following sections:
1. Database Setup:
```sql
CREATE DATABASE walmart_sales_db;

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
```
3. Data Exploration & Cleaning
```sql
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
```
5. Data Analysis & Findings:
   
   1. Customer Insights
      
      Q1. Who are the top 10 customers by total purchase value (Customer Lifetime Value)?
       ```sql
      SELECT user_id, SUM(purchase) AS total_spent
      FROM walmart_sales
      GROUP BY user_id
      ORDER BY total_spent DESC
      LIMIT 10;
       ```
       Q2. Do male or female customers spend more on average?
      ```sql
      SELECT gender, ROUND(AVG(purchase),2) AS avg_purchase, SUM(purchase) AS total_spent
      FROM walmart_sales
      GROUP BY gender;
      ```
      Q3. Which age group contributes the most revenue?
      ```sql
      SELECT age, SUM(purchase) AS total_revenue
      FROM walmart_sales
      GROUP BY age
      ORDER BY total_revenue DESC;
      ```
      Q4. Does marital status impact spending patterns?
      ```sql
      SELECT marital_status, ROUND(AVG(purchase),2) AS avg_purchase, SUM(purchase) AS total_spent
      FROM walmart_sales
      GROUP BY marital_status;
      ```
      Q5. Which city category drives the highest sales?
      ```sql
      SELECT city_category, SUM(purchase) AS total_revenue, ROUND(AVG(purchase),2) AS avg_purchase
      FROM walmart_sales
      GROUP BY city_category
      ORDER BY total_revenue DESC;
      ```
   2. Product Performance:
      
      Q1. Which products generate the highest revenue overall?
      ```sql
      SELECT product_id, SUM(purchase) AS total_revenue
      FROM walmart_sales
      GROUP BY product_id
      ORDER BY total_revenue DESC
      LIMIT 10;
      ```
      Q2. Which product categories are most popular by sales volume?
      ```sql
      SELECT product_category, COUNT(*) AS units_sold, SUM(purchase) AS revenue
      FROM walmart_sales
      GROUP BY product_category
      ORDER BY units_sold DESC;
      ```
      Q3. What are the low-performing products that bring in little revenue?
      ```sql
      SELECT product_id, SUM(purchase) AS total_revenue
      FROM walmart_sales
      GROUP BY product_id
      HAVING SUM(purchase) < 1000
      ORDER BY total_revenue ASC
      LIMIT 10;
      ```
      Q4. What are the top 5 products bought by each age group?
      ```sql
      SELECT * FROM (
        SELECT age, product_id, SUM(purchase) AS revenue,
              RANK() OVER (PARTITION BY age ORDER BY SUM(purchase) DESC) AS rnk
        FROM walmart_sales
        GROUP BY age, product_id
      ) sub
      WHERE rnk <= 5;
      ```
    Q5. Which product categories are more popular among men vs. women?
   ```sql
   SELECT gender, product_category, SUM(purchase) AS revenue
    FROM walmart_sales
    GROUP BY gender, product_category
    ORDER BY gender, revenue DESC;
   ```
   3. Sales & Revenue Trends
      
      Q1. What is the average purchase amount per transaction?
      ```sql
      SELECT ROUND(AVG(purchase),2) AS avg_purchase
      FROM walmart_sales;
      ```
      Q2. What is the distribution of purchase values?
      ```sql
      SELECT width_bucket(purchase, 0, 20000, 10) AS bucket, COUNT(*) AS transactions
      FROM walmart_sales
      GROUP BY bucket
      ORDER BY bucket;
      ```
      Q3. Which occupation group spends the most?
      ```sql
      SELECT occupation, SUM(purchase) AS total_revenue, ROUND(AVG(purchase),2) AS avg_purchase
      FROM walmart_sales
      GROUP BY occupation
      ORDER BY total_revenue DESC;
      ```
      Q4. Is there correlation between stay in city and spending?
      ```sql
      SELECT stay_in_current_city_years, SUM(purchase) AS total_revenue, ROUND(AVG(purchase),2) AS avg_purchase
      FROM walmart_sales
      GROUP BY stay_in_current_city_years
      ORDER BY total_revenue DESC;
      ```
      Q5. Which combination of city + age group brings maximum revenue?
      ```sql
      SELECT city_category, age, SUM(purchase) AS total_revenue
      FROM walmart_sales
      GROUP BY city_category, age
      ORDER BY total_revenue DESC
      LIMIT 5;
      ```
   4. Customer Segmentation

      Q1. Classify customers into High-Value, Medium-Value, and Low-Value segments based on their total purchase amount.
      ```sql
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
      ```
      Q2. Which occupation + city category groups represent biggest customers?
      ```sql
      SELECT occupation, city_category, SUM(purchase) AS revenue
      FROM walmart_sales
      GROUP BY occupation, city_category
      ORDER BY revenue DESC
      LIMIT 10;
      ```
      Q3. Who are top repeat buyers (most transactions)?
      ```sql
      SELECT user_id, COUNT(*) AS num_transactions, SUM(purchase) AS total_spent
      FROM walmart_sales
      GROUP BY user_id
      ORDER BY num_transactions DESC
      LIMIT 10;
      ```
      Q4. Average revenue per customer by demographics
      ```sql
      SELECT gender, age, marital_status,
         ROUND(AVG(purchase),2) AS avg_txn_value,
         ROUND(SUM(purchase)/COUNT(DISTINCT user_id),2) AS avg_revenue_per_customer
      FROM walmart_sales
      GROUP BY gender, age, marital_status;
      ```
      Q5. Which demographic groups are underserved (low spending vs size)?
      ```sql
      SELECT age, gender, COUNT(DISTINCT user_id) AS customers, SUM(purchase) AS total_spent,
         ROUND(SUM(purchase)::numeric / COUNT(DISTINCT user_id),2) AS revenue_per_customer
      FROM walmart_sales
      GROUP BY age, gender
      ORDER BY revenue_per_customer ASC;
      ```
# Findings:
- Customer Demographics:
  Customers come from diverse age groups. The 26–35 segment drives the most revenue, while 18–25 and 36–45 also make strong contributions. Gender analysis shows men dominate spending overall, though women prefer CERTAIN categories.
- High-Value Transactions:
  Multiple customers had purchases exceeding $100,000+, with the top customers classified as High-Value (≥$15,000 total spend). These individuals account for a significant share of sales, indicating premium shopping behavior.
- Sales Trends:
  Average transaction values range around $9,000–10,000. Revenue contributions vary by occupation group (with Occupation 4, 0, and 7 leading). Customers with longer city residency tend to spend more, highlighting loyalty-driven revenue.
- Customer Insights:
  The top customers contribute disproportionately to total sales. Product Category 1 generates the highest revenue across both men and women. Men favor Categories 1, 5, 8, while women lean toward 1, 8, 5.
- Customer Segmentation:
  - High-Value Customers: Small group, very high spend → ideal for loyalty and retention.
  - Medium-Value Customers: Broad base → opportunities for upselling.
  - Low-Value Customers: Large count, low contribution → promotions could increase basket size.
# Reports
1. Sales Summary:
   - Total sales broken down by age, gender, marital status, and city category.
   - Category performance highlighting top categories and low-performing products.
2. Trend Analysis:
   - Revenue analysis across occupations, stay-in-city groups, and transaction values.
   - Insights into average purchase sizes and high-value customer behavior.
3. Customer Insights:
   - Identification of top-spending customers.
   - Segmentation into High, Medium, Low Value groups.
   - Demographic analysis of underserved groups
# Conclusion
This SQL project provides a comprehensive retail sales analysis for Walmart data. It covers database setup, data cleaning, exploratory analysis, and business-driven SQL queries that deliver actionable insights. Overall, this project demonstrates how SQL empowers analysts to uncover customer behavior, sales patterns, and product performance, providing a strong foundation for data-driven decision-making in retail.
    
