-- Sunrise Supermarket | Oracle SQL | Queries 1-8

-- Q1. INNER JOIN: every order with customer name, city, date
SELECT o.order_id, c.customer_name, c.city, o.order_date
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_id;

-- Q2. JOIN: every order item with product name, category, price, quantity
SELECT oi.order_item_id, oi.order_id, p.product_name, p.category, p.price, oi.quantity
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
ORDER BY oi.order_item_id;

-- Q3. LEFT JOIN: all customers and their orders (including those with none)
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
ORDER BY c.customer_id, o.order_date;

-- Q4. CTE: customers who spent above the average customer spend
WITH customer_totals AS (
  SELECT c.customer_id, c.customer_name,
         SUM(oi.quantity * p.price) AS total_spent
  FROM customers c
  JOIN orders o       ON o.customer_id = c.customer_id
  JOIN order_items oi ON oi.order_id   = o.order_id
  JOIN products p     ON p.product_id  = oi.product_id
  GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id, customer_name, total_spent
FROM customer_totals
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_totals)
ORDER BY total_spent DESC;

-- Q5. Window function: rank customers by total spent (highest first)
WITH customer_totals AS (
  SELECT c.customer_id, c.customer_name,
         SUM(oi.quantity * p.price) AS total_spent
  FROM customers c
  JOIN orders o       ON o.customer_id = c.customer_id
  JOIN order_items oi ON oi.order_id   = o.order_id
  JOIN products p     ON p.product_id  = oi.product_id
  GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id, customer_name, total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS spend_rank
FROM customer_totals
ORDER BY spend_rank;

-- Q6. Window function: number each customer's orders chronologically
SELECT c.customer_name, o.order_id, o.order_date,
       ROW_NUMBER() OVER (PARTITION BY o.customer_id
                          ORDER BY o.order_date, o.order_id) AS order_number
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
ORDER BY c.customer_name, order_number;

-- Q7. Window function: running total of revenue by order date
WITH order_revenue AS (
  SELECT o.order_id, o.order_date,
         SUM(oi.quantity * p.price) AS order_total
  FROM orders o
  JOIN order_items oi ON oi.order_id  = o.order_id
  JOIN products p     ON p.product_id = oi.product_id
  GROUP BY o.order_id, o.order_date
)
SELECT order_id, order_date, order_total,
       SUM(order_total) OVER (ORDER BY order_date, order_id
                              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM order_revenue
ORDER BY order_date, order_id;

-- Q8. LAG: days between a customer's current and previous order
--     (only customers with more than one order; first orders are excluded)
SELECT customer_name, order_id, order_date, previous_order_date,
       order_date - previous_order_date AS days_since_previous
FROM (
  SELECT c.customer_name, o.order_id, o.order_date,
         LAG(o.order_date) OVER (PARTITION BY o.customer_id
                                 ORDER BY o.order_date, o.order_id) AS previous_order_date
  FROM orders o
  JOIN customers c ON c.customer_id = o.customer_id
)
WHERE previous_order_date IS NOT NULL
ORDER BY customer_name, order_date;
