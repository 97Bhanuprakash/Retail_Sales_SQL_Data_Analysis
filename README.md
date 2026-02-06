# Retail_Sales_SQL_Data_Analysis
End-to-end Sales Data Analysis using MySQL to identify seasonality trends, customer behavior, and monthly performance metrics.


## Project Overview

This repository is where I put my SQL skills to work on a large-scale retail dataset. My goal was simple move past theory and apply a systematic approach to auditing and analyzing sales data. From handling data engineering tasks to performing complex exploratory analysis (EDA), I used MySQL’s full toolkit—aggregates, window functions, and solved few business questions.

Database: MySQL 8.0
Tools: MySQL Workbench
Skills: Data Cleaning, CTEs, Window Functions, Joins, Aggregations.

## Objectives
**Data Source**: Sourced from Zero Analyst Github Repository.
**Data Cleaning**: Identified and removed or rearranged the null or missing values. The data cleaning process is done using excel.
**Exploratory Data Analysis**: Analyzed and Solved few KPIs and to understand the dataset performed few basic queries.
**Business Analysis**: Solved few of the business questions to understand 'why' it is to be done rather than 'how' it is done.
**Complex Logic**: CTEs and Window Functions such as RANK(), these typical functions were formulated to ease the solution.


## Business Questions
* Write a SQL query to retrieve all columns for sales made on '2022-11-05' ?
* Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022 ?
* Write a SQL query to calculate the total sales (total_sale) for each category ?
* Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category ?
* Write a SQL query to find all transactions where the total_sale is greater than 1000 ?
* Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category ?
* Write a SQL query to calculate the average sale for each month. Find out best selling month in each year ?
* Write a SQL query to find the top 5 customers based on the highest total sales ?
* Write a SQL query to find the number of unique customers who purchased items from each category ?
* Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) ?
 

## Complex Queries
-- CTE function... 
* 1. what is the profit percentage ?

```sql
  with profit_cal as
      (
      select 
		    (sum(total_sale) - sum(cogs)) as Profit
	    from
		    sales_data
	    )
      select
        (((select * from profit_cal)/sum(cogs)) * 100) as Profit_per
      from
        sales_data;
```
## Result
<img width="113" height="51" alt="image" src="https://github.com/user-attachments/assets/4b86c127-dcc4-47c0-8ddd-5642db2696ad" />


* 2. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year ?

```sql
  with monthly_sales as 
    (
	  select
		  year(sale_date) as year,
		  month(sale_date) as month,
		  avg(total_sale) as avg_sales,
      rank() over (partition by year(sale_date) order by avg(total_sale) desc) as sales_rank
	  from
		  sales_data
	  group by 
		  year,
      month
	  )
    select
		  year,
      month,
      avg_sales
	  from
      monthly_sales
    where
      sales_rank = 1;
```
## Result
<img width="222" height="66" alt="image" src="https://github.com/user-attachments/assets/3d009321-39f9-4c75-8ea9-b40d54047411" />


* 3. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) ?

```sql
  with shift_sales as
	  (
    select
		  *,
      case
			  when hour(sale_time) < 12 then 'Morning'
        when hour(sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
		  end as shift_time
	  from
		  sales_data
	  )
    select
	    shift_time,
      count(*) as total_orders
    from
	    shift_sales
    group by
	    shift_time;
```
## Result
<img width="213" height="96" alt="image" src="https://github.com/user-attachments/assets/f9613dc7-fb87-473b-a714-7979cee36c54" />


## Key Insights
**Peak Performance:** July 2022 and February 2023 are the top performing sales respective to their years.
**Customer Demographics:** The 'Electronics' category has the highest total sales with value 313810.
**Sales Timing:** Most transactions occur during the 'Evening' shift, suggesting a need for more support staff during those hours.
