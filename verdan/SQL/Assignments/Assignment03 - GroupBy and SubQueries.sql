-- ============================================================
--   ASSIGNMENT 03 — GROUP BY, HAVING & SUBQUERIES
--   Database  : BikeStores
--   Topics    : GROUP BY · Aggregate Functions · HAVING
--               Subqueries · JOINs with GROUP BY
-- ============================================================


-- ============================================================
--  SECTION A — GROUP BY & AGGREGATE FUNCTIONS
-- ============================================================

-- Q1.
-- Count the total number of orders placed by each customer.
-- Show customer_id and order_count.
-- Sort by order_count descending.


select
	c.customer_id,
	count(o.order_id) AS orders_count
from sales.customers AS c
inner join sales.orders AS o
ON c.customer_id = o.customer_id
group by
	c.customer_id
order by 
	orders_count desc;


-- Q2.
-- For each store, find the total number of orders placed.
-- Show store_id and total_orders.
select
    s.store_id,
    count(o.order_id) AS total_orders
from production.stores AS s
inner join sales.orders AS o
ON s.store_id = o.store_id
group by
    s.store_id


-- Q3.
-- Calculate the net revenue per order.
-- Net revenue formula: SUM( quantity * list_price * (1 - discount) )
-- Show order_id and net_revenue, sorted by net_revenue descending.
-- (Hint: use sales.order_items)

SELECT
	order_id,
	sum((quantity * list_price) * (1 - discount)) as total_order_value
from sales.order_items oi
group by
	order_id
order by
	total_order_value desc;


-- Q4.
-- Find the average list price of products in each category.
-- Show category_id and avg_price (rounded to 2 decimal places).
-- (Hint: use ROUND())

select
	category_id,
	ROUND(avg(list_price), 2) AS avg_price
from production.products 
group by	
	category_id;



-- Q5.
-- Find the total number of orders placed in each year.
-- Show order_year and total_orders, sorted by order_year.
-- (Hint: use YEAR(order_date))

SELECT
    YEAR(order_date) AS order_year,
    COUNT(order_id) AS total_orders
FROM sales.orders
GROUP BY
    YEAR(order_date)
ORDER BY
    order_year;


-- ============================================================
--  SECTION B — HAVING CLAUSE
-- ============================================================

-- Q6.
-- Find customers who have placed MORE than 5 orders in total.
-- Show customer_id and order_count.


select
	c.customer_id,
	COUNT(o.order_id) as order_count
from sales.customers AS c
inner join sales.orders AS o
on c.customer_id = o.customer_id
group by
	c.customer_id
having COUNT(o.order_id) > 5;




-- Q7.
-- Find categories where the AVERAGE list price is greater than $1,500.
-- Show category_id and avg_price.


select
	category_id,
	avg(list_price)
from production.products
group by 
	category_id
having AVG(list_price) > 1500;


-- Q8.
-- Find customers who placed at least 2 orders in the year 2017.
-- Show customer_id, order_year, and order_count.

select
	c.customer_id,
	YEAR(o.order_date) AS order_year,
	COUNT(o.order_id) order_count
from sales.customers AS c
inner join sales.orders AS o
ON c.customer_id = o.customer_id
group by 
	YEAR(o.order_date),
	c.customer_id
having 
	COUNT(o.order_id) >= 2
	and YEAR(o.order_date)  = '2017'


-- ============================================================
--  SECTION C — SUBQUERIES
-- ============================================================

-- Q9.
-- Find all orders placed by customers who live in 'Houston'.
-- Use a subquery to get the customer_ids first.
-- Show all columns from sales.orders.

select
	*
from sales.orders
where customer_id IN (
	select
		customer_id
	from sales.customers
	where city = 'Houston'
)


-- Q10.
-- Find all products whose list_price is greater than the
-- AVERAGE list_price of ALL products.
-- Show product_name and list_price.


SELECT
	product_name,
	list_price
FROM production.products 
WHERE list_price > (
	SELECT
		AVG(list_price) AS avg_list_price
	FROM production.products
)



-- Q11.
-- Find all products that belong to the category 'Mountain Bikes'
-- or 'Road Bikes'. Use a subquery on production.categories.
-- Show product_name and list_price.

select
	product_name, list_price
from production.products
where category_id IN (
	select
		category_id
	from production.categories
	where category_name in ('Mountain Bikes', 'Road Bikes')
);



-- Q12.
-- Find all customers who have NEVER placed an order.
-- Show customer_id, first_name, and last_name.
-- (Hint: use NOT IN with a subquery on sales.orders)


select
	customer_id, 
	first_name,
	last_name
from sales.customers
where customer_id NOT IN (
	SELECT
		customer_id
	FROM sales.orders
)




-- ============================================================
--  SECTION D — JOINs WITH GROUP BY
-- ============================================================

-- Q13.
-- Find the total number of orders per city (customer's city).
-- Join sales.orders with sales.customers.
-- Show city and total_orders, sorted by total_orders descending.


SELECT
	c.city AS customer_city,
	COUNT(o.order_id) AS total_orders
FROM sales.customers AS c
inner join sales.orders AS o
ON c.customer_id = o.customer_id
group by c.city
order by
	total_orders desc



-- Q14.
-- For each staff member, count how many orders they handled.
-- Join sales.orders with sales.staffs.
-- Show staff full name (first_name + ' ' + last_name) as staff_name
-- and order_count, sorted by order_count descending.

select
	s.first_name + ' ' + s.last_name as staff_name,
	count(o.order_id) AS order_count
from sales.staffs s
inner join sales.orders o
on s.staff_id = o.staff_id
group by
	s.first_name + ' ' + s.last_name
order by
	order_count desc




-- Q15. (BONUS — Multi-concept)
-- Find customers who have spent more than $10,000 in total.
-- Join sales.customers → sales.orders → sales.order_items.
-- Show customer full name as customer_name and total_spent.
-- Sort by total_spent descending.
-- (Hint: JOIN + GROUP BY + HAVING)

select
	c.first_name + ' ' + c.last_name AS customer_name,
	sum((oi.list_price * oi.quantity) * (1 - oi.discount)) AS total_spent
from sales.customers AS c
inner join sales.orders AS o
on 
	c.customer_id = o.customer_id
inner join sales.order_items AS oi
on 
	o.order_id = oi.order_id
group by 
	c.first_name + ' ' + c.last_name,
	c.customer_id
having sum((oi.list_price * oi.quantity) * (1 - oi.discount)) > 10000
order by
	total_spent desc;


-- ============================================================
--  END OF ASSIGNMENT 03
-- ============================================================
