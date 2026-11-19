-- ============================================================
-- Script  : 02_CreateTables.sql
-- Project : FoodExpress – Food Delivery Platform
-- Sprint  : Sprint 1 – Database Development
-- Task    : S1-T3 – DDL Scripts
-- Purpose : Creates all 6 tables with constraints and indexes
-- Author  : Hexaware Training Capstone
-- Date    : 2026-11-19
-- ============================================================
-- INSTRUCTIONS (SSMS):
--   1. Run 01_CreateDatabase.sql FIRST if not already done.
--   2. Connect to FoodExpressDB (select it from the dropdown).
--   3. Open this file and click Execute (F5).
--   4. Expected output: Six "Table created." messages in the
--      Messages tab, one for each table.
--   5. Verify in Object Explorer:
--      FoodExpressDB > Tables — all 6 tables should appear.
--   6. Expand any table > Columns to verify columns.
--   7. Expand any table > Keys to verify PK and FK constraints.
--   8. Expand any table > Indexes to verify FK indexes.
-- ============================================================
-- TABLE CREATION ORDER (parent tables before child tables):
--   1. Customer       — no foreign keys
--   2. Restaurant     — no foreign keys
--   3. Rider          — no foreign keys
--   4. MenuItem       — FK → Restaurant
--   5. [Order]        — FK → Customer, Restaurant, Rider
--   6. OrderItem      — FK → [Order], MenuItem
-- NOTE: [Order] uses square brackets because ORDER is a
--       reserved keyword in SQL Server T-SQL.
-- ============================================================

USE FoodExpressDB;
GO

-- ============================================================
-- Drop tables in reverse dependency order if they exist
-- (Allows re-running this script safely)
-- ============================================================

IF OBJECT_ID(N'dbo.OrderItem', N'U') IS NOT NULL
    DROP TABLE dbo.OrderItem;

IF OBJECT_ID(N'dbo.[Order]', N'U') IS NOT NULL
    DROP TABLE dbo.[Order];

IF OBJECT_ID(N'dbo.MenuItem', N'U') IS NOT NULL
    DROP TABLE dbo.MenuItem;

IF OBJECT_ID(N'dbo.Rider', N'U') IS NOT NULL
    DROP TABLE dbo.Rider;

IF OBJECT_ID(N'dbo.Restaurant', N'U') IS NOT NULL
    DROP TABLE dbo.Restaurant;

IF OBJECT_ID(N'dbo.Customer', N'U') IS NOT NULL
    DROP TABLE dbo.Customer;

PRINT 'Existing tables dropped (if any). Creating fresh schema...';
GO

-- ============================================================
-- TABLE 1: Customer
-- ============================================================
-- Stores details of customers who place food orders.
-- Parent table: referenced by [Order].CustomerID
-- UNIQUE constraint on Phone: each customer must have a
-- distinct phone number for identity and contact purposes.
-- ============================================================

CREATE TABLE dbo.Customer
(
    CustomerID  INT             NOT NULL IDENTITY(1,1),
    FirstName   NVARCHAR(50)    NOT NULL,
    LastName    NVARCHAR(50)    NOT NULL,
    Phone       NVARCHAR(20)    NULL,
    Address     NVARCHAR(200)   NULL,

    -- Primary Key Constraint
    CONSTRAINT PK_Customer PRIMARY KEY (CustomerID),

    -- Unique Constraint: each customer must have a unique phone number
    CONSTRAINT UQ_Customer_Phone UNIQUE (Phone)
);
GO

PRINT 'Table Customer created. (UNIQUE constraint on Phone enforced.)';
GO

-- ============================================================
-- TABLE 2: Restaurant
-- ============================================================
-- Stores details of restaurants available on the platform.
-- Parent table: referenced by MenuItem.RestaurantID
--               and [Order].RestaurantID
-- ============================================================

CREATE TABLE dbo.Restaurant
(
    RestaurantID        INT             NOT NULL IDENTITY(1,1),
    Name                NVARCHAR(100)   NOT NULL,
    Cuisine             NVARCHAR(50)    NULL,
    City                NVARCHAR(50)    NULL,
    CapacityPerHour     INT             NULL,

    -- Primary Key Constraint
    CONSTRAINT PK_Restaurant PRIMARY KEY (RestaurantID)
);
GO

PRINT 'Table Restaurant created.';
GO

-- ============================================================
-- TABLE 3: Rider
-- ============================================================
-- Stores details of delivery riders.
-- Parent table: referenced by [Order].RiderID
-- Status defaults to 'Offline' when not specified.
-- ============================================================

CREATE TABLE dbo.Rider
(
    RiderID         INT             NOT NULL IDENTITY(1,1),
    FirstName       NVARCHAR(50)    NOT NULL,
    LastName        NVARCHAR(50)    NOT NULL,
    VehicleType     NVARCHAR(20)    NULL,
    Status          NVARCHAR(20)    NOT NULL
                    CONSTRAINT DF_Rider_Status DEFAULT ('Offline'),

    -- Primary Key Constraint
    CONSTRAINT PK_Rider PRIMARY KEY (RiderID)
);
GO

PRINT 'Table Rider created.';
GO

-- ============================================================
-- TABLE 4: MenuItem
-- ============================================================
-- Stores food items listed by each restaurant.
-- Child of Restaurant (RestaurantID FK).
-- Parent of OrderItem (ItemID FK).
-- Price must be non-negative (CHECK constraint).
-- ============================================================

CREATE TABLE dbo.MenuItem
(
    ItemID          INT             NOT NULL IDENTITY(1,1),
    RestaurantID    INT             NOT NULL,
    ItemName        NVARCHAR(100)   NOT NULL,
    Price           DECIMAL(10,2)   NOT NULL,

    -- Primary Key Constraint
    CONSTRAINT PK_MenuItem PRIMARY KEY (ItemID),

    -- Foreign Key: MenuItem belongs to a Restaurant
    CONSTRAINT FK_MenuItem_Restaurant
        FOREIGN KEY (RestaurantID)
        REFERENCES dbo.Restaurant (RestaurantID),

    -- Check Constraint: Price must be zero or positive
    CONSTRAINT CK_MenuItem_Price
        CHECK (Price >= 0)
);
GO

-- Index on FK column RestaurantID for join performance
CREATE INDEX IX_MenuItem_RestaurantID
    ON dbo.MenuItem (RestaurantID);
GO

PRINT 'Table MenuItem created.';
GO

-- ============================================================
-- TABLE 5: [Order]
-- ============================================================
-- Stores customer orders placed through the platform.
-- NOTE: 'Order' is a reserved T-SQL keyword.
--       Always reference this table as [Order] in queries.
-- Child of Customer, Restaurant, Rider.
-- Parent of OrderItem.
-- Status defaults to 'Placed' when not specified.
-- ============================================================

CREATE TABLE dbo.[Order]
(
    OrderID         INT             NOT NULL IDENTITY(1,1),
    CustomerID      INT             NOT NULL,
    RestaurantID    INT             NOT NULL,
    RiderID         INT             NOT NULL,
    OrderDate       DATETIME2       NOT NULL,
    Status          NVARCHAR(20)    NOT NULL
                    CONSTRAINT DF_Order_Status DEFAULT ('Placed'),
    TotalAmount     DECIMAL(10,2)   NOT NULL,

    -- Primary Key Constraint
    CONSTRAINT PK_Order PRIMARY KEY (OrderID),

    -- Foreign Key: Order placed by a Customer
    CONSTRAINT FK_Order_Customer
        FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customer (CustomerID),

    -- Foreign Key: Order placed at a Restaurant
    CONSTRAINT FK_Order_Restaurant
        FOREIGN KEY (RestaurantID)
        REFERENCES dbo.Restaurant (RestaurantID),

    -- Foreign Key: Order assigned to a Rider
    CONSTRAINT FK_Order_Rider
        FOREIGN KEY (RiderID)
        REFERENCES dbo.Rider (RiderID)
);
GO

-- Indexes on FK columns for join and filter performance
CREATE INDEX IX_Order_CustomerID
    ON dbo.[Order] (CustomerID);

CREATE INDEX IX_Order_RestaurantID
    ON dbo.[Order] (RestaurantID);

CREATE INDEX IX_Order_RiderID
    ON dbo.[Order] (RiderID);

-- Index on OrderDate for date-range queries (payouts, reports)
CREATE INDEX IX_Order_OrderDate
    ON dbo.[Order] (OrderDate);
GO

PRINT 'Table [Order] created.';
GO

-- ============================================================
-- TABLE 6: OrderItem
-- ============================================================
-- Stores individual line items within each order.
-- This is the highest-volume table (200+ rows).
-- Child of [Order] (OrderID FK) and MenuItem (ItemID FK).
-- Quantity must be a positive integer (CHECK constraint).
-- ============================================================

CREATE TABLE dbo.OrderItem
(
    OrderItemID     INT     NOT NULL IDENTITY(1,1),
    OrderID         INT     NOT NULL,
    ItemID          INT     NOT NULL,
    Quantity        INT     NOT NULL,

    -- Primary Key Constraint
    CONSTRAINT PK_OrderItem PRIMARY KEY (OrderItemID),

    -- Foreign Key: OrderItem belongs to an Order
    CONSTRAINT FK_OrderItem_Order
        FOREIGN KEY (OrderID)
        REFERENCES dbo.[Order] (OrderID),

    -- Foreign Key: OrderItem references a MenuItem
    CONSTRAINT FK_OrderItem_MenuItem
        FOREIGN KEY (ItemID)
        REFERENCES dbo.MenuItem (ItemID),

    -- Check Constraint: Quantity must be greater than zero
    CONSTRAINT CK_OrderItem_Quantity
        CHECK (Quantity > 0)
);
GO

-- Indexes on FK columns for join performance
CREATE INDEX IX_OrderItem_OrderID
    ON dbo.OrderItem (OrderID);

CREATE INDEX IX_OrderItem_ItemID
    ON dbo.OrderItem (ItemID);
GO

PRINT 'Table OrderItem created.';
GO

-- ============================================================
-- Final verification: List all created tables
-- ============================================================

PRINT '----------------------------------------------------';
PRINT 'Schema creation complete. Tables in FoodExpressDB:';
PRINT '----------------------------------------------------';

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

PRINT 'All 6 tables created successfully in FoodExpressDB.';
GO
