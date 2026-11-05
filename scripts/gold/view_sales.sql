-- Fact : Sales
CREATE OR ALTER VIEW gold.fact_sales AS
SELECT
	sales.sls_ord_num				AS order_number
	, prd.product_key				AS product_key
	, cust.customer_key				AS customer_key
	, sales.sls_order_dt			AS order_date
	, sales.sls_ship_dt				AS ship_date
	, sales.sls_due_dt				AS due_date
	, sales.sls_sales				AS sales
	, sales.sls_quantity			AS quantity
	, sales.sls_price				AS price
FROM
	silver.crm_sales_details		AS sales
	LEFT JOIN gold.dim_customers	AS cust
		ON sales.sls_cust_id = cust.customer_id
	LEFT JOIN gold.dim_products		AS prd
		ON sales.sls_prd_key = prd.product_number;