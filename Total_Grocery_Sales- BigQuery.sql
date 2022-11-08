/*
Information for 3 tables - Store, Product, Sales, were provided. 
Note: My BigQuery account is only Sandbox. Hence, I am not allowed to use nearly all DDL and DML languages in here; only Query language. 
So, I could not create Schema or the tables using query statements like I did in MSSQL server and PostgreSQL. 
I had to download the datasets from one these two- PostgreSQL, precisely- as csv files, and import them here as tables in 'a point-and-click approach'. 
So, I'll just go straight to answering the question.
*/


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
FROM InterviewQs.Product AS p
LEFT JOIN InterviewQs.Sales AS s
ON p.product_id = s.product_id
) AS j
RIGHT JOIN InterviewQs.Store AS t
ON t.store_id = j.store_id
GROUP BY
location, j.store_id, product_id
ORDER BY
total_sales DESC


-----------------------------------------------------------------------------
-- Using a CTE

WITH sales_loc AS
(SELECT s.store_id, p.product_id, p.price_usd 
FROM InterviewQs.Product AS p
LEFT JOIN InterviewQs.Sales AS s
ON p.product_id = s.product_id)

SELECT t.location, l.store_id, l.product_id, SUM(price_usd) AS total_sales
FROM sales_loc AS l
RIGHT JOIN InterviewQs.Store AS t
ON t.store_id = l.store_id
GROUP BY
location, l.store_id, product_id
ORDER BY
total_sales DESC;

--------------------------------------------------------------------
-- By Combining Subquery and CTE
/*
Here, I saved the entire combination of joins and a subquery as a CTE.
Notice a difference here? In MSSQL, I am not allowed to use the ORDER BY command in CTEs, views, for example. 
But BigQuery allows that. 
*/


WITH sales_location AS
(SELECT t.location, j.store_id, j.product_id, SUM(price_usd) AS total_sales
-- Selecting the columns we want our final table to display
FROM
-- Now we write the subquery, aliased as j- could be anything
-- Here, we are joining the Product and Sales tables
(SELECT s.store_id, p.product_id, p.price_usd 
FROM InterviewQs.Product AS p
LEFT JOIN InterviewQs.Sales AS s
ON p.product_id = s.product_id
) AS j
RIGHT JOIN InterviewQs.Store AS t
ON t.store_id = j.store_id
GROUP BY
location, j.store_id, product_id
ORDER BY
total_sales DESC)

SELECT *
FROM sales_location;



--In conclusion, from any of the query statements we have seen so far, we can even create a view of our final table.
--Note that you do not need to make a view out of every query you write, especially when the queries are towards achieving the
-- Here, you will find that I used the third query statement to create the view. I used the first and second in the MSSQL Server and PostgreSQL files respectively. 

-- Creating a view of our final table Using the combined 'subquery and CTE' statement

CREATE VIEW InterviewQs.sales_loc_view AS
WITH sales_location AS
(SELECT t.location, j.store_id, j.product_id, SUM(price_usd) AS total_sales
-- Selecting the columns we want our final table to display
FROM
-- Now we write the subquery, aliased as j- could be anything
-- Here, we are joining the Product and Sales tables
(SELECT s.store_id, p.product_id, p.price_usd 
FROM InterviewQs.Product AS p
LEFT JOIN InterviewQs.Sales AS s
ON p.product_id = s.product_id
) AS j
RIGHT JOIN InterviewQs.Store AS t
ON t.store_id = j.store_id
GROUP BY
location, j.store_id, product_id
ORDER BY
total_sales DESC)

SELECT *
FROM sales_location;


--Thank you!
