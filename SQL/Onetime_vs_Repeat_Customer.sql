WITH customer_orders AS (
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS order_count
FROM Ecommerce.Customers c
LEFT JOIN Ecommerce.Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
)

SELECT
CASE
    WHEN order_count = 1 THEN 'One-Time Customer'
    ELSE 'Repeat Customer'
END AS customer_type,
COUNT(*) AS customers
FROM customer_orders
GROUP BY customer_type