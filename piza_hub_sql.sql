create database pizza_hub;
use pizza_hub;
create table order_detail(
order_d_id  int,
order_id int,
pizza_id varchar(30),
quantity int
);
create table order_id(
order_id int,
date date,
time time
);
create table pizza_type_id(
pizza_type_id varchar(30),
name varchar(50),
caregory varchar(30),
ingredients varchar(150)
);
create table pizza_id(
pizza_id varchar(50),
pizza_type_id varchar(50),
size varchar(10),
price decimal(7,2)
);

-- 1Retrieve the total number of orders placed.
select count(*) from orders ;

-- Calculate the total revenue generated from pizza sales. 
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- Identify the highest-priced pizza.
select max(price) from pizzas ;

-- Identify the most common pizza size ordered.
SELECT p.size, SUM(od.quantity) AS total_qty
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_qty DESC
limit 1;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT pt.name, SUM(od.quantity) AS total_qty
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_qty DESC
LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered. 
SELECT pt.category, SUM(od.quantity) AS total_qty
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_qty DESC;

-- Determine the distribution of orders by hour of the day. 
SELECT 
    HOUR(time) AS hour,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY hour
ORDER BY hour;

--  Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    pt.category,
    COUNT(p.pizza_id) AS total_pizzas
FROM pizzas p
JOIN pizza_types pt 
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_pizzas DESC;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
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

-- Determine the top 3 most ordered pizza types based on revenue.
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
