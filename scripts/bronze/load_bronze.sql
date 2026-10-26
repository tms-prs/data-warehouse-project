/*
============================================================
Script d'alimentation depuis les fichiers sources
============================================================

Sources: erp et crm
Format: csv
Alimentation: truncate et insert
Méthode: procédure stockée

Créé par: Thomas PARIS
Date: 2026-10-26
Dernière date de modification: 2026-10-26
Modifié par: Thomas PARIS
*/

-- Utilisation de la bdd 'DataWarehouse'
USE DataWarehouse;
GO

-- Création d'une procédure stockée alimentant toutes les tables
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
        PRINT '=========================';
        PRINT 'Loading bronze layer';
        PRINT '=========================';
    
        PRINT '-------------------------';
        PRINT 'loading CRM Tables';
        PRINT '-------------------------';
        
		SET @start_time = GETDATE();
        PRINT '>>> Truncating table: crm_cust_info'
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>>> Insert raw data into : crm_cust_info'
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\ThomasPARIS\Documents\perso\data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
    
		SET @start_time = GETDATE();
        PRINT '>>> Truncating table: crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>>> Insert raw data into : crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\ThomasPARIS\Documents\perso\data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
    
		SET @start_time = GETDATE();
        PRINT '>>> Truncating table: crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
    
        PRINT '>>> Insert raw data into : crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\ThomasPARIS\Documents\perso\data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
    
        PRINT '-------------------------';
        PRINT 'loading ERP Tables';
        PRINT '-------------------------';
        
		SET @start_time = GETDATE();
        PRINT '>>> Truncating table: erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>>> Insert raw data into : erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\ThomasPARIS\Documents\perso\data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
    
		SET @start_time = GETDATE();
        PRINT '>>> Truncating table: erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>>> Insert raw data into : erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\ThomasPARIS\Documents\perso\data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';
    
		SET @start_time = GETDATE();
        PRINT '>>> Truncating table: erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>>> Insert raw data into : erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\ThomasPARIS\Documents\perso\data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
    END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END