-- ============================================================
-- Script  : 03_InsertSampleData.sql
-- Project : FoodExpress – Food Delivery Platform
-- Sprint  : Sprint 1 – Database Development
-- Task    : S1-T4 – Insert Sample Data
-- Purpose : Inserts realistic sample records into all 6 tables
--           Highest-volume table: OrderItem (200+ rows via loop)
-- Author  : Hexaware Training Capstone
-- Date    : 2026-11-19
-- ============================================================
-- RECORD COUNTS AFTER THIS SCRIPT:
--   Customer    : 10 rows
--   Restaurant  : 10 rows
--   Rider       : 10 rows
--   MenuItem    : 40 rows  (4 items per restaurant)
--   [Order]     : 10 rows
--   OrderItem   : 200 rows (20 items per order via WHILE loop)
-- ============================================================
-- INSERT ORDER (parent tables before child tables):
--   1. Customer
--   2. Restaurant
--   3. Rider
--   4. MenuItem       (FK → Restaurant)
--   5. [Order]        (FK → Customer, Restaurant, Rider)
--   6. OrderItem      (FK → [Order], MenuItem)
-- ============================================================

USE FoodExpressDB;
GO

-- ============================================================
-- SECTION 1: CUSTOMER (10 rows)
-- ============================================================

PRINT '--- Inserting Customers ---';

INSERT INTO dbo.Customer (FirstName, LastName, Phone, Address)
VALUES
    ('Rahul',    'Sharma',   '9876543210', '14 MG Road, New Delhi - 110001'),
    ('Priya',    'Patel',    '9823456789', '7 Marine Lines, Mumbai - 400020'),
    ('Arjun',    'Nair',     '9765432198', '22 Brigade Road, Bangalore - 560001'),
    ('Deepika',  'Reddy',    '9887654321', '9 Banjara Hills, Hyderabad - 500034'),
    ('Vikram',   'Singh',    '9654321098', '5 Anna Nagar, Chennai - 600040'),
    ('Anjali',   'Gupta',    '9712345678', '33 FC Road, Pune - 411004'),
    ('Suresh',   'Kumar',    '9843210987', '18 MI Road, Jaipur - 302001'),
    ('Meena',    'Iyer',     '9934567890', '11 MG Road, Kochi - 682011'),
    ('Rohit',    'Das',      '9678901234', '6 CG Road, Ahmedabad - 380009'),
    ('Kavitha',  'Menon',    '9512345670', '25 Avinashi Road, Coimbatore - 641018');
GO

PRINT '10 Customers inserted.';
GO

-- ============================================================
-- SECTION 2: RESTAURANT (10 rows)
-- ============================================================

PRINT '--- Inserting Restaurants ---';

INSERT INTO dbo.Restaurant (Name, Cuisine, City, CapacityPerHour)
VALUES
    ('Spice Garden',      'South Indian',  'Chennai',   30),
    ('Biryani House',     'North Indian',  'Hyderabad', 25),
    ('Dosa Plaza',        'South Indian',  'Bangalore', 35),
    ('Pizza Palace',      'Italian',       'Mumbai',    20),
    ('Dragon Wok',        'Chinese',       'Delhi',     25),
    ('Burger Barn',       'American',      'Pune',      30),
    ('Tandoor Tales',     'North Indian',  'Jaipur',    20),
    ('Coastal Kitchen',   'Seafood',       'Kochi',     15),
    ('Noodle Nest',       'Chinese',       'Bangalore', 25),
    ('Royal Thali',       'Indian',        'Ahmedabad', 30);
GO

PRINT '10 Restaurants inserted.';
GO

-- ============================================================
-- SECTION 3: RIDER (10 rows)
-- ============================================================
-- Status is explicitly provided here (Available / Busy / Offline).
-- DEFAULT 'Offline' is tested separately in 04_ConstraintTesting.sql

PRINT '--- Inserting Riders ---';

INSERT INTO dbo.Rider (FirstName, LastName, VehicleType, Status)
VALUES
    ('Amit',     'Verma',   'Bike',     'Available'),
    ('Ravi',     'Kumar',   'Scooter',  'Busy'),
    ('Sanjay',   'Pillai',  'Bike',     'Available'),
    ('Mohan',    'Das',     'Bicycle',  'Offline'),
    ('Kiran',    'Rao',     'Scooter',  'Available'),
    ('Deepak',   'Joshi',   'Bike',     'Busy'),
    ('Sunil',    'Mehta',   'Scooter',  'Available'),
    ('Prakash',  'Nair',    'Bike',     'Offline'),
    ('Ajay',     'Singh',   'Scooter',  'Busy'),
    ('Ramesh',   'Iyer',    'Bicycle',  'Available');
GO

PRINT '10 Riders inserted.';
GO

-- ============================================================
-- SECTION 4: MENUITEM (40 rows — 4 items per restaurant)
-- ============================================================
-- Item IDs will be auto-generated as 1–40 by IDENTITY(1,1).
-- This mapping is used by the OrderItem loop in Section 6:
--   Restaurant  1 (Spice Garden)    → ItemID  1 –  4
--   Restaurant  2 (Biryani House)   → ItemID  5 –  8
--   Restaurant  3 (Dosa Plaza)      → ItemID  9 – 12
--   Restaurant  4 (Pizza Palace)    → ItemID 13 – 16
--   Restaurant  5 (Dragon Wok)      → ItemID 17 – 20
--   Restaurant  6 (Burger Barn)     → ItemID 21 – 24
--   Restaurant  7 (Tandoor Tales)   → ItemID 25 – 28
--   Restaurant  8 (Coastal Kitchen) → ItemID 29 – 32
--   Restaurant  9 (Noodle Nest)     → ItemID 33 – 36
--   Restaurant 10 (Royal Thali)     → ItemID 37 – 40

PRINT '--- Inserting MenuItems ---';

-- Restaurant 1: Spice Garden (South Indian)
INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
VALUES
    (1, 'Masala Dosa',          80.00),
    (1, 'Idli Sambar',          60.00),
    (1, 'Medu Vada',            50.00),
    (1, 'Filter Coffee',        40.00);

-- Restaurant 2: Biryani House (North Indian)
INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
VALUES
    (2, 'Chicken Biryani',      220.00),
    (2, 'Veg Biryani',          180.00),
    (2, 'Mutton Biryani',       280.00),
    (2, 'Biryani Raita',         50.00);

-- Restaurant 3: Dosa Plaza (South Indian)
INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
VALUES
    (3, 'Paper Dosa',            70.00),
    (3, 'Rava Dosa',             90.00),
    (3, 'Paneer Dosa',          110.00),
    (3, 'Ghee Pongal',           80.00);

-- Restaurant 4: Pizza Palace (Italian)
INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
VALUES
    (4, 'Margherita Pizza',     199.00),
    (4, 'Pepperoni Pizza',      249.00),
    (4, 'Garlic Bread',          99.00),
    (4, 'Pasta Arrabiata',      179.00);

-- Restaurant 5: Dragon Wok (Chinese)
INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
VALUES
    (5, 'Veg Fried Rice',       150.00),
    (5, 'Chicken Fried Rice',   180.00),
    (5, 'Hakka Noodles',        160.00),
    (5, 'Veg Manchurian',       140.00);

-- Restaurant 6: Burger Barn (American)
INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
VALUES
    (6, 'Classic Burger',       149.00),
    (6, 'Cheese Burger',        179.00),
    (6, 'Veg Burger',           129.00),
    (6, 'French Fries',          79.00);

-- Restaurant 7: Tandoor Tales (North Indian)
INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
VALUES
    (7, 'Butter Chicken',       280.00),
    (7, 'Dal Makhani',          180.00),
    (7, 'Garlic Naan',           60.00),
    (7, 'Paneer Tikka',         220.00);

-- Restaurant 8: Coastal Kitchen (Seafood)
INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
VALUES
    (8, 'Fish Curry',           320.00),
    (8, 'Prawn Masala',         380.00),
    (8, 'Crab Fry',             450.00),
    (8, 'Coconut Rice',         100.00);

-- Restaurant 9: Noodle Nest (Chinese)
INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
VALUES
    (9, 'Spring Rolls',         130.00),
    (9, 'Chicken Chowmein',     170.00),
    (9, 'Veg Dim Sum',          150.00),
    (9, 'Szechwan Rice',        160.00);

-- Restaurant 10: Royal Thali (Indian)
INSERT INTO dbo.MenuItem (RestaurantID, ItemName, Price)
VALUES
    (10, 'Rajasthani Thali',   250.00),
    (10, 'North Indian Thali', 220.00),
    (10, 'South Indian Thali', 200.00),
    (10, 'Jain Thali',         230.00);
GO

PRINT '40 MenuItems inserted (4 per restaurant).';
GO

-- ============================================================
-- SECTION 5: [ORDER] (10 rows)
-- ============================================================
-- NOTE: 'Order' is a reserved keyword. Use [Order] always.
-- Each order links one Customer + one Restaurant + one Rider.
-- The Restaurant chosen matches items used in Section 6.
--   Order  1 → Customer 1,  Restaurant 1,  Rider 1
--   Order  2 → Customer 2,  Restaurant 2,  Rider 2
--   ...
--   Order 10 → Customer 10, Restaurant 10, Rider 10

PRINT '--- Inserting Orders ---';

INSERT INTO dbo.[Order] (CustomerID, RestaurantID, RiderID, OrderDate, Status, TotalAmount)
VALUES
    (1,  1,  1,  '2026-11-01 12:30:00', 'Delivered',  240.00),
    (2,  2,  2,  '2026-11-02 13:00:00', 'Delivered',  400.00),
    (3,  3,  3,  '2026-11-03 19:15:00', 'Delivered',  180.00),
    (4,  4,  4,  '2026-11-05 20:00:00', 'Preparing',  348.00),
    (5,  5,  5,  '2026-11-07 11:45:00', 'Delivered',  290.00),
    (6,  6,  6,  '2026-11-08 14:30:00', 'Delivered',  357.00),
    (7,  7,  7,  '2026-11-10 20:45:00', 'Placed',     540.00),
    (8,  8,  8,  '2026-11-12 13:00:00', 'Cancelled',  450.00),
    (9,  9,  9,  '2026-11-14 18:30:00', 'Delivered',  490.00),
    (10, 10, 10, '2026-11-16 12:00:00', 'Preparing',  450.00);
GO

PRINT '10 Orders inserted.';
GO

-- ============================================================
-- SECTION 6: ORDERITEM (200 rows using a WHILE loop)
-- ============================================================
-- Strategy:
--   Loop counter runs from 1 to 200.
--   @OrderID    = ((counter - 1) % 10) + 1
--                 → Distributes rows evenly across 10 orders
--                   (20 rows per order)
--   @ItemBase   = (@OrderID - 1) * 4 + 1
--                 → Start ItemID for the restaurant in that order
--                   (each restaurant has exactly 4 menu items)
--   @ItemOffset = (counter % 4)
--                 → Cycles 0,1,2,3 to pick one of the 4 items
--   @ItemID     = @ItemBase + @ItemOffset
--                 → Always a valid item for the order's restaurant
--   @Quantity   = (counter % 5) + 1
--                 → Varies 1 to 5 for realistic data
-- Result: 200 OrderItems where every ItemID belongs to the
--         same restaurant as its parent Order. ✅

PRINT '--- Inserting 200 OrderItems via WHILE loop ---';

DECLARE @Counter    INT = 1;
DECLARE @OrderID    INT;
DECLARE @ItemBase   INT;
DECLARE @ItemOffset INT;
DECLARE @ItemID     INT;
DECLARE @Quantity   INT;

WHILE @Counter <= 200
BEGIN
    SET @OrderID    = ((@Counter - 1) % 10) + 1;
    SET @ItemBase   = (@OrderID - 1) * 4 + 1;
    SET @ItemOffset = @Counter % 4;
    SET @ItemID     = @ItemBase + @ItemOffset;
    SET @Quantity   = (@Counter % 5) + 1;

    INSERT INTO dbo.OrderItem (OrderID, ItemID, Quantity)
    VALUES (@OrderID, @ItemID, @Quantity);

    SET @Counter = @Counter + 1;
END
GO

PRINT '200 OrderItems inserted.';
GO

-- ============================================================
-- SECTION 7: Verify record counts after all inserts
-- ============================================================

PRINT '----------------------------------------------------';
PRINT 'Sample data insertion complete. Record counts:';
PRINT '----------------------------------------------------';

SELECT 'Customer'   AS [Table], COUNT(*) AS [Row Count] FROM dbo.Customer
UNION ALL
SELECT 'Restaurant',              COUNT(*)               FROM dbo.Restaurant
UNION ALL
SELECT 'Rider',                   COUNT(*)               FROM dbo.Rider
UNION ALL
SELECT 'MenuItem',                COUNT(*)               FROM dbo.MenuItem
UNION ALL
SELECT '[Order]',                 COUNT(*)               FROM dbo.[Order]
UNION ALL
SELECT 'OrderItem',               COUNT(*)               FROM dbo.OrderItem;
GO

PRINT 'Verify: OrderItem must show 200 or more rows.';
GO
