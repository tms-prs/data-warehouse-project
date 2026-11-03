/*

============================================================
Quality check des tables provenant de la couche bronze
============================================================

Sources: Bronze layer

Créé par: Thomas PARIS
Date: 2026-11-02
Dernière date de modification: 2026-11-02
Modifié par: Thomas PARIS
*/


-- Table : crm_cust_info
SELECT *
FROM bronze.crm_cust_info;

-- Check for nulls and duplicate values
SELECT
	cst_id
	, COUNT(*)
FROM
	bronze.crm_cust_info
GROUP BY
	cst_id
HAVING
	COUNT(*) > 2 OR cst_id IS NULL;

-- Check for different values
SELECT DISTINCT
	cst_marital_status
FROM
	bronze.crm_cust_info;

-- Check for different values
SELECT DISTINCT
	cst_marital_status
FROM
	bronze.crm_cust_info;

-----------------------------------------------

-- Table : crm_prd_info
SELECT *
FROM bronze.crm_prd_info;

-- Check for nulls and duplicate values
SELECT
	prd_id
	, COUNT(*)
FROM
	bronze.crm_prd_info
GROUP BY
	prd_id
HAVING
	COUNT(*) > 2 OR prd_id IS NULL;

-- Check for unwanted spaces
SELECT
	*
FROM
	bronze.crm_prd_info
WHERE
	LEN(prd_nm) != LEN(TRIM(prd_nm));

-- Check for weird values
SELECT DISTINCT
	prd_cost
FROM
	bronze.crm_prd_info
WHERE
	prd_cost < 0 OR prd_cost IS NULL;

-- Data standardization & consistency
SELECT DISTINCT
	prd_line
FROM
	bronze.crm_prd_info;

-- Data consistency
SELECT
	*
FROM
	bronze.crm_prd_info
WHERE
	prd_start_dt > prd_end_dt;

-----------------------------------------------

-- Table : crm_sales_details
SELECT *
FROM bronze.crm_sales_details;

-- Check for invalid dates
SELECT 
	NULLIF(sls_order_dt, 0) sls_order_dt
FROM 
	bronze.crm_sales_details
WHERE
	sls_order_dt <= 0 OR LEN(sls_order_dt) != 8;

-- Check for invalid dates
SELECT 
	NULLIF(sls_ship_dt, 0) sls_ship_dt
FROM 
	bronze.crm_sales_details
WHERE
	sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8;

-- Check for invalid dates
SELECT 
	NULLIF(sls_due_dt, 0) sls_due_dt
FROM 
	bronze.crm_sales_details
WHERE
	sls_due_dt <= 0 OR LEN(sls_due_dt) != 8;

-- Check Data Consistency between sales, quantity and price
SELECT 
	sls_sales
	, sls_quantity
	, sls_price
FROM 
	bronze.crm_sales_details
WHERE
	sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL
	OR sls_quantity IS NULL
	OR sls_price IS NULL
	OR sls_sales <= 0
	OR sls_quantity <= 0
	OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-----------------------------------------------

-- Table : erp_cust_az12
SELECT *
FROM bronze.erp_cust_az12;

-- Data consistency on ID Lenght
SELECT *
FROM bronze.erp_cust_az12
WHERE LEN(cid) != 10;

-- Data validity
SELECT DISTINCT gen
FROM bronze.erp_cust_az12;

-----------------------------------------------

-- Table : erp_loc_a101
SELECT *
FROM bronze.erp_loc_a101;

-- Handle invalid data
SELECT 
	cid	AS old_cid
	, REPLACE(cid, '-', '')	AS new_cid
FROM bronze.erp_loc_a101;

-- Check for all different values
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101;

-----------------------------------------------

-- Table : erp_px_cat_g1v2
SELECT *
FROM bronze.erp_px_cat_g1v2;



