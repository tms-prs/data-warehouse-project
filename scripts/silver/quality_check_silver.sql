/*

============================================================
Quality check des tables provenant de la couche silver
============================================================

Sources: Silver layer

Créé par: Thomas PARIS
Date: 2026-11-02
Dernière date de modification: 2026-11-02
Modifié par: Thomas PARIS
*/

-- Table : crm_cust_info
SELECT *
FROM silver.crm_cust_info;

-- Check for nulls and duplicate values
SELECT
	cst_id
	, COUNT(*)
FROM
	silver.crm_cust_info
GROUP BY
	cst_id
HAVING
	COUNT(*) > 2 OR cst_id IS NULL;

-- Check for unwanted spaces
SELECT DISTINCT
	cst_marital_status
FROM
	silver.crm_cust_info;

-- Check for unwanted spaces
SELECT DISTINCT
	cst_marital_status
FROM
	silver.crm_cust_info;

-----------------------------------------------

-- Table : crm_prd_info
SELECT *
FROM silver.crm_prd_info;

-- Check for nulls and duplicate values
SELECT
	prd_id
	, COUNT(*)
FROM
	silver.crm_prd_info
GROUP BY
	prd_id
HAVING
	COUNT(*) > 2 OR prd_id IS NULL;

-- Check for unwanted spaces
SELECT
	*
FROM
	silver.crm_prd_info
WHERE
	LEN(prd_nm) != LEN(TRIM(prd_nm));

-- Check for weird values
SELECT DISTINCT
	prd_cost
FROM
	silver.crm_prd_info
WHERE
	prd_cost < 0 OR prd_cost IS NULL;

-- Data standardization & consistency
SELECT DISTINCT
	prd_line
FROM
	silver.crm_prd_info;

-- Data consistency
SELECT
	*
FROM
	silver.crm_prd_info
WHERE
	prd_start_dt > prd_end_dt;

-----------------------------------------------

-- Table : crm_sales_details
SELECT *
FROM silver.crm_sales_details;

-- Check for invalid dates
SELECT 
	*
FROM 
	silver.crm_sales_details
WHERE
	sls_order_dt > sls_ship_dt
	OR sls_order_dt > sls_due_dt;

-- Check Data Consistency between sales, quantity and price
SELECT 
	sls_sales
	, sls_quantity
	, sls_price
FROM 
	silver.crm_sales_details
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
FROM silver.erp_cust_az12;

-- Data consistency on ID Lenght
SELECT *
FROM silver.erp_cust_az12
WHERE LEN(cid) != 10;

-- Data validity
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

-----------------------------------------------

-- Table : erp_loc_a101
SELECT *
FROM silver.erp_loc_a101;

-- Handle invalid data
SELECT 
	cid	AS old_cid
	, REPLACE(cid, '-', '')	AS new_cid
FROM silver.erp_loc_a101;

-- Check for all different values
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;