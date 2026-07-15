/*
-------------------------------------------------------------------------------------------------------------------------------------------------
Pizza sales Analysis Using SQL
AUTHOR: Syed Aasia Afsheen

Description:
This project analyzes pizza sales data to identify sales trends, customer behavior, top-selling pizzas, revenue performance, and business insights.
Database: Mysql
Visualization Tool: Tableau
---------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- total orders
 select
count(order_id) as total_orders from order_details;

-- how many pizzas were sold?
select 
sum(quantity) as total_pizzas_sold
from order_details;

-- on average, how much does a customer spend per order?
SELECT
    ROUND(
        SUM(od.quantity * p.price) /
        COUNT(DISTINCT od.order_id),
        2
    ) AS average_order_value
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id;
    
    -- i want to know how many pizzas customers order on average
    
    select round(sum(quantity)/count(distinct order_id),2)
    as average_pizzas_per_order
    from order_details;
     
     -- total revenue
 select
sum(od.quantity * p.price) as total_revenue
from order_details as od
join pizzas as p
on od.pizza_id=p.pizza_id;

 --  KPI
 
 
 -- i want to know which pizza category generates the highest revenue so we know where to focus

select pt.category,
sum(od.quantity * p.price) as total_revenue
from order_details as od
join pizzas as p
on od.pizza_id = p.pizza_id
join pizza_types as pt
on p.pizza_type_id= pt.pizza_type_id
group by pt.category
order by total_revenue desc;


-- which are the top 5 best-selling pizzas based on revenue

 select pt.name,
 sum(od.quantity * p.price) as total_revenue
 from order_details as od
 join pizzas as p
 on od.pizza_id=p.pizza_id
join pizza_types as pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by total_revenue desc
limit 5;

-- which pizza size generates the highest revenue?

SELECT
    p.size,
    SUM(od.quantity * p.price) AS total_revenue
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_revenue DESC;

-- show me top 3 pizzas within each category based on revenue

WITH ranked_pizzas AS (
    SELECT
        pt.category,
        pt.name,
        SUM(od.quantity * p.price) AS total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY pt.category
            ORDER BY SUM(od.quantity * p.price) DESC
        ) AS rn
    FROM order_details od
    JOIN pizzas p
        ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt
        ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
)
SELECT *
FROM ranked_pizzas
WHERE rn <= 3;

-- which month generates the highest revenue?

select monthname(o.date) as month,
sum(od.quantity * p.price) as total_revenue
from orders as o
join order_details as od
on o.order_id=od.order_id
join pizzas as p
on od.pizza_id=p.pizza_id
group by monthname(o.date)
order by total_revenue desc
limit 1;

-- which day of week generates the highest revenue?

select dayname(date) as day,
sum(od.quantity * p.price) as total_revenue
from orders as o
join order_details as od
on o.order_id = od.order_id
join pizzas as p
on od.pizza_id=p.pizza_id
group by dayname(date) 
order by total_revenue desc
limit 1;

-- at what hour of the day are the most orders placed

select 
hour(time) as hour,
count(order_id) as total_orders
from orders
group by hour(time)
order by total_orders desc
limit 1; 
  
 -- identify the highest- priced pizza

select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;   