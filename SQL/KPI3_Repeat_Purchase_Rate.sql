WITH orders as
(SELECT
C.customer_unique_id,
count(order_id) as order_num
FROM `Ecommerce.Orders` O
LEFT JOIN `Ecommerce.Customers` C
ON O.customer_id = C.customer_id
group by (customer_unique_id))
SELECT COUNT (CASE WHEN ORDERS.order_num > 1 THEN 1 END)*100.0/COUNT(*)
FROM ORDERS