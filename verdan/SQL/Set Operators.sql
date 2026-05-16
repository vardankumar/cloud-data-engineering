-- CTE Common Table Expression

-- it allows to store the temprory result
-- query readable, understandable, reusability



--with cte_name(columan names)
--as
--	(cte_query)


WITH cte_sales_by_staff (full_name, net_sales, order_year) 
AS
	(
		SELECT
			s.first_name + ' ' + s.last_name AS full_name,
			sum((quantity * list_price) * (1 - discount)) as net_sales,
			year(o.order_date) AS order_year
		from sales.order_items oi
		inner join sales.orders o
		on oi.order_id = o.order_id
		inner join sales.staffs s
		on o.staff_id = s.staff_id
		group by
			s.first_name + ' ' + s.last_name,
			YEAR(o.order_date) 
	)
select * from cte_sales_by_staff
union all
select * from cte_sales_by_staff;



with cte_staff_sales(staff_id, orders)
AS 
(
	SELECT	
			staff_id,
			count(*) AS order_count
	from sales.orders 
	group by
		staff_id
)
select 
	avg(orders) as avg_order_count
from cte_staff_sales;
