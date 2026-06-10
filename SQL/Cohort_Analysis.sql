WITH 
BASE AS(
  SELECT
  ORD.order_id,
  C.customer_id,
  C.customer_unique_id,
  DATE(order_purchase_timestamp) AS ORDER_DATE
  FROM `Ecommerce.Orders` ORD
  LEFT JOIN `Ecommerce.Customers` C
  ON ORD.customer_id = C.customer_id
),
First_Purchase AS(
SELECT
  C.customer_unique_id,
  MIN(DATE(order_purchase_timestamp)) AS FIRST_PURCHASE
FROM `Ecommerce.Orders` ORD
LEFT JOIN `Ecommerce.Customers` C
ON ORD.customer_id = C.customer_id
GROUP BY customer_unique_id),
Cohort_base AS (
SELECT
  FP.customer_unique_id,
  B.order_id,
  FP.FIRST_PURCHASE,
  B.ORDER_DATE,
  DATE_DIFF(B.ORDER_DATE, FP.FIRST_PURCHASE,MONTH) AS month_index,
  DATE_TRUNC(FP.FIRST_PURCHASE, MONTH) AS COHORT_MONTH
FROM First_Purchase FP
LEFT JOIN Base B
ON FP.customer_unique_id = B.customer_unique_id),
Retention_table AS(
SELECT
  CB.month_index,
  CB.COHORT_MONTH,
  COUNT (DISTINCT CB.Customer_unique_id) AS USERS
FROM Cohort_base CB
  GROUP BY CB.COHORT_MONTH, CB.month_index
),
Final AS(
  SELECT
  Retention_table.COHORT_MONTH,
  Retention_table.month_index,
  Retention_table.USERS,
  FIRST_VALUE(USERS) OVER (
    PARTITION BY Retention_table.COHORT_MONTH
    ORDER BY Retention_table.month_index
  ) AS COHORT_SIZE,
  Retention_table.USERS * 1.0 / FIRST_VALUE(USERS) OVER(
    PARTITION BY Retention_table.COHORT_MONTH
    ORDER BY Retention_table.month_index
  ) AS RETENTION_RATE
  FROM Retention_table
)
SELECT *
FROM Final
ORDER BY Final.COHORT_MONTH, Final.month_index