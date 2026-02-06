SELECT * FROM sales_data;

-- Exploratory Data Analysis
-- How many sales data this dataset has ??
select count(*) as num_sales from sales_data;

-- How many customers does this data has ?
select count(distinct customer_id) from sales_data;

-- How many categories the data has ?
select count(distinct category) from sales_data;

-- what is the total revenue ??
select sum(total_sale) as Total_Revenue from sales_data;

-- what is the total profit ??
select (sum(total_sale) - sum(cogs)) as Profit from sales_data;


-- CTE function... -- what is the profit percentage ?
with profit_cal as (
	select 
		(sum(total_sale) - sum(cogs)) as Profit
	from
		sales_data
	)

select (((select * from profit_cal)/sum(cogs)) * 100) as Profit_per from sales_data;




-- Data Analysis

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05' ?

select * from sales_data
where sale_date = '2022-11-05';


-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022 ?

select * from sales_data
where category = 'Clothing' and quantity >= 4 and sale_date like '2022-11%';

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category ??

select 
	category,
    count(category) as total_orders,
	sum(total_sale) as total_sales 
from sales_data
group by category;


-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category ?

select 
	category,
	avg(age) as avg_age
from
	sales_data
where category = 'Beauty';


-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000 ??

select * from sales_data
where total_sale > 1000;


-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category ?

select
    category,
    gender,
    count(transactions_id) as total_transactions
from
	sales_data
group by
	category,
    gender;
    
    
-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year ?

with monthly_sales as (
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
	from monthly_sales
    where sales_rank = 1;
    
    
-- 8. Write a SQL query to find the top 5 customers based on the highest total sales ?

select
	customer_id,
    sum(total_sale) as total_sales
from
	sales_data
group by 
	customer_id
order by 
	total_sales desc
limit 5;


-- 9. Write a SQL query to find the number of unique customers who purchased items from each category ?

select
	category,
    count(distinct customer_id) as unique_customers
from
	sales_data
group by
	category;
    
    
-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17) ?

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
    
    
