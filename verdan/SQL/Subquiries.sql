-- SUBQUERIES

select
	*
from sales.orders
where customer_id IN (
	select
		customer_id
	from sales.customers
	where city = 'New york'
);


select
	product_name,
	list_price
from production.products
where list_price > (
	select
		AVG(list_price)
	from production.products
	where brand_id in (
		select
			brand_id
		from production.brands
		where brand_name in ('electra', 'trek')
	)
)


select
	category_id,
	product_name 
from production.products
	where category_id in (
	select
		category_id
	from production.categories
	where category_name IN ('Comfort Bicycles', 'Electric Bikes')
)


select
	category_id,
	product_name 
from production.products
where product_id IN (
	select
		product_id
	from production.stocks
	where quantity > 25
);





