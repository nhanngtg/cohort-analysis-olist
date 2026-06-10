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
    WHEN order_count = 1 THEN '1 Order'
    WHEN order_count = 2 THEN '2 Orders'
    WHEN order_count = 3 THEN '3 Orders'
    ELSE '4+ Orders'
END AS purchase_frequency,
COUNT(*) AS customers
FROM customer_orders
GROUP BY purchase_frequency
ORDER BY purchase_frequency