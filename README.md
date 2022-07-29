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

1. How many SAME DAY orders were delayed in delivery?

    ```SELECT 
	    COUNT(1) AS total_delayed_delivery
    FROM 
	    orders
    WHERE 
	    ship_mode = 'Same Day' AND
	    order_date != ship_date;```
       
| total_delayed_delivery |
| :---: | 
| 24  |

2. Display average profit for each discount level!
