/* Superstore Data Analysis
Author: Fitria Dwi Wulandari (wulan391@sci.ui.ac.id) - July, 2022.
This notebook was made using PostgreSQL */

--- Study Case 1
SELECT 
	COUNT(1) AS total_delayed_delivery
FROM 
	orders
WHERE 
	ship_mode = 'Same Day' AND
	order_date != ship_date;
	
	
--- Study Case 2
SELECT
	CASE 
		 WHEN discount < 0.2 THEN 'LOW'
		 WHEN discount >= 0.2 AND discount < 0.4 THEN 'MODERATE'
		 ELSE 'HIGH'
	END AS group_discount,
	AVG(profit) as average_profit
FROM 
	orders
GROUP by 1
ORDER by 1 DESC;


--- Study Case 3
SELECT 
	p.category,
	p.subcategory,
	AVG(o.discount) AS average_discount,
	AVG(o.profit) AS average_profit
FROM 
	orders AS o
LEFT JOIN 
	product AS p
	ON o.product_id = p.product_id
GROUP BY 1,2
ORDER BY 1,2;


--- Study Case 4
SELECT
	c.segment,
	SUM(o.sales) AS total_sales,
	AVG(o.profit) AS average_profit
FROM 
	orders AS o
LEFT JOIN 
	customer AS c
	ON o.customer_id = c.customer_id
WHERE 
	c.state IN ('California', 'Texas', 'Georgia') AND
	date_part('year', o.order_date) = 2016
GROUP BY 1;

-- atau
WITH o AS
(
	SELECT
		*
	FROM 
		orders
	WHERE 
		date_part('year', order_date) = 2016
), 
c AS
(
	SELECT 
		*
	FROM
		customer
	WHERE 
		state IN ('California', 'Texas', 'Georgia')
)

SELECT 
	c.segment,
	SUM(o.sales) AS total_sales,
	AVG(o.profit) AS average_profit
FROM 
	c
LEFT JOIN
	o
	ON c.customer_id = o.customer_id
GROUP BY 1
ORDER BY 1;


--- Study Case 5
WITH o AS 
(
	SELECT 
		customer_id,
		AVG(discount) AS average_discount
	FROM 
		orders
	GROUP BY 1
	HAVING AVG(discount) > 0.4
)

SELECT 
	c.region,
	COUNT(1) AS cust_love_discount
FROM 
	o
LEFT JOIN
	customer AS c
	ON o.customer_id = c.customer_id
GROUP BY 1
ORDER BY 2 DESC;


--- Additional 1
SELECT 
	ship_mode,
	AVG(ABS(DATE_PART('day', ship_date) - DATE_PART('day', order_date))) AS time_to_ship
FROM
	orders
GROUP BY 1;
	

--- Additional 2
SELECT 
	EXTRACT(YEAR FROM order_date) AS year,
	count(1) AS total_order,
	SUM(quantity) AS total_quantity,
	round(SUM(sales),2) AS total_sales,
	round(SUM(profit),2) AS total_profit
FROM 
	orders
GROUP BY 1
ORDER BY 2,3 DESC;


--- Additional 3
SELECT 
	c.region,
	EXTRACT(YEAR FROM o.order_date) AS year,
	SUM(o.quantity) AS total_quantity,
	round(SUM(o.Profit),2) AS total_profit
FROM 
	orders o
LEFT JOIN 
	customer c
	ON o.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY 1,2,3,4;


--- Additional 4
SELECT 
	c.country,
	c.city,
	SUM(o.Profit) AS total_profit
FROM 
	orders o
LEFT JOIN 
	customer c
	ON o.customer_id = c.customer_id
GROUP BY 1,2
ORDER BY 2 DESC
LIMIT 1;


--- Additional 5
SELECT 
	p.category,
	p.subcategory,
	SUM(o.profit) AS total_profit
FROM 
	orders o
LEFT JOIN 
	product p
	ON o.product_id = p.product_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5;
