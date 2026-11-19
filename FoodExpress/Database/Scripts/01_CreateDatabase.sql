-- ============================================================
-- Script  : 01_CreateDatabase.sql
-- Project : FoodExpress – Food Delivery Platform
-- Sprint  : Sprint 1 – Database Development
-- Task    : S1-T3 – DDL Scripts
-- Purpose : Creates the FoodExpressDB database on SQL Server
-- Author  : Hexaware Training Capstone
-- Date    : 2026-11-19
-- ============================================================
-- INSTRUCTIONS (SSMS):
--   1. Connect to your SQL Server instance in SSMS.
--   2. Open this file: File > Open > File...
--   3. Click Execute (F5) or press the Execute button.
--   4. Expected output: "FoodExpressDB created successfully."
--      If it already exists: "FoodExpressDB already exists. No action taken."
--   5. After running, verify in Object Explorer (left panel):
--      Databases > FoodExpressDB should appear.
-- ============================================================

USE master;
GO

-- -------------------------------------------------------
-- Create FoodExpressDB only if it does not already exist
-- -------------------------------------------------------
IF NOT EXISTS (
    SELECT name
    FROM sys.databases
    WHERE name = N'FoodExpressDB'
)
BEGIN
    CREATE DATABASE FoodExpressDB;
    PRINT 'FoodExpressDB created successfully.';
END
ELSE
BEGIN
    PRINT 'FoodExpressDB already exists. No action taken.';
END
GO

-- -------------------------------------------------------
-- Switch context to FoodExpressDB for all further work
-- -------------------------------------------------------
USE FoodExpressDB;
GO

PRINT 'Now connected to FoodExpressDB.';
GO
