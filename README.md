# Superstore-Data-Analysis

**Objective**: Create an analysis report.

**Actions**:

1. How many SAME DAY orders were delayed in delivery?
2. Display average profit for each discount level, where the discount level criteria are as follows:
    - LOW if the discount is below 0.2 (excluding 0.2).
    - MODERATE if the discount starts from 0.2 to below 0.4 (excluding 0.4).
    - HIGH if the discount starts from 0.4 and above.

3. Display the Category and Subcategory with their average profit and discount.
4. Display the performance (total sales, and average profit) of each of the Customer Segments in that states on 2016 only.
5. How many customers who loves discount (have an average discount above 0.4) for each existing region.


**Result**:

1. **How many SAME DAY orders were delayed in delivery?**

```
SELECT 
	COUNT(1) AS total_delayed_delivery
FROM 
	orders
WHERE 
	ship_mode = 'Same Day' AND
	order_date != ship_date;
```
       
| total_delayed_delivery |
| :---: | 
| 24  |


2. **Display average profit for each discount level !**
```
SELECT
	AVG(profit) as average_profit,
	CASE 
		 WHEN discount < 0.2 THEN 'LOW'
		 WHEN discount >= 0.2 AND discount < 0.4 THEN 'MODERATE'
		 ELSE 'HIGH'
	END AS group_discount
FROM 
	orders
GROUP by 2
ORDER by 1 DESC;
```

|average_profit | group_discount |
| :---: | :---: |
|67.03797971278317|LOW|
|19.835564024546144|MODERATE|
|-107.65201132572433|HIGH|
![image](https://user-images.githubusercontent.com/74573342/181753104-b7353e61-2b47-40a1-a704-825b383aebeb.png)


3. **Display the Category and Subcategory with their average profit and discount**
```
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
```

4. **Display the performance (total sales, and average profit) of each of the Customer Segments in that states on 2016 only**
```
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
```

5. **How many customers who loves discount (have an average discount above 0.4) for each existing region**
```
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
```
