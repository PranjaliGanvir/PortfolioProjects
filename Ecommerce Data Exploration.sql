/* Ecommerce Data Exploration */

use ecommerce_data;

-- Lets take a look at the Tables
show tables;

# check for duplicates 

-- table 1(list_Of_orders)

select order_id,order_date,customer_name,state,city,count(*) as no_of_rows
from list_of_orders
group by order_id,order_date,customer_name,state,city
having count(*) > 1
order by order_id;

-- no duplicates found in table 1


-- table 2(order_details)

select order_id,amount,profit,quantity,category,sub_category, count(*) as no_of_rows
from order_details
group by order_id,amount,profit,quantity,category,sub_category
having count(*) > 1
order by order_id;

-- no duplicates found in table 2


-- table 3(sales_target)

select order_date_month,category,target,count(*) as no_of_rows
from sales_target
group by order_date_month,category,target
having count(*) > 1
order by order_date_month;

-- no duplicates found in table 3


#check for null values

-- Table 1(list_of_orders)

select *
from list_of_orders
where not(order_id is null or order_date is null or customer_name is null or state is null
is not null);

-- no null values present.


-- Table 2(order_details)

select *
from order_details
where not(order_id is null or amount is null or profit is null or quantity is null or category is null or sub_category is null
is not null);

-- no null values present.


-- Table 3(sales_target)

select *
from sales_target
where not(order_date_month is null or category is null or target is null
is not null);

-- no null values present.


# Analysis

-- Top 5 customers with most no of orders
select lo.customer_name,od.order_id,count(od.order_id) as no_of_purchases
from order_details od
join list_of_orders lo on od.order_id = lo.order_id
group by od.order_id,lo.customer_name
order by no_of_purchases desc
limit 5 ;

-- Top 5 customers with high purchase value
select lo.customer_name,od.order_id,sum(od.amount*od.quantity) as amount_spent,count(od.order_id) as no_of_purchases
from order_details od
join list_of_orders lo on od.order_id = lo.order_id
group by od.order_id,lo.customer_name
order by amount_spent desc 
limit 5;

-- Top 5 states with most no of orders
select count(od.order_id) as no_of_purchases,lo.state
from order_details od
join list_of_orders lo on od.order_id=lo.order_id
group by lo.state
order by no_of_purchases desc
limit 5;

-- Top 5 states with high purchase value
select od.order_id,sum(od.amount*od.quantity) as amount_spent,lo.state
from order_details od
join list_of_orders lo on od.order_id = lo.order_id
group by order_id,lo.state
order by amount_spent desc ;

-- category with highest sales
select category,sum(amount*quantity) as amount_spent
from order_details
group by category
order by amount_spent desc;

-- total profit for each category
select category,sum(profit) as total_profit
from order_details
group by category;

-- no of products bought in each category 
select count(category),category
from order_details
group by category;

-- top 3 best-selling products in clothing category
select count(sub_category) as no_of_purchases,sub_category
from order_details
where category='clothing'
group by sub_category
order by no_of_purchases desc
limit 3;

-- top 3 best-selling products in electronics category
select count(sub_category) as no_of_purchases,sub_category
from order_details
where category='electronics'
group by sub_category
order by no_of_purchases desc
limit 3;

-- top 3 best-selling products in furniture category
select count(sub_category) as no_of_purchases,sub_category
from order_details
where category='furniture'
group by sub_category
order by no_of_purchases desc
limit 3;

-- top 3 products with high purchase value in clothing category
select sub_category,sum(amount*quantity) as revenue
from order_details
where category = 'clothing'
group by sub_category
order by revenue desc
limit 3;

-- top 3 products with high purchase value in electronics category
select sub_category,sum(amount*quantity) as revenue
from order_details
where category = 'electronics'
group by sub_category
order by revenue desc
limit 3;

-- top 3 products with high purchase value in furniture category
select sub_category,sum(amount*quantity) as revenue
from order_details
where category = 'furniture'
group by sub_category
order by revenue desc
limit 3;

-- price distribution of products in each category
-- tells which category products were high priced and low priced
select price_range,category,count(category) as no_of_products
from (select case when amount > 288 then 'high price 3'
	 when amount between 288 and 118 then 'moderate price 2'
     else 'low price 1'
     end as price_range,
     category
from order_details 
order by price_range) as a
group by price_range,category
order by price_range;