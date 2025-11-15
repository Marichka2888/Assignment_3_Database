CREATE OR REPLACE TABLE mart.dim_product AS
WITH changed_products AS (
  SELECT
    s.product_id,
    s.product_name,
    s.aisle,
    s.department
  FROM stage.stage_products s
  LEFT JOIN mart.dim_product d
    ON d.product_id = s.product_id
   AND d.current_flag = TRUE
  WHERE d.product_id IS NULL
     OR d.product_name IS DISTINCT FROM s.product_name
     OR d.aisle IS DISTINCT FROM s.aisle
     OR d.department IS DISTINCT FROM s.department
),

closed_old AS (
  SELECT
    product_sk,
    product_id,
    product_name,
    aisle,
    department,
    start_date,
    EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))*10000 +
    EXTRACT(MONTH FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))*100 +
    EXTRACT(DAY FROM DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) AS end_date,
    FALSE AS current_flag,
    version
  FROM mart.dim_product
  WHERE current_flag = TRUE
    AND product_id IN (SELECT product_id FROM changed_products)
),

unchanged AS (
  SELECT
    product_sk,
    product_id,
    product_name,
    aisle,
    department,
    start_date,
    end_date,
    current_flag,
    version
  FROM mart.dim_product
  WHERE product_id NOT IN (SELECT product_id FROM changed_products)
),

new_versions AS (
  SELECT
    (SELECT IFNULL(MAX(product_sk),0) FROM mart.dim_product) + 
      ROW_NUMBER() OVER (ORDER BY c.product_id) AS product_sk,
    c.product_id,
    c.product_name,
    c.aisle,
    c.department,
    EXTRACT(YEAR FROM CURRENT_DATE())*10000 +
    EXTRACT(MONTH FROM CURRENT_DATE())*100 +
    EXTRACT(DAY FROM CURRENT_DATE()) AS start_date,
    NULL AS end_date,
    TRUE AS current_flag,
    COALESCE(
      (SELECT MAX(version) FROM mart.dim_product WHERE product_id = c.product_id),
      0
    ) + 1 AS version
  FROM changed_products c
)

SELECT * FROM unchanged
UNION ALL
SELECT * FROM closed_old
UNION ALL
SELECT * FROM new_versions;
