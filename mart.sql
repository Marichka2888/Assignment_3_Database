CREATE TABLE mart.dim_date AS
WITH dates AS (
  SELECT DATE_ADD(DATE '2020-01-01', INTERVAL x DAY) AS the_date
  FROM UNNEST(GENERATE_ARRAY(0, 365)) AS x
)
SELECT
  the_date,
  EXTRACT(DAYOFWEEK FROM the_date) AS dow,
  EXTRACT(MONTH FROM the_date) AS month,
  EXTRACT(YEAR FROM the_date) AS year
FROM dates;

CREATE TABLE mart.dim_customer AS
SELECT
    row_number() OVER (ORDER BY user_id) AS customer_sk,
    user_id,
    MIN(order_number) AS first_order_number,
    MAX(order_number) AS last_order_number,
    COUNT(*) AS total_orders,
    TRUE AS current_flag
FROM stage.stage_orders
GROUP BY user_id;


CREATE TABLE mart.dim_product AS
SELECT
    ROW_NUMBER() OVER(ORDER BY product_id) AS product_sk,
    product_id,
    product_name,
    aisle,
    department,
    CURRENT_DATE() AS start_date,
    NULL AS end_date,
    TRUE AS current_flag,
    1 AS version
FROM stage.stage_products;

