# Assignment_3_Database

This project builds a Data Warehouse for an e-commerce platform to analyze customer behavior, order history, and repeat purchases. The goal is to support analytics for product assortment, demand, recommendations, and marketing.

The DWH uses six raw data sources: 
1)raw.orders - which contains essential order information such as the user who placed the order, the order number, and the order sequence; 
2)raw.products - which describes each product; 
3)raw.aisles - which provides the names of product categories;
4)raw.departments - which provides the names of departments;
5)raw.order_products__prior and raw.order_products__train - which list the items included in previous and current orders. 

The architecture follows a three-layer design: Raw -> Stage -> Mart.

Stage Layer prepares the data by cleaning, merging, and enriching it:
stage.stage_products combines products with aisle and department names.
stage.stage_orders standardizes raw order data.
stage.stage_order_lines merges prior and train order line datasets.
stage.order_lines_enriched enriches order lines with user and order attributes and feeds into mart.dim_customer and mart.fact_order_lines.

Mart Layer implements the dimensional model:
mart.dim_product (from stage.stage_products) stores product attributes and connects to the fact table.
mart.dim_customer is built from stage.order_lines_enriched and summarizes user activity (first, last, and total orders).
mart.dim_date provides standard calendar attributes and is used for order_date.
mart.fact_order_lines is the central fact table containing every order line. It links to mart.dim_customer, mart.dim_product, and mart.dim_date.

As a bonus task, this project implements SCD Type 2 for the mart.dim_product table. 
This means that instead of storing only the current product attributes, we also keep a full history of how those attributes change over time. If the product name, aisle, or department is updated, the system does not overwrite the old data. Instead, it creates a new record, while the previous one is marked as no longer active. Each change creates a new version of the product record, marked with start_date, end_date, current_flag, and version.

Thank you for the attention!

OUR ROLES:
Mariia Sobchenko - writter of the SQL code in Big Quary
Anna Kozlovska - creator of sources and did bonus task
Yesieniia Smetanina - creator of README and Line Map








