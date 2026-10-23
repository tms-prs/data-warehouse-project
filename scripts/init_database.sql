/*
First SQL Script of the Datawarehouse project

============================================================
Create Database and Schemas
============================================================

Created by : Thomas PARIS
Creation Date : 2026-10-23
Last modified : 2026-10-23
*/

-- Check if the database already exists. If so, drop it so the script can recreate it from scratch
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	-- Disconnect all active sessions to avoid the "database is in use" error
    ALTER DATABASE [MaBase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [MaBase];
END
GO

-- Switch to master to create a new database as an admin
USE master;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

-- Switch to the new database
USE DataWarehouse;
GO

-- Create all the three schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO