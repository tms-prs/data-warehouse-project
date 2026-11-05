-- Dimension : Customer
CREATE OR ALTER VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id)						AS customer_key
	, cust.cst_id											AS customer_id
	, cust.cst_key											AS customer_number
	, cust.cst_firstname									AS first_name
	, cust.cst_lastname										AS last_name
	, birth.bdate											AS birthdate
	, CASE
		WHEN cust.cst_gndr != 'N/A' THEN cust.cst_gndr
		ELSE COALESCE(birth.gen, 'N/A')
	END														AS gender
	, loc.cntry												AS country
	, cust.cst_marital_status								AS marital_status
	, cust.cst_create_date									AS create_date
FROM
	silver.crm_cust_info			AS cust
	LEFT JOIN silver.erp_cust_az12	AS birth
		ON cust.cst_key = birth.cid
	LEFT JOIN silver.erp_loc_a101	AS loc
		ON cust.cst_key = loc.cid;