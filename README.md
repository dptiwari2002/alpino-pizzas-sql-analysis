# Alpino Pizzas: SQL Sales Analysis (2015)

## Introduction

Alpino Pizzas operates as a fast-casual dining brand focused on delivering high-quality, artisanal pizzas. To optimize daily operations, inventory planning, and menu performance, Alpino Pizzas collects detailed transactional records across its ordering channels. This report synthesizes key sales data from 2015 to evaluate performance metrics, uncover customer purchasing behaviors, and provide actionable operational insights.

## Dataset Description

Distribution of sales data across four core operational tables tracking activity from January 1, 2015, to December 31, 2015:

- **orders.csv (21,350 records):** Logs every unique customer purchase, capturing the transaction ID, date, and exact timestamp.
- **order_details.csv (48,620 records):** Contains line-item breakdowns for each order, mapping individual items and quantities purchased.
- **pizzas.csv (96 records):** Details menu item configurations, linking specific size variants (S, M, L, XL, XXL) and price points to pizza types.
- **pizza_types.csv (32 records):** Provides high-level categorization (Classic, Supreme, Veggie, Chicken) along with ingredient lists and menu names.

## Objective

The primary goal for Alpino Pizzas is to leverage transaction data to improve profitability, streamline supply chain management, and refine menu offerings. Key operational objectives include:

- **Identify High-Volume Driver Items:** Target top-selling menu items like *The Classic Deluxe Pizza* (2,453 units sold) to optimize kitchen prep workflows.
- **Refine Category Mix:** Balance stock management across major segments (**Classic** leading at 14,888 units, followed by **Supreme**, **Veggie**, and **Chicken**).
- **Staffing & Peak Hours Optimization:** Analyse order timestamp spikes to adjust floor and kitchen staffing schedules dynamically.
- **Maximize Cart Value:** Utilize the $38.31 average order value benchmark to design cross-selling opportunities (e.g., sides, drinks, combo upgrades).

## Insights

### 1. Retrieve the total number of orders placed.

```sql
select count(*) from orders ;
```

| count(*) |
|---|
| 21350 |

### 2. Calculate the total revenue generated from pizza sales.

```sql
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;
```

| total_revenue |
|---|
| 817860.05 |

### 3. Identify the highest-priced pizza.

```sql
select max(price) from pizzas ;
```

| max(price) |
|---|
| 35.95 |

### 4. Identify the most common pizza size ordered.

```sql
SELECT p.size, SUM(od.quantity) AS total_qty
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_qty DESC
limit 1;
```

| size | total_qty |
|---|---|
| L | 18956 |

### 5. List the top 5 most ordered pizza types along with their quantities.

```sql
SELECT pt.name, SUM(od.quantity) AS total_qty
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_qty DESC
LIMIT 5;
```

| name | total_qty |
|---|---|
| The Classic Deluxe Pizza | 2453 |
| The Barbecue Chicken Pizza | 2432 |
| The Hawaiian Pizza | 2422 |
| The Pepperoni Pizza | 2418 |
| The Thai Chicken Pizza | 2371 |

### 6. Join the necessary tables to find the total quantity of each pizza category ordered.

```sql
SELECT
    pt.category,
    SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;
```

| category | total_quantity |
|---|---|
| Classic | 14888 |
| Supreme | 11987 |
| Veggie | 11649 |
| Chicken | 11050 |

### 7. Determine the distribution of orders by hour of the day.

```sql
SELECT
    HOUR(time) AS hour,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY hour
ORDER BY hour;
```

| order_hour | total_orders |
|---|---|
| 9 | 1 |
| 10 | 8 |
| 11 | 1231 |
| 12 | 2520 |
| 13 | 2455 |
| 14 | 1472 |
| 15 | 1468 |
| 16 | 1920 |
| 17 | 2336 |
| 18 | 2399 |
| 19 | 2009 |
| 20 | 1642 |
| 21 | 1198 |
| 22 | 663 |
| 23 | 28 |

### 8. Join relevant tables to find the category-wise distribution of pizzas.

```sql
SELECT
    pt.category,
    COUNT(p.pizza_id) AS total_pizzas
FROM pizzas p
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_pizzas DESC;
```

| category | total_pizzas |
|---|---|
| Veggie | 27 |
| Classic | 26 |
| Supreme | 25 |
| Chicken | 18 |

### 9. Group the orders by date and calculate the average number of pizzas ordered per day.

```sql
SELECT
    ROUND(AVG(pizzas_per_day), 0) AS avg_pizzas_ordered_per_day
FROM (
    SELECT
        o.date,
        SUM(od.quantity) AS pizzas_per_day
    FROM orders o
    JOIN order_details od
        ON o.order_id = od.order_id
    GROUP BY o.date
) AS daily_totals;
```

| avg_pizzas_ordered_per_day |
|---|
| 138 |

### 10. Determine the top 3 most ordered pizza types based on revenue.

```sql
SELECT
    pt.name AS pizza_type,
    SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizzas p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;
```

| pizza_type | total_revenue |
|---|---|
| The Thai Chicken Pizza | 43434.25 |
| The Barbecue Chicken Pizza | 42768 |
| The California Chicken Pizza | 41409.5 |

## Conclusion

- Retrieve the total number of orders placed - **21350**
- The total revenue generated from pizza sales - **817860.05**
- The highest-priced pizza - **35.95**
- The most common pizza size ordered - **L (18956)**

**Top 5 most ordered pizza types along with their quantities**

| Rank | Pizza | Quantity |
|---|---|---|
| I | The Classic Deluxe Pizza | 2453 |
| II | The Barbecue Chicken Pizza | 2432 |
| III | The Hawaiian Pizza | 2422 |
| IV | The Pepperoni Pizza | 2418 |
| V | The Thai Chicken Pizza | 2371 |

**Total quantity of each pizza category ordered**

| Category | Quantity |
|---|---|
| Classic | 14888 |
| Supreme | 11987 |
| Veggie | 11649 |
| Chicken | 11050 |

**Distribution of orders by hour of the day** - peak hours are 12:00 to 13:00 (lunch) and 17:00 to 18:00 (dinner); see the full table in Insight 7.

**Category-wise distribution of pizzas (menu variants)**

| Category | Pizzas |
|---|---|
| Veggie | 27 |
| Classic | 26 |
| Supreme | 25 |
| Chicken | 18 |

- Average number of pizzas ordered per day - **138**

**Top 3 most ordered pizza types based on revenue**

| Pizza | Revenue |
|---|---|
| The Thai Chicken Pizza | 43434.25 |
| The Barbecue Chicken Pizza | 42768 |
| The California Chicken Pizza | 41409.5 |

Alpino Pizzas demonstrates strong revenue stability driven by consistent demand in core classic and supreme menu options. With nearly 50,000 pizzas sold in a single operating year, the brand's primary growth levers lie in inventory forecast precision and peak-hour efficiency. By streamlining raw ingredient purchasing based on high-performing recipes and nudging customer basket sizes above the current $38.31 average, Alpino Pizzas can significantly increase operating margins without compromising output quality.
