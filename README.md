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


### **Result**: ###

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

| segment| total_sales | average_profit |
| :---: | :---: | :---: |
| Consumer | 90982.3196000000012181| 30.32965562913906877 |
| Corporate | 50951.9110000000016284| 33.57349056603773146 |
| Home Office | 34897.9529999999997967| 34.66199395973154455 |


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

|region | cust_love_discount|
| :---: | :---: |
| West| 3|
| South| 2|
| East| 2|
| Central| 2|
