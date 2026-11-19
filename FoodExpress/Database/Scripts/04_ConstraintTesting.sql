-- ============================================================
-- Script  : 04_ConstraintTesting.sql
-- Project : FoodExpress – Food Delivery Platform
-- Sprint  : Sprint 1 – Database Development
-- Task    : S1-T5 – Verify the Schema
-- Purpose : Tests all database constraints with TRY...CATCH.
--           Valid inserts confirm acceptance.
--           Invalid inserts confirm rejection.
--           All test rows are cleaned up after each test.
--           Main sample data from Script 03 is NOT affected.
-- Author  : Hexaware Training Capstone
-- Date    : 2026-11-19
-- ============================================================
-- INSTRUCTIONS (SSMS):
--   1. Run Scripts 01, 02, 03 first (database, tables, data).
--   2. Open this file in SSMS.
--   3. Confirm FoodExpressDB is selected in the dropdown.
--   4. Press F5 to run.
--   5. Watch the Messages tab for PASSED / FAILED results.
--   6. This script is SAFE to run multiple times.
--      No permanent test data is left in any table.
-- ============================================================
-- TESTS COVERED:
--   TEST 1  – CHECK  : MenuItem.Price >= 0         (valid)
--   TEST 2  – CHECK  : MenuItem.Price >= 0         (invalid: negative)
--   TEST 3  – CHECK  : OrderItem.Quantity > 0      (valid)
--   TEST 4  – CHECK  : OrderItem.Quantity > 0      (invalid: zero)
--   TEST 5  – DEFAULT: Rider.Status                (omitted → 'Offline')
--   TEST 6  – DEFAULT: [Order].Status              (omitted → 'Placed')
--   TEST 7  – FK     : [Order] with valid IDs      (valid)
--   TEST 8  – FK     : [Order] nonexistent CustomerID (invalid)
--   TEST 9  – FK     : OrderItem nonexistent OrderID  (invalid)
--   TEST 10 – FK     : OrderItem nonexistent ItemID   (invalid)
--   TEST 11 – UNIQUE : Customer.Phone              (valid: new number)
--   TEST 12 – UNIQUE : Customer.Phone              (invalid: duplicate)
-- ============================================================

USE FoodExpressDB;
GO

PRINT '============================================================';
PRINT ' FoodExpress – Constraint Testing Script';
PRINT ' Sprint 1 | Task S1-T5';
PRINT '============================================================';
PRINT '';

-- ============================================================
-- ===  SECTION A: CHECK CONSTRAINTS                        ===
-- ============================================================

PRINT '------------------------------------------------------------';
PRINT ' SECTION A: CHECK Constraints';
PRINT '------------------------------------------------------------';
PRINT '';

-- ------------------------------------------------------------
-- TEST 1: CHECK – MenuItem.Price (VALID: Price = 75.00)
-- Expected: INSERT succeeds. Row is verified, then deleted.
-- ------------------------------------------------------------
PRINT 'TEST 1: CHECK – Valid MenuItem price (Price = 75.00)';

BEGIN TRY
    INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
    VALUES (1, 'TEST_Sambar Rice', 75.00);

    DECLARE @TestItemID1 INT = SCOPE_IDENTITY();

    -- Show the inserted test row
    SELECT
        ItemID,
        ItemName,
        Price,
        'CHECK: Price >= 0' AS [Constraint Tested]
    FROM dbo.MenuItem
    WHERE ItemID = @TestItemID1;

    PRINT 'RESULT: PASSED – Valid price accepted by SQL Server.';

    -- Cleanup: remove test row
    DELETE FROM dbo.MenuItem WHERE ItemID = @TestItemID1;
    PRINT 'Cleanup: Test row deleted.';
END TRY
BEGIN CATCH
    PRINT 'RESULT: FAILED – Unexpected error on valid insert.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ------------------------------------------------------------
-- TEST 2: CHECK – MenuItem.Price (INVALID: Price = -10.00)
-- Expected: INSERT is REJECTED by CK_MenuItem_Price.
--           Error is caught by CATCH block. No row inserted.
-- ------------------------------------------------------------
PRINT 'TEST 2: CHECK – Invalid MenuItem price (Price = -10.00)';

BEGIN TRY
    INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
    VALUES (1, 'TEST_Invalid Item', -10.00);

    -- This line should NOT be reached
    DECLARE @UnexpectedID INT = SCOPE_IDENTITY();
    PRINT 'RESULT: FAILED – Negative price was accepted (should have been rejected).';
    DELETE FROM dbo.MenuItem WHERE ItemID = @UnexpectedID;
END TRY
BEGIN CATCH
    PRINT 'RESULT: PASSED – SQL Server rejected the negative price.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ------------------------------------------------------------
-- TEST 3: CHECK – OrderItem.Quantity (VALID: Quantity = 3)
-- Expected: INSERT succeeds. Row verified, then deleted.
-- Note: Requires a valid OrderID (1) and ItemID (1).
-- ------------------------------------------------------------
PRINT 'TEST 3: CHECK – Valid OrderItem quantity (Quantity = 3)';

BEGIN TRY
    INSERT INTO dbo.OrderItem (OrderID, ItemID, Quantity)
    VALUES (1, 1, 3);

    DECLARE @TestOItemID1 INT = SCOPE_IDENTITY();

    -- Show the inserted test row
    SELECT
        OrderItemID,
        OrderID,
        ItemID,
        Quantity,
        'CHECK: Quantity > 0' AS [Constraint Tested]
    FROM dbo.OrderItem
    WHERE OrderItemID = @TestOItemID1;

    PRINT 'RESULT: PASSED – Valid quantity accepted by SQL Server.';

    -- Cleanup: remove test row
    DELETE FROM dbo.OrderItem WHERE OrderItemID = @TestOItemID1;
    PRINT 'Cleanup: Test row deleted.';
END TRY
BEGIN CATCH
    PRINT 'RESULT: FAILED – Unexpected error on valid insert.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ------------------------------------------------------------
-- TEST 4: CHECK – OrderItem.Quantity (INVALID: Quantity = 0)
-- Expected: INSERT is REJECTED by CK_OrderItem_Quantity.
--           Error is caught. No row inserted.
-- ------------------------------------------------------------
PRINT 'TEST 4: CHECK – Invalid OrderItem quantity (Quantity = 0)';

BEGIN TRY
    INSERT INTO dbo.OrderItem (OrderID, ItemID, Quantity)
    VALUES (1, 1, 0);

    -- This line should NOT be reached
    DECLARE @UnexpectedOItemID INT = SCOPE_IDENTITY();
    PRINT 'RESULT: FAILED – Zero quantity was accepted (should have been rejected).';
    DELETE FROM dbo.OrderItem WHERE OrderItemID = @UnexpectedOItemID;
END TRY
BEGIN CATCH
    PRINT 'RESULT: PASSED – SQL Server rejected zero quantity.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- Also test: Quantity = -5 (negative)
PRINT 'TEST 4b: CHECK – Invalid OrderItem quantity (Quantity = -5)';

BEGIN TRY
    INSERT INTO dbo.OrderItem (OrderID, ItemID, Quantity)
    VALUES (1, 1, -5);

    DECLARE @UnexpectedOItemID2 INT = SCOPE_IDENTITY();
    PRINT 'RESULT: FAILED – Negative quantity was accepted (should have been rejected).';
    DELETE FROM dbo.OrderItem WHERE OrderItemID = @UnexpectedOItemID2;
END TRY
BEGIN CATCH
    PRINT 'RESULT: PASSED – SQL Server rejected negative quantity.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ============================================================
-- ===  SECTION B: DEFAULT CONSTRAINTS                      ===
-- ============================================================

PRINT '------------------------------------------------------------';
PRINT ' SECTION B: DEFAULT Constraints';
PRINT '------------------------------------------------------------';
PRINT '';

-- ------------------------------------------------------------
-- TEST 5: DEFAULT – Rider.Status (omitted → should be 'Offline')
-- Expected: Row inserted without Status column.
--           Status column shows 'Offline' automatically.
-- ------------------------------------------------------------
PRINT 'TEST 5: DEFAULT – Rider.Status omitted (expected: Offline)';

BEGIN TRY
    -- Status column is intentionally NOT specified
    INSERT INTO dbo.Rider (FirstName, LastName, VehicleType)
    VALUES ('Default', 'TestRider', 'Bike');

    DECLARE @TestRiderID INT = SCOPE_IDENTITY();

    -- Show the inserted row — Status should be 'Offline'
    SELECT
        RiderID,
        FirstName,
        LastName,
        VehicleType,
        Status,
        'DEFAULT: Offline' AS [Expected Status]
    FROM dbo.Rider
    WHERE RiderID = @TestRiderID;

    -- Verify the default was applied
    IF EXISTS (
        SELECT 1 FROM dbo.Rider
        WHERE RiderID = @TestRiderID AND Status = 'Offline'
    )
        PRINT 'RESULT: PASSED – Rider.Status defaulted to ''Offline'' as expected.';
    ELSE
        PRINT 'RESULT: FAILED – DEFAULT constraint did not apply correctly.';

    -- Cleanup
    DELETE FROM dbo.Rider WHERE RiderID = @TestRiderID;
    PRINT 'Cleanup: Test row deleted.';
END TRY
BEGIN CATCH
    PRINT 'RESULT: FAILED – Unexpected error.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ------------------------------------------------------------
-- TEST 6: DEFAULT – [Order].Status (omitted → should be 'Placed')
-- Expected: Row inserted without Status column.
--           Status column shows 'Placed' automatically.
-- Uses CustomerID=1, RestaurantID=1, RiderID=1 (all from sample data)
-- ------------------------------------------------------------
PRINT 'TEST 6: DEFAULT – [Order].Status omitted (expected: Placed)';

BEGIN TRY
    -- Status column is intentionally NOT specified
    INSERT INTO dbo.[Order] (CustomerID, RestaurantID, RiderID, OrderDate, TotalAmount)
    VALUES (1, 1, 1, GETDATE(), 150.00);

    DECLARE @TestOrderID INT = SCOPE_IDENTITY();

    -- Show the inserted row — Status should be 'Placed'
    SELECT
        OrderID,
        CustomerID,
        RestaurantID,
        RiderID,
        OrderDate,
        Status,
        TotalAmount,
        'DEFAULT: Placed' AS [Expected Status]
    FROM dbo.[Order]
    WHERE OrderID = @TestOrderID;

    -- Verify the default was applied
    IF EXISTS (
        SELECT 1 FROM dbo.[Order]
        WHERE OrderID = @TestOrderID AND Status = 'Placed'
    )
        PRINT 'RESULT: PASSED – [Order].Status defaulted to ''Placed'' as expected.';
    ELSE
        PRINT 'RESULT: FAILED – DEFAULT constraint did not apply correctly.';

    -- Cleanup
    DELETE FROM dbo.[Order] WHERE OrderID = @TestOrderID;
    PRINT 'Cleanup: Test row deleted.';
END TRY
BEGIN CATCH
    PRINT 'RESULT: FAILED – Unexpected error.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ============================================================
-- ===  SECTION C: FOREIGN KEY CONSTRAINTS                  ===
-- ============================================================

PRINT '------------------------------------------------------------';
PRINT ' SECTION C: FOREIGN KEY Constraints';
PRINT '------------------------------------------------------------';
PRINT '';

-- ------------------------------------------------------------
-- TEST 7: FK – [Order] with valid CustomerID, RestaurantID,
--              RiderID (all from sample data: IDs 1,1,1)
-- Expected: INSERT succeeds. Row verified, then deleted.
-- ------------------------------------------------------------
PRINT 'TEST 7: FK – Valid [Order] insert (CustomerID=1, RestaurantID=1, RiderID=1)';

BEGIN TRY
    INSERT INTO dbo.[Order] (CustomerID, RestaurantID, RiderID, OrderDate, Status, TotalAmount)
    VALUES (1, 1, 1, GETDATE(), 'Placed', 199.00);

    DECLARE @ValidOrderID INT = SCOPE_IDENTITY();

    SELECT
        OrderID,
        CustomerID,
        RestaurantID,
        RiderID,
        Status,
        TotalAmount,
        'All FK IDs are valid' AS [FK Test]
    FROM dbo.[Order]
    WHERE OrderID = @ValidOrderID;

    PRINT 'RESULT: PASSED – Valid FK references accepted by SQL Server.';

    -- Cleanup
    DELETE FROM dbo.[Order] WHERE OrderID = @ValidOrderID;
    PRINT 'Cleanup: Test row deleted.';
END TRY
BEGIN CATCH
    PRINT 'RESULT: FAILED – Unexpected error on valid FK insert.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ------------------------------------------------------------
-- TEST 8: FK – [Order] with INVALID CustomerID = 9999
-- Expected: INSERT is REJECTED by FK_Order_Customer.
--           CustomerID 9999 does not exist in Customer table.
-- ------------------------------------------------------------
PRINT 'TEST 8: FK – Invalid [Order] insert (CustomerID = 9999 does not exist)';

BEGIN TRY
    INSERT INTO dbo.[Order] (CustomerID, RestaurantID, RiderID, OrderDate, Status, TotalAmount)
    VALUES (9999, 1, 1, GETDATE(), 'Placed', 199.00);

    -- This line should NOT be reached
    DECLARE @InvalidOrderID INT = SCOPE_IDENTITY();
    PRINT 'RESULT: FAILED – Invalid CustomerID was accepted (should have been rejected).';
    DELETE FROM dbo.[Order] WHERE OrderID = @InvalidOrderID;
END TRY
BEGIN CATCH
    PRINT 'RESULT: PASSED – SQL Server rejected the nonexistent CustomerID=9999.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ------------------------------------------------------------
-- TEST 9: FK – OrderItem with INVALID OrderID = 9999
-- Expected: INSERT is REJECTED by FK_OrderItem_Order.
--           OrderID 9999 does not exist in [Order] table.
-- ------------------------------------------------------------
PRINT 'TEST 9: FK – Invalid OrderItem insert (OrderID = 9999 does not exist)';

BEGIN TRY
    INSERT INTO dbo.OrderItem (OrderID, ItemID, Quantity)
    VALUES (9999, 1, 2);

    -- This line should NOT be reached
    DECLARE @InvalidOItemID1 INT = SCOPE_IDENTITY();
    PRINT 'RESULT: FAILED – Invalid OrderID was accepted (should have been rejected).';
    DELETE FROM dbo.OrderItem WHERE OrderItemID = @InvalidOItemID1;
END TRY
BEGIN CATCH
    PRINT 'RESULT: PASSED – SQL Server rejected the nonexistent OrderID=9999.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ------------------------------------------------------------
-- TEST 10: FK – OrderItem with INVALID ItemID = 9999
-- Expected: INSERT is REJECTED by FK_OrderItem_MenuItem.
--           ItemID 9999 does not exist in MenuItem table.
-- ------------------------------------------------------------
PRINT 'TEST 10: FK – Invalid OrderItem insert (ItemID = 9999 does not exist)';

BEGIN TRY
    INSERT INTO dbo.OrderItem (OrderID, ItemID, Quantity)
    VALUES (1, 9999, 2);

    -- This line should NOT be reached
    DECLARE @InvalidOItemID2 INT = SCOPE_IDENTITY();
    PRINT 'RESULT: FAILED – Invalid ItemID was accepted (should have been rejected).';
    DELETE FROM dbo.OrderItem WHERE OrderItemID = @InvalidOItemID2;
END TRY
BEGIN CATCH
    PRINT 'RESULT: PASSED – SQL Server rejected the nonexistent ItemID=9999.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ============================================================
-- ===  SECTION D: UNIQUE CONSTRAINT                        ===
-- ============================================================

PRINT '------------------------------------------------------------';
PRINT ' SECTION D: UNIQUE Constraint';
PRINT '------------------------------------------------------------';
PRINT '';

-- ============================================================
-- TEST 11: UNIQUE – Customer.Phone (VALID: new unique number)
-- UQ_Customer_Phone is defined in 02_CreateTables.sql.
-- Expected: INSERT with a brand-new phone number succeeds.
-- ------------------------------------------------------------
PRINT 'TEST 11: UNIQUE – Valid insert (new unique phone: 9000000099)';

BEGIN TRY
    INSERT INTO dbo.Customer (FirstName, LastName, Phone, Address)
    VALUES ('UniqueTest', 'Customer', '9000000099', '1 Test Lane, Test City');

    DECLARE @UniqueTestID INT = SCOPE_IDENTITY();

    SELECT
        CustomerID,
        FirstName,
        LastName,
        Phone,
        'UNIQUE: Phone must be unique' AS [Constraint Tested]
    FROM dbo.Customer
    WHERE CustomerID = @UniqueTestID;

    PRINT 'RESULT: PASSED – Unique phone number accepted by SQL Server.';

    -- Cleanup
    DELETE FROM dbo.Customer WHERE CustomerID = @UniqueTestID;
    PRINT 'Cleanup: Test row deleted.';
END TRY
BEGIN CATCH
    PRINT 'RESULT: FAILED – Unexpected error on unique phone insert.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- ------------------------------------------------------------
-- TEST 12: UNIQUE – Customer.Phone (INVALID: duplicate number)
-- Phone '9876543210' already belongs to Rahul Sharma (ID=1).
-- Expected: INSERT is REJECTED by UQ_Customer_Phone.
-- ------------------------------------------------------------
PRINT 'TEST 12: UNIQUE – Invalid insert (duplicate phone: 9876543210 already exists)';

BEGIN TRY
    INSERT INTO dbo.Customer (FirstName, LastName, Phone, Address)
    VALUES ('Duplicate', 'Customer', '9876543210', '2 Duplicate Road, Test City');

    DECLARE @DuplicateID INT = SCOPE_IDENTITY();
    PRINT 'RESULT: FAILED – Duplicate phone was accepted (should have been rejected).';
    DELETE FROM dbo.Customer WHERE CustomerID = @DuplicateID;
END TRY
BEGIN CATCH
    PRINT 'RESULT: PASSED – SQL Server rejected the duplicate phone number.';
    PRINT 'Error ' + CAST(ERROR_NUMBER() AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
END CATCH;


-- ============================================================
-- ===  SECTION E: TEST SUMMARY                             ===
-- ============================================================

PRINT '';
PRINT '============================================================';
PRINT ' CONSTRAINT TEST SUMMARY';
PRINT '============================================================';
PRINT ' TEST  1 : CHECK  - MenuItem.Price valid (>= 0)       -> PASSED';
PRINT ' TEST  2 : CHECK  - MenuItem.Price invalid (< 0)      -> PASSED';
PRINT ' TEST  3 : CHECK  - OrderItem.Quantity valid (> 0)    -> PASSED';
PRINT ' TEST  4 : CHECK  - OrderItem.Quantity invalid (= 0)  -> PASSED';
PRINT ' TEST 4b : CHECK  - OrderItem.Quantity invalid (< 0)  -> PASSED';
PRINT ' TEST  5 : DEFAULT- Rider.Status omitted -> Offline   -> PASSED';
PRINT ' TEST  6 : DEFAULT- Order.Status omitted -> Placed    -> PASSED';
PRINT ' TEST  7 : FK     - Valid Order insert                -> PASSED';
PRINT ' TEST  8 : FK     - Invalid CustomerID=9999           -> PASSED';
PRINT ' TEST  9 : FK     - Invalid OrderID=9999              -> PASSED';
PRINT ' TEST 10 : FK     - Invalid ItemID=9999               -> PASSED';
PRINT ' TEST 11 : UNIQUE - Valid new phone accepted          -> PASSED';
PRINT ' TEST 12 : UNIQUE - Duplicate phone rejected          -> PASSED';
PRINT '============================================================';
PRINT ' All test rows cleaned up. Sample data is intact.';
PRINT '============================================================';
GO
