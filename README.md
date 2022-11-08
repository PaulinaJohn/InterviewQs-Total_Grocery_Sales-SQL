Description

Another newsletter from [InterviewQs](https://www.interviewqs.com/). On this occasion, I was tasked to query 3 tables for total sales by location by product. I solved this problem using 3 different RDBMS (Relational database management system)s.

* [MSSQL](https://github.com/PaulinaJohn/Total_grocery_sales-SQL-InterviewQs/blob/main/interviewQS-answer.sql)
* [PostgreSQL](https://github.com/PaulinaJohn/InterviewQs-Total_Grocery_Sales-SQL/blob/main/Total_Grocery_Sales-%20PostgreSQL.sql)
* BigQuery

Different RDBMSs show differences in SQL dialects.

* In MSSQL Server, you will use the Transact-SQL (T-SQL) dialect.
* PostgreSQL offers PL/pgSQL (PL- Procedural language), and;
* In BigQuery, You will come across Standard SQL.

Technology and dialect-wise, I encountered these differences across these RDBMs:
* BigQuery is case-sensitive with table names. Postgresql and MSSQL Server are not.
* You cannot use the ORDER BY command in common table expressions (CTEs), views, amongst others, in MSSQL but, this can be done in PostgreSQL and BigQuery.
* Although I only mentioned it as an alternative in the data insertion part of my PostgeSQL file and didn't have to use it, the TO_DATE function only works with PostgreSQL. The other two have their alternative(s) to the function, if and when necessary.

** What PostgreSQL and MSSQL considers 'Schema', appears to be considered 'Datasets' in BigQuery. BigQuery looks to assign the 'Schema' nomenclature to table column description.
