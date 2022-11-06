--Information for 3 tables - Store, Product, Sales, were provided.
--I started by creating a schema for the tables, creating the tables and inserting the values provided into them.

--Creating Schema

CREATE SCHEMA intqs

--Creating the Store table

CREATE TABLE intqs.Store (
store_id NUMERIC,
location CHAR(20) NULL,
 PRIMARY KEY (store_id)
)

-- Inserting Data into the Store table

INSERT INTO intqs.Store(store_id, location)
VALUES
(91110, 'New York'),
(99525, 'Los Angeles'),
(37340, 'Tokyo'),
(32016, 'Detroit'),
(57507, 'London');

--Creating the Product table

CREATE TABLE intqs.Product (
product_id NUMERIC,
product_name CHAR(15) NULL,
price_usd INTEGER NULL,
PRIMARY KEY (product_id)
)

-- Inserting Data into the Store table

INSERT INTO intqs.Product(product_id, product_name, price_usd)
VALUES
(31331, 'Apples', 2), 
(34611, 'Lettuce', 3), 
(49760, 'Chicken', 5), 
(26583, 'Lemons', 1), 
(20267, 'Bread', 2);

-- Creating the Sales table

CREATE TABLE intqs.Sales (			
sale_id INTEGER,
product_id NUMERIC NULL,
store_id NUMERIC NULL,
date DATE NULL
)

--Inserting data into the Sales table

INSERT INTO intqs.Sales(sale_id, product_id, store_id, date)
VALUES
(1, 31331, 91110, '02/20/2020'),
(1, 31331, 91110, '02/20/2020'),
(2, 34611, 57507, '02/20/2020'),
(3, 26583, 37340, '02/20/2020'),
(3, 34611, 32016, '02/20/2020'),
(3, 20267, 99525, '02/21/2020'),
(4, 31331, 99525, '02/21/2020'),
(5, 49760, 99525, '02/21/2020'),
(6, 34611, 57507, '02/21/2020'),
(7, 31331, 91110, '02/21/2020');

SELECT * FROM intqs.Store
SELECT * FROM intqs.Product
SELECT * FROM intqs.Sales

---------------------------------------------------------------------------------------
-- Answering the question.
--Using the tables above, write a SQL query to return total sales (in dollars) by store location by product. 
--If total sales are null for a given store location / product combination, set them to 0.


/*
My thought process

The tables that have related columns are:
-Store and Sales
-Product and Sales.
The task is to get total sales by store location by product.This means I need to get the Store and Product tables together to be able to pull the final information I need.
-As there is no related column between the Store and Product tables, I will use the Sales table to achieve the needed connection between these two tables.
-Í join the Product and Sales tables, and then join the Store table to the resulting table.
-This can also be done vice versa, i.e, join Store and Sales tables first, and join resulting table to Product.
-I will use a Left Join, followed by a Right Join in this task, to expose products and stores not recording sales, respectively.
-The question says to set sales for such location/ product combinations to zero(0)
-I will aggregate, using the SUM function to get the total sales, as that should be one of the columns in my final table.
-Ofcourse, once I am aggregating, I'll have to follow up with the 'GROUP BY' command, and I have to group by all columns in the final table, except the column that holds the result of the aggregation.
-My final table will have the following information
location, store_id, Product_id and total_sales.
*/

---------------------------------------------------------------------------------------------
--There are a number of ways to solve the task at hand
--We can use the concept of subqueries, Common Table Expressions(CTEs), temporary tables, 
--we could even create function(s) to acheive this, depending on the scenario and what we are driving at.

--I will use the Subquery and CTE concepts seperately, and then a combination of the two, for demonstation purposes.


--Using a Subquery

SELECT t.location, j.store_id, j.product_id, SUM(price_usd) AS total_sales
-- Selecting the columns we want our final table to display
FROM
-- Now we write the subquery, aliased as j- could be anything
-- Here, we are joining the Product and Sales tables
(SELECT s.store_id, p.product_id, p.price_usd 
FROM intqs.Product AS p
LEFT JOIN intqs.Sales AS s
ON p.product_id = s.product_id
) AS j
RIGHT JOIN intqs.Store AS t
ON t.store_id = j.store_id
GROUP BY
location, j.store_id, product_id
ORDER BY
total_sales DESC


-----------------------------------------------------------------------------
-- Using a CTE

WITH sales_loc AS
(SELECT s.store_id, p.product_id, p.price_usd 
FROM intqs.Product AS p
LEFT JOIN intqs.Sales AS s
ON p.product_id = s.product_id)

SELECT t.location, l.store_id, l.product_id, SUM(price_usd) AS total_sales
FROM sales_loc AS l
RIGHT JOIN intqs.Store AS t
ON t.store_id = l.store_id
GROUP BY
location, l.store_id, product_id
ORDER BY
total_sales DESC

--------------------------------------------------------------------
-- By Conbining Subquery and CTE
/*Here, I saved the entire combination of Joins and a subquery as a CTE 
i can further query the final table if need be.
Except that here, I am not allowed to use the order by command inside the CTE,
unless I specify anyone of commands like 'TOP', OFFSET; but I can use orderby in further querying the CTE*/

WITH sales_location AS
(SELECT t.location, j.store_id, j.product_id, SUM(price_usd) AS total_sales
-- Selecting the columns we want our final table to display
FROM
-- Now we write the subquery, aliased as j- could be anything
-- Here, we are joining the Product and Sales tables
(SELECT s.store_id, p.product_id, p.price_usd 
FROM intqs.Product AS p
LEFT JOIN intqs.Sales AS s
ON p.product_id = s.product_id
) AS j
RIGHT JOIN intqs.Store AS t
ON t.store_id = j.store_id
GROUP BY
location, j.store_id, product_id)

SELECT *
FROM sales_location
ORDER BY
total_sales DESC;