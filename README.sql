-- SQL Retail Sales Analysis 
CREATE DATABASE ccdb;

-- Create TABLE
DROP TABLE IF EXISTS retails_sales;
CREATE TABLE retails_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(10),
                age	INT,
                category VARCHAR(50),	
                quantity	INT,
                price_per_unit INT,	
                cogs	NUMERIC,
                total_sale INT
            );


-- Data Cleaning


SELECT * FROM retails_sales
WHERE transactions_id IS NULL 
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	
DELETE FROM retails_sales
WHERE transactions_id IS NULL 
	OR
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	
-- Data Exploration

-- How many sales we have?
SELECT 
	COUNT(*) 
FROM retails_sales

-- How many Unique customer we have?
SELECT 
	COUNT(DISTINCT customer_id) as total_sales 
from retails_sales

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)










-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT 
	(*) 
FROM retails_sales
WHERE sale_date = '05-11-2022'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
SELECT 
	(*) 
FROM retails_sales
WHERE category = 'Clothing'
	AND 
	quantity >= 3
	AND
	TO_CHAR(sale_date, 'yyyy-mm') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) AS net_sales,
	COUNT(*) AS total_order 
FROM retails_sales
GROUP BY category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(AVG(age),2) AS avg_age 
FROM retails_sales
WHERE category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000. 
SELECT 
	(*) 
FROM retails_sales
WHERE total_sale > '1000'

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	category,
	gender,
	COUNT(transactions_id) AS transactions_id 
FROM retails_sales
GROUP BY category, gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	year,
	month,
	total_sale 
FROM (SELECT
	    EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		ROUND(AVG(total_sale),2) AS total_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY  ROUND(AVG(total_sale),2) DESC )
	 FROM retails_sales
	 GROUP BY 1,2) AS t1
ORDER BY 3 DESC LIMIT 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id, 
	SUM(total_sale) AS total_sale
FROM retails_sales
GROUP BY customer_id
ORDER BY total_sale DESC LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retails_sales
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with shifts as (SELECT *,
	CASE 
	   WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning' 
	   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	   ELSE 'Evening'
	   END AS shift
FROM retails_sales)

SELECT shift, 
COUNT(*) AS no_of_orders
FROM shifts
GROUP BY 1;

--END PROJECT THANK YOU
