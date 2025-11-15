CREATE TABLE mart.fact_order_lines AS
SELECT
    ROW_NUMBER() OVER () AS order_line_sk,
    ol.order_id,
    DATE_ADD(DATE '2020-01-01', INTERVAL ol.order_number DAY) AS order_date,
    dp.product_sk,
    c.customer_sk,
    ol.add_to_cart_order,
    ol.reordered,
    1 AS quantity
FROM stage.order_lines_enriched ol
LEFT JOIN mart.dim_customer c ON c.user_id = ol.user_id
LEFT JOIN mart.dim_product dp ON dp.product_id = ol.product_id AND dp.current_flag = TRUE;



