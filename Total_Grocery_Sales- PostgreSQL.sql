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
/*
Notice that for postgreSQL, I had to replace the forward slashes in the date values with hyphens.
and even re-arrange to postgreSQL's standard date format, 'yyyy-mm-dd'. 
Anther option would have been to still re-arrange, but do away with the separators, then call the 'TO_DATE' function and specify the format, 'yyyy-mm-dd')
I also noticed that PostgreSQL does not infer dates like MSSQL Servr will do. You have to pass a date value arranged exactly as 'yyyy-mm-dd', 
or, if you are going to use the TO_DATE function, 'yyyymmdd'

*/
(1, 31331, 91110, '2020-02-20'),
(1, 31331, 91110, '2020-02-20'),
(2, 34611, 57507, '2020-02-20'),
(3, 26583, 37340, '2020-02-20'),
(3, 34611, 32016, '2020-02-20'),
(3, 20267, 99525, '2020-02-21'),
(4, 31331, 99525, '2020-02-21'),
(5, 49760, 99525, '2020-02-21'),
(6, 34611, 57507, '2020-02-21'),
(7, 31331, 91110, '2020-02-21');

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
-- By Combining Subquery and CTE
/*
Here, I saved the entire combination of joins and a subquery as a CTE.
Notice a difference here? In MSSQL, I am not allowed to use the ORDER BY command in CTEs, views, for example. 
But PostgreSQL allows that. 
*/

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
location, j.store_id, product_id
ORDER BY
total_sales DESC)

SELECT *
FROM sales_location;


--In conclusion, from any of the query statements we have seen so far, we can even create a view of our final table.
--Note that you do not need to make a view out of every query you write, especially when the queries are towards achieving the same task, as it is in this case.
--Here, you will find that I used the second query statement to create a view. I used the first and third in the MSSQL and BigQuery files respectively. 

-- Creating a view of our final table Using the 'CTE only' query statement

CREATE VIEW intqs.sales_loc_view AS
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


--Thank you!