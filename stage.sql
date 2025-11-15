CREATE TABLE stage.stage_products AS
SELECT
p.product_id,
p.product_name,
p.aisle_id,
a.aisle,
p.department_id,
d.department
FROM raw.products p
LEFT JOIN raw.aisles a ON p.aisle_id = a.aisle_id
LEFT JOIN raw.departments d ON p.department_id = d.department_id;


CREATE TABLE stage.stage_orders AS
SELECT 
 o.*
FROM raw.orders o;


CREATE TABLE stage.stage_order_lines AS
SELECT
opl.order_id,
opl.product_id,
opl.add_to_cart_order,
opl.reordered
FROM raw.order_products__prior opl
UNION ALL
SELECT
olt.order_id,
olt.product_id,
olt.add_to_cart_order,
olt.reordered
FROM raw.order_products__train olt;


CREATE TABLE stage.order_lines_enriched AS
SELECT
ol.*,
o.user_id,
o.order_number,
o.order_dow,
o.order_hour_of_day,
o.days_since_prior_order
FROM stage.stage_order_lines ol
LEFT JOIN stage.stage_orders o ON ol.order_id = o.order_id;