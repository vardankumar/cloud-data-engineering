-- GROUP BY / Aggregates the data

select
	count(order_date)
from sales.orders
group by
	order_date;



select
	customer_id,
	count(customer_id) AS orders,
	YEAR(order_date) AS year
from sales.orders
where customer_id in (1, 2, 115)
group by
	customer_id,
	YEAR(order_date) ;


select
	city,
	count(customer_id) as no_of_customers
from sales.customers
group by
	city
order by count(customer_id) desc;
	



select
	customer_id
from sales.customers
where
	customer_id in (1, 2)
group by
	customer_id;



select
	c.category_name,
	MAX(p.list_price) AS max_price,
	MIN(p.list_price) AS min_price
from production.categories c
inner join production.products p
on c.category_id = p.category_id
group by
	c.category_name;


select
	c.category_name,
	MAX(p.list_price) AS max_price,
	MIN(p.list_price) AS min_price
from production.categories c
inner join production.products p
on c.category_id = p.category_id
group by
	c.category_name
having Min(p.list_price) > 1000
	and MAX(p.list_price) < 10000;


select
	c.category_id,
	c.category_name,
	AVG(p.list_price) AS avg_price
from production.categories c
inner join production.products p
on c.category_id = p.category_id
group by
	c.category_id,
	c.category_name
having AVG(p.list_price) between 500 and 1000;


SELECT
	order_id,
	sum((quantity * list_price) * (1 - discount)) as total_order_value
from sales.order_items oi
group by
	order_id
order by
	total_order_value desc;

-- HAVING
SELECT
	order_id,
	sum((quantity * list_price) * (1 - discount)) as total_order_value
from sales.order_items oi
group by
	order_id
having
	sum((quantity * list_price) * (1 - discount)) > 100 
order by
	total_order_value desc;




select
	s.store_id,
	sum((oi.quantity * oi.list_price) * (1 - oi.discount)) as total_order_value
from
	sales.orders AS o
inner join sales.order_items AS oi
on oi.order_id = o.order_id
inner join sales.stores AS s
on 
	o.store_id = s.store_id
group by 
	s.store_id
order by 
	total_order_value desc;


	

-- SUBQUERIES