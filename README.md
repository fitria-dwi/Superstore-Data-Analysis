# Superstore Data Analysis

Created by Fitria Dwi Wulandari
### **Tools**: PostgreSQL

### **Questions**: ###
<details>
<summary > 1. How many SAME DAY orders were delayed in delivery? </summary>
<p>
	
```sql
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

There are **24** SAME DAY orders which is experiencing delays in delivery

</p>
</details>

<details>
<summary>2. Display average profit for each discount level !</summary>
<p> 
	
The condition of the discount level criteria are as follows:
- LOW if the discount is below 0.2 (excluding 0.2).
- MODERATE if the discount starts from 0.2 to below 0.4 (excluding 0.4).
- HIGH if the discount starts from 0.4 and above.

	
```sql
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
```

|group_discount | average_profit |
| :---: | :---: |
|LOW |67.03797971278317|
|MODERATE |19.835564024546144|
|HIGH |-107.65201132572433|

- The **higher the discount level**, the **lower the average profit**.
- Discount level ‘HIGH’ has the lowest average profit.
- Discount level ‘LOW’ has the highest average profit.

</p>
</details>

	
<details>
<summary>3. Display the Category and Subcategory with their average profit and discount</summary>
<p>

```sql
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

|category | subcategory | average_discount |average_profit|
| :---: | :---: |:---: | :---: |
|Furniture | Bookcases | 0.21114035087719298246 | -15.2305087719298380|
|Furniture | Chairs | 0.17017828200972447326 | 43.0958935170178139|
|Furniture | Furnishings | 0.13834900731452455590 | 13.64591807732497215
|Furniture | Tables | 0.26128526645768025078 | -55.5657714733542497|
|Office Supplies | Appliances | 0.16652360515021459227 | 38.92275836909870306|
|Office Supplies | Art | 0.07487437185929648241 | 8.20073743718592866|
|Office Supplies | Binders | 0.37229152987524622456 | 19.8435740643466793|
|Office Supplies | Envelopes | 0.08031496062992125984 | 27.4180185039370051|
|Office Supplies | Fasteners | 0.08202764976958525346 | 4.37565990783410111|
|Office Supplies | Labels | 0.06868131868131868132 | 15.2369615384615381|
|Office Supplies | Paper | 0.07489051094890510949 |24.8566199270072976|
|Office Supplies | Storage | 0.07470449172576832151 | 25.15227706855791304|
|Office Supplies | Supplies | 0.07684210526315789474 | -6.25841842105263644|
|Technology | Accessories | 0.07845161290322580645 | 54.11178799999999635|
|Technology | Copiers | 0.16176470588235294118 | 817.9091897058822724|
|Technology | Machines | 0.30608695652173913043 | 29.4326686956520713|
|Technology | Phones | 0.15455568053993250844 | 50.07393768278964770|

- The **highest average discount** was achieved by the **BINDERS** subcategory of the **OFFICE SUPPLIES** category.
- The **TECHNOLOGY** category seems to **dominate the highest average profit** with the **COPIERS**, **ACCESSORIES** and **PHONES** subcategories.

</p>
</details>

	
<details>
<summary>4. Display the performance (total sales and average profit) of each customer segment in the state of California, Texas, and Georgia on 2016 only</summary>
<p>

```sql
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

| segment| total_sales | average_profit |
| :---: | :---: | :---: |
| Consumer | 90982.3196000000012181| 30.32965562913906877 |
| Corporate | 50951.9110000000016284| 33.57349056603773146 |
| Home Office | 34897.9529999999997967| 34.66199395973154455 |

- The **CONSUMER** segment has the highest total sales, but the lowest average profit from other segments.
- The **HOME OFFICE** segment has the highest average profit, but the lowest total sales from other segments.

</p>
</details>

	
<details>
<summary>5. How many customers who loves discount (have an average discount above 0.4) for each existing region</summary>
<p>
	
```sql
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

|region | cust_love_discount|
| :---: | :---: |
| West| 3|
| South| 2|
| East| 2|
| Central| 2|

- There are 9 customers who loves discount (have an average discount above 0.4).
- The **WEST** region has the most customers who loves discount (have an average discount above 0.4).
- The **SOUTH**, **EAST**, and **CENTRA**L regions have the same number of customers who loves discount (with an average discount above 0.4), which is 2 people.

</p>
</details>

- - - -
	
### **Additional Questions**: ###

<details>
<summary>1. Display the average time to ship for each ship mode</summary>
<p>
	
```sql
SELECT 
	ship_mode,
	AVG(ABS(DATE_PART('day', ship_date) - DATE_PART('day', order_date))) AS time_to_ship
FROM
	orders
GROUP BY 1;
```

| ship_mode | time_to_ship |
| :---: | :---: |
| Standard Class | 7.968833780160858|
| Second Class | 5.410282776349614|
| Same Day | 0.04419889502762431|
| First Class | 3.8029908972691806|

**STANDARD CLASS** has the longest average time to ship, which is 8 days.

</p>
</details>

	
	
<details>
<summary>2. How are the sales, quantity, and profit performance throughout the years?</summary>
<p>
	
```sql
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
```

| year | total_order | total_quantity | total_sales | total_profit |
| :---: | :---: | :---: | :---: | :---: |
| 2014 | 1993 |7581 | 484247.50 | 49543.97|
| 2015 | 2102 | 7979 | 470532.51 | 61618.60|
| 2016 | 2587 | 9837 | 609205.60 | 81795.17|
| 2017 | 3312 | 12476 | 733215.26 | 93439.27|


	
</p>
</details>

<details>
<summary>3. Display quantity and profit performance for each region throughout the years </summary>
<p>
	
```sql
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
```

| region | year | total_quantity | total_profit|
| :---: | :---: | :---: | :---: |
| Central | 2014 | 1681 | 7976.07 |
| Central | 2015 | 1749 | 12092.39 |
| Central | 2016 | 2492 | 12508.69 |
| Central | 2017 | 3043 | 31032.19 |
| East | 2014 | 2061 | 12538.52 |
| East | 2015 | 2363 | 19037.89 |
| East | 2016 | 2846 | 26314.36 |
| East | 2017 | 3245 | 36713.53|
| South | 2014 | 1398 | 4338.20|
| South | 2015 | 1296 | 10460.65|
| South | 2016 | 1413 | 7487.96|
| South | 2017 | 2014 | 7888.32|
| West | 2014 | 2441 | 24691.18|
| West | 2015 | 2571 | 20027.66|
| West | 2016 | 3086 | 35484.16|
| West | 2017 | 4174 | 17805.23|

The region with highest profit is **EAST** region in 2017,  which is $36713.53.

	
</p>
</details>

	
	
<details>
<summary>4. Which city has the highest profit? </summary>
<p>
	
```sql
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
```

| country | city | total_profit |
| :---: | :---: | :---: |
| United States | Wilmington | 2965.9088999999996109 |

**WILMINGTON** city in the country of United States has the highest total profit.

</p>
</details>


	
<details>
<summary>5. Which category and subcategory have generated the most profit?</summary>
<p>
	
```sql
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
```

| category | subcategory | total_profit | 
| :---: | :---: | :---: |
| Technology | Copiers | 55617.82489999999452 | 
| Technology | Phones | 44515.73059999999680214 | 
| Technology | Accessories | 41936.63569999999717121 |
| Office Supplies | Paper | 34053.5692999999977475 |
| Office Supplies | Binders | 30221.7632999999926007 |

The **TECHNOLOGY** category seems to **dominate the highest total profit** with the **COPIERS**, **ACCESSORIES** and **PHONES** subcategories

</p>
</details>
