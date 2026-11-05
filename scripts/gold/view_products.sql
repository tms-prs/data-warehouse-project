-- Dimension : Product
CREATE OR ALTER VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY prd.prd_start_dt, prd.prd_id) AS product_key
	, prd.prd_id							AS product_id
	, prd.prd_key							AS product_number
	, prd.prd_nm							AS product_name
	, prd.prd_line							AS product_line
	, prd.cat_id							AS category_id
	, ISNULL(cat.cat, 'N/A')				AS category_name
	, ISNULL(cat.subcat, 'N/A')				AS subcategory
	, ISNULL(cat.maintenance, 'N/A')		AS maintenance
	, prd.prd_cost							AS cost
	, prd.prd_start_dt						AS start_date
FROM
	silver.crm_prd_info						AS prd
	LEFT JOIN silver.erp_px_cat_g1v2		AS cat
		ON prd.cat_id = cat.id
WHERE
	prd_end_dt IS NULL;