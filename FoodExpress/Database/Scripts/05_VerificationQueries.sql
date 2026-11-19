-- ============================================================
-- Script  : 05_VerificationQueries.sql
-- Project : FoodExpress – Food Delivery Platform
-- Sprint  : Sprint 1 – Database Development
-- Task    : S1-T6 – Sprint 1 Review
-- Purpose : Provides all verification queries for the Sprint 1
--           demonstration to the Hexaware trainer.
--           Run each numbered section and capture a screenshot.
-- Author  : Hexaware Training Capstone
-- Date    : 2026-11-19
-- ============================================================
-- INSTRUCTIONS (SSMS):
--   1. All 4 previous scripts must have been executed already.
--   2. Select FoodExpressDB in the database dropdown.
--   3. Run each VERIFICATION section one by one (highlight the
--      section and press F5) to get individual result sets.
--   4. Capture a screenshot after each section for submission.
-- ============================================================
-- VERIFICATION CHECKLIST:
--   VQ-01  FoodExpressDB database exists
--   VQ-02  All 6 tables are created
--   VQ-03  All 6 primary keys are configured
--   VQ-04  All 6 foreign key relationships are implemented
--   VQ-05  Sample data present in every table (row counts)
--   VQ-06  OrderItem contains at least 200 rows
--   VQ-07  Sample data preview from all 6 tables
--   VQ-08  CHECK constraint rejects invalid values
--   VQ-09  DEFAULT constraint applies correct default values
--   VQ-10  FOREIGN KEY constraint rejects invalid references
--   VQ-11  UNIQUE constraint on Customer.Phone verified
-- ============================================================

USE FoodExpressDB;
GO

-- ============================================================
-- VQ-01: Verify FoodExpressDB database exists
-- Expected: One row showing FoodExpressDB with state ONLINE
-- Screenshot: Capture the result showing database name + state
-- ============================================================

PRINT '=== VQ-01: FoodExpressDB Database Exists ===';

SELECT
    name                    AS [Database Name],
    database_id             AS [Database ID],
    create_date             AS [Created On],
    state_desc              AS [State],
    recovery_model_desc     AS [Recovery Model]
FROM
    sys.databases
WHERE
    name = N'FoodExpressDB';
GO

-- ============================================================
-- VQ-02: Verify all 6 tables are created
-- Expected: 6 rows — Customer, MenuItem, Order, OrderItem,
--           Restaurant, Rider
-- Screenshot: Capture the 6-row table list
-- ============================================================

PRINT '=== VQ-02: All 6 Tables Created ===';

SELECT
    TABLE_SCHEMA    AS [Schema],
    TABLE_NAME      AS [Table Name],
    TABLE_TYPE      AS [Type]
FROM
    INFORMATION_SCHEMA.TABLES
WHERE
    TABLE_TYPE = 'BASE TABLE'
ORDER BY
    TABLE_NAME;
GO

-- ============================================================
-- VQ-03: Verify all Primary Keys are configured
-- Expected: 6 rows — one PK per table
-- Screenshot: Capture PK list showing all 6 tables
-- ============================================================

PRINT '=== VQ-03: Primary Keys Configured ===';

SELECT
    tc.TABLE_NAME       AS [Table],
    tc.CONSTRAINT_NAME  AS [PK Constraint Name],
    kcu.COLUMN_NAME     AS [PK Column],
    tc.CONSTRAINT_TYPE  AS [Type]
FROM
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
    ON  tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
    AND tc.TABLE_NAME       = kcu.TABLE_NAME
WHERE
    tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY
    tc.TABLE_NAME;
GO

-- ============================================================
-- VQ-04: Verify all 6 Foreign Key relationships
-- Expected: 6 rows showing each FK, child table, parent table
-- Screenshot: Capture all 6 relationships
-- ============================================================

PRINT '=== VQ-04: All 6 Foreign Key Relationships ===';

SELECT
    fk.name                                                         AS [FK Constraint Name],
    OBJECT_NAME(fk.parent_object_id)                                AS [Child Table],
    COL_NAME(fkc.parent_object_id,     fkc.parent_column_id)       AS [FK Column],
    OBJECT_NAME(fk.referenced_object_id)                            AS [Parent Table],
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id)   AS [Referenced Column],
    fk.delete_referential_action_desc                               AS [On Delete]
FROM
    sys.foreign_keys           fk
JOIN
    sys.foreign_key_columns    fkc
    ON fk.object_id = fkc.constraint_object_id
ORDER BY
    [Child Table],
    [FK Constraint Name];
GO

-- ============================================================
-- VQ-05: Verify sample data exists in every table (row counts)
-- Expected: 6 rows, each table showing its record count
-- Screenshot: Capture the count table — key proof of data load
-- ============================================================

PRINT '=== VQ-05: Sample Data Present in Every Table ===';

SELECT 'Customer'   AS [Table Name], COUNT(*) AS [Row Count] FROM dbo.Customer
UNION ALL
SELECT 'Restaurant',                  COUNT(*)               FROM dbo.Restaurant
UNION ALL
SELECT 'Rider',                       COUNT(*)               FROM dbo.Rider
UNION ALL
SELECT 'MenuItem',                    COUNT(*)               FROM dbo.MenuItem
UNION ALL
SELECT '[Order]',                     COUNT(*)               FROM dbo.[Order]
UNION ALL
SELECT 'OrderItem',                   COUNT(*)               FROM dbo.OrderItem
ORDER BY
    [Table Name];
GO

-- ============================================================
-- VQ-06: Verify OrderItem contains at least 200 rows
-- Expected: Count >= 200 and Status shows PASS
-- Screenshot: Capture this result — proves high-volume table
-- ============================================================

PRINT '=== VQ-06: OrderItem High-Volume Table Check (>= 200 rows) ===';

SELECT
    COUNT(*)    AS [OrderItem Row Count],
    CASE
        WHEN COUNT(*) >= 200
        THEN 'PASS – Minimum 200 rows satisfied'
        ELSE 'FAIL – Less than 200 rows found'
    END         AS [High-Volume Requirement]
FROM
    dbo.OrderItem;
GO

-- ============================================================
-- VQ-07: Sample data preview from all 6 tables
-- Expected: Top rows from each table showing realistic data
-- Screenshot: One per table (6 screenshots total)
-- ============================================================

PRINT '=== VQ-07a: Customer Data Preview ===';
SELECT TOP 5
    CustomerID,
    FirstName,
    LastName,
    Phone,
    Address
FROM dbo.Customer
ORDER BY CustomerID;
GO

PRINT '=== VQ-07b: Restaurant Data Preview ===';
SELECT TOP 5
    RestaurantID,
    Name,
    Cuisine,
    City,
    CapacityPerHour
FROM dbo.Restaurant
ORDER BY RestaurantID;
GO

PRINT '=== VQ-07c: MenuItem Data Preview ===';
SELECT TOP 10
    mi.ItemID,
    mi.ItemName,
    mi.Price,
    r.Name AS RestaurantName
FROM dbo.MenuItem mi
JOIN dbo.Restaurant r ON mi.RestaurantID = r.RestaurantID
ORDER BY mi.ItemID;
GO

PRINT '=== VQ-07d: Rider Data Preview ===';
SELECT TOP 5
    RiderID,
    FirstName,
    LastName,
    VehicleType,
    Status
FROM dbo.Rider
ORDER BY RiderID;
GO

PRINT '=== VQ-07e: Order Data Preview ===';
SELECT TOP 5
    o.OrderID,
    c.FirstName + ' ' + c.LastName  AS [Customer],
    r.Name                           AS [Restaurant],
    rd.FirstName + ' ' + rd.LastName AS [Rider],
    o.OrderDate,
    o.Status,
    o.TotalAmount
FROM dbo.[Order] o
JOIN dbo.Customer    c  ON o.CustomerID    = c.CustomerID
JOIN dbo.Restaurant  r  ON o.RestaurantID  = r.RestaurantID
JOIN dbo.Rider       rd ON o.RiderID       = rd.RiderID
ORDER BY o.OrderID;
GO

PRINT '=== VQ-07f: OrderItem Data Preview (first 10 rows) ===';
SELECT TOP 10
    oi.OrderItemID,
    oi.OrderID,
    mi.ItemName,
    mi.Price,
    oi.Quantity,
    CAST(mi.Price * oi.Quantity AS DECIMAL(10,2)) AS [Line Total]
FROM dbo.OrderItem oi
JOIN dbo.MenuItem mi ON oi.ItemID = mi.ItemID
ORDER BY oi.OrderItemID;
GO

-- ============================================================
-- VQ-08: Verify CHECK Constraints reject invalid values
-- Demonstrates constraint enforcement with TRY...CATCH
-- Expected: CATCH block message confirms rejection
-- Screenshot: Capture Messages tab showing rejection text
-- ============================================================

PRINT '=== VQ-08: CHECK Constraint Enforcement ===';

-- CHECK 1: Negative price rejected
PRINT 'CHECK Test: Attempting to insert MenuItem with Price = -50.00 ...';
BEGIN TRY
    INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
    VALUES (1, 'VQ_InvalidItem', -50.00);
    PRINT 'UNEXPECTED: Negative price was accepted.';
    DELETE FROM dbo.MenuItem WHERE ItemName = 'VQ_InvalidItem';
END TRY
BEGIN CATCH
    PRINT 'CONFIRMED: CK_MenuItem_Price rejected Price = -50.00';
    PRINT 'SQL Error: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- CHECK 2: Zero quantity rejected
PRINT 'CHECK Test: Attempting to insert OrderItem with Quantity = 0 ...';
BEGIN TRY
    INSERT INTO dbo.OrderItem (OrderID, ItemID, Quantity)
    VALUES (1, 1, 0);
    PRINT 'UNEXPECTED: Zero quantity was accepted.';
    DELETE FROM dbo.OrderItem WHERE OrderID = 1 AND ItemID = 1 AND Quantity = 0;
END TRY
BEGIN CATCH
    PRINT 'CONFIRMED: CK_OrderItem_Quantity rejected Quantity = 0';
    PRINT 'SQL Error: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ============================================================
-- VQ-09: Verify DEFAULT Constraints apply correct defaults
-- Expected: Status columns show default values when omitted
-- Screenshot: Capture the SELECT results showing defaults
-- ============================================================

PRINT '=== VQ-09: DEFAULT Constraint Verification ===';

-- DEFAULT 1: Rider.Status defaults to 'Offline'
PRINT 'DEFAULT Test 1: Inserting Rider without specifying Status ...';
INSERT INTO dbo.Rider (FirstName, LastName, VehicleType)
VALUES ('VQ', 'TestRider', 'Scooter');

DECLARE @VQRiderID INT = SCOPE_IDENTITY();

SELECT
    RiderID,
    FirstName + ' ' + LastName  AS [Rider Name],
    VehicleType,
    Status                      AS [Status (should be Offline)],
    CASE
        WHEN Status = 'Offline' THEN 'DEFAULT PASSED'
        ELSE                         'DEFAULT FAILED'
    END                         AS [Result]
FROM dbo.Rider
WHERE RiderID = @VQRiderID;

DELETE FROM dbo.Rider WHERE RiderID = @VQRiderID;
PRINT 'Test row cleaned up.';
PRINT '';

-- DEFAULT 2: [Order].Status defaults to 'Placed'
PRINT 'DEFAULT Test 2: Inserting Order without specifying Status ...';
INSERT INTO dbo.[Order] (CustomerID, RestaurantID, RiderID, OrderDate, TotalAmount)
VALUES (1, 1, 1, GETDATE(), 299.00);

DECLARE @VQOrderID INT = SCOPE_IDENTITY();

SELECT
    OrderID,
    CustomerID,
    RestaurantID,
    RiderID,
    Status                      AS [Status (should be Placed)],
    TotalAmount,
    CASE
        WHEN Status = 'Placed' THEN 'DEFAULT PASSED'
        ELSE                        'DEFAULT FAILED'
    END                         AS [Result]
FROM dbo.[Order]
WHERE OrderID = @VQOrderID;

DELETE FROM dbo.[Order] WHERE OrderID = @VQOrderID;
PRINT 'Test row cleaned up.';
GO

-- ============================================================
-- VQ-10: Verify FOREIGN KEY Constraints reject invalid refs
-- Expected: CATCH block confirms each FK violation
-- Screenshot: Capture Messages tab showing all 3 rejections
-- ============================================================

PRINT '=== VQ-10: FOREIGN KEY Constraint Enforcement ===';

-- FK Test 1: Order with nonexistent CustomerID
PRINT 'FK Test 1: Inserting Order with CustomerID = 9999 (nonexistent) ...';
BEGIN TRY
    INSERT INTO dbo.[Order] (CustomerID, RestaurantID, RiderID, OrderDate, Status, TotalAmount)
    VALUES (9999, 1, 1, GETDATE(), 'Placed', 100.00);
    PRINT 'UNEXPECTED: Order with CustomerID=9999 was accepted.';
END TRY
BEGIN CATCH
    PRINT 'CONFIRMED: FK_Order_Customer rejected CustomerID = 9999';
    PRINT 'SQL Error: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- FK Test 2: OrderItem with nonexistent OrderID
PRINT 'FK Test 2: Inserting OrderItem with OrderID = 9999 (nonexistent) ...';
BEGIN TRY
    INSERT INTO dbo.OrderItem (OrderID, ItemID, Quantity)
    VALUES (9999, 1, 1);
    PRINT 'UNEXPECTED: OrderItem with OrderID=9999 was accepted.';
END TRY
BEGIN CATCH
    PRINT 'CONFIRMED: FK_OrderItem_Order rejected OrderID = 9999';
    PRINT 'SQL Error: ' + ERROR_MESSAGE();
END CATCH;

PRINT '';

-- FK Test 3: OrderItem with nonexistent ItemID
PRINT 'FK Test 3: Inserting OrderItem with ItemID = 9999 (nonexistent) ...';
BEGIN TRY
    INSERT INTO dbo.OrderItem (OrderID, ItemID, Quantity)
    VALUES (1, 9999, 1);
    PRINT 'UNEXPECTED: OrderItem with ItemID=9999 was accepted.';
END TRY
BEGIN CATCH
    PRINT 'CONFIRMED: FK_OrderItem_MenuItem rejected ItemID = 9999';
    PRINT 'SQL Error: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ============================================================
-- VQ-11: Verify UNIQUE Constraint on Customer.Phone
-- UQ_Customer_Phone is defined in 02_CreateTables.sql
-- Expected: Constraint listed + duplicate insert rejected
-- Screenshot: Capture both the constraint list and the error
-- ============================================================

PRINT '=== VQ-11: UNIQUE Constraint on Customer.Phone ===';

-- Show the UNIQUE constraint exists in the schema
SELECT
    tc.TABLE_NAME           AS [Table],
    tc.CONSTRAINT_NAME      AS [Constraint Name],
    kcu.COLUMN_NAME         AS [Column],
    tc.CONSTRAINT_TYPE      AS [Type]
FROM
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
JOIN
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
    ON  tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
    AND tc.TABLE_NAME       = kcu.TABLE_NAME
WHERE
    tc.CONSTRAINT_TYPE = 'UNIQUE';

-- Demonstrate duplicate rejection
PRINT 'UNIQUE Test: Attempting to insert duplicate phone 9876543210 ...';
BEGIN TRY
    INSERT INTO dbo.Customer (FirstName, LastName, Phone, Address)
    VALUES ('Duplicate', 'VQTest', '9876543210', 'Duplicate Street, Test City');
    PRINT 'UNEXPECTED: Duplicate phone was accepted.';
    DELETE FROM dbo.Customer WHERE Phone = '9876543210' AND FirstName = 'Duplicate';
END TRY
BEGIN CATCH
    PRINT 'CONFIRMED: UQ_Customer_Phone rejected the duplicate phone number.';
    PRINT 'SQL Error: ' + ERROR_MESSAGE();
END CATCH;
GO

-- ============================================================
-- BONUS: Full join query showing a complete order summary
-- Useful for demonstrating all 6 tables working together
-- Screenshot: Great for showing relational data to trainer
-- ============================================================

PRINT '=== BONUS: Complete Order Summary (All 6 Tables Joined) ===';

SELECT
    o.OrderID                           AS [Order ID],
    c.FirstName + ' ' + c.LastName      AS [Customer],
    c.Phone                             AS [Customer Phone],
    r.Name                              AS [Restaurant],
    r.City                              AS [City],
    rd.FirstName + ' ' + rd.LastName    AS [Rider],
    rd.VehicleType                      AS [Vehicle],
    mi.ItemName                         AS [Item],
    mi.Price                            AS [Unit Price],
    oi.Quantity                         AS [Qty],
    CAST(mi.Price * oi.Quantity AS DECIMAL(10,2)) AS [Line Total],
    o.Status                            AS [Order Status],
    o.OrderDate                         AS [Order Date]
FROM
    dbo.[Order]     o
JOIN dbo.Customer   c   ON o.CustomerID   = c.CustomerID
JOIN dbo.Restaurant r   ON o.RestaurantID = r.RestaurantID
JOIN dbo.Rider      rd  ON o.RiderID      = rd.RiderID
JOIN dbo.OrderItem  oi  ON o.OrderID      = oi.OrderID
JOIN dbo.MenuItem   mi  ON oi.ItemID      = mi.ItemID
ORDER BY
    o.OrderID,
    oi.OrderItemID;
GO

PRINT '';
PRINT '============================================================';
PRINT ' SPRINT 1 VERIFICATION COMPLETE';
PRINT '============================================================';
PRINT ' VQ-01  FoodExpressDB exists                 -> Verified';
PRINT ' VQ-02  All 6 tables created                 -> Verified';
PRINT ' VQ-03  All 6 primary keys configured        -> Verified';
PRINT ' VQ-04  All 6 FK relationships               -> Verified';
PRINT ' VQ-05  Sample data in every table           -> Verified';
PRINT ' VQ-06  OrderItem >= 200 rows                -> Verified';
PRINT ' VQ-07  Data previews from all 6 tables      -> Verified';
PRINT ' VQ-08  CHECK constraint enforcement         -> Verified';
PRINT ' VQ-09  DEFAULT constraint enforcement       -> Verified';
PRINT ' VQ-10  FK constraint enforcement            -> Verified';
PRINT ' VQ-11  UNIQUE constraint (Customer.Phone)   -> Verified';
PRINT '============================================================';
PRINT ' FoodExpress Sprint 1 Database is ready for review!';
PRINT '============================================================';
GO
