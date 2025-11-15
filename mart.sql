CREATE TABLE mart.dim_date AS
SELECT
  d AS the_date,
  EXTRACT(DAYOFWEEK FROM d) AS dow,
  EXTRACT(MONTH FROM d) AS month,
  EXTRACT(YEAR FROM d) AS year
FROM UNNEST(GENERATE_DATE_ARRAY('2020-01-01', '2020-12-31')) AS d;


CREATE TABLE mart.dim_customer AS
SELECT
    ROW_NUMBER() OVER (ORDER BY user_id) AS customer_sk,
    user_id,
    MIN(order_number) AS first_order_number,
    MAX(order_number) AS last_order_number,
    COUNT(*) AS total_orders,
    TRUE AS current_flag
FROM stage.order_lines_enriched
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
