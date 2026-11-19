# FoodExpress – Database Documentation

## Database: FoodExpressDB

**DBMS:** Microsoft SQL Server  
**Tool:** SQL Server Management Studio (SSMS)  
**Language:** T-SQL  

---

## Schema Overview

FoodExpressDB contains **six tables** that form the core of the food delivery platform:

| Table | Description | Records |
|-------|-------------|---------|
| `Customer` | Customers who place orders | 10+ |
| `Restaurant` | Restaurants serving food | 10+ |
| `MenuItem` | Food items on each restaurant's menu | 30+ |
| `Rider` | Delivery riders | 10+ |
| `[Order]` | Customer orders placed through the platform | 10+ |
| `OrderItem` | Individual line items within each order | **200+** |

> **Note:** `Order` is a reserved SQL keyword. The table is always referenced as `[Order]` in T-SQL.

---

## Entity Relationships

| Relationship | Type | Description |
|-------------|------|-------------|
| Restaurant → MenuItem | One-to-Many | A restaurant has many menu items |
| Customer → Order | One-to-Many | A customer places many orders |
| Restaurant → Order | One-to-Many | A restaurant receives many orders |
| Rider → Order | One-to-Many | A rider delivers many orders |
| Order → OrderItem | One-to-Many | An order contains many order items |
| MenuItem → OrderItem | One-to-Many | A menu item appears in many order items |

---

## Table Definitions

### Customer
| Column | Data Type | Constraint |
|--------|-----------|-----------|
| CustomerID | INT | PK, IDENTITY(1,1) |
| FirstName | NVARCHAR(50) | NOT NULL |
| LastName | NVARCHAR(50) | NOT NULL |
| Phone | NVARCHAR(20) | — |
| Address | NVARCHAR(200) | — |

### Restaurant
| Column | Data Type | Constraint |
|--------|-----------|-----------|
| RestaurantID | INT | PK, IDENTITY(1,1) |
| Name | NVARCHAR(100) | NOT NULL |
| Cuisine | NVARCHAR(50) | — |
| City | NVARCHAR(50) | — |
| CapacityPerHour | INT | — |

### MenuItem
| Column | Data Type | Constraint |
|--------|-----------|-----------|
| ItemID | INT | PK, IDENTITY(1,1) |
| RestaurantID | INT | FK → Restaurant |
| ItemName | NVARCHAR(100) | NOT NULL |
| Price | DECIMAL(10,2) | CHECK (Price >= 0) |

### Rider
| Column | Data Type | Constraint |
|--------|-----------|-----------|
| RiderID | INT | PK, IDENTITY(1,1) |
| FirstName | NVARCHAR(50) | NOT NULL |
| LastName | NVARCHAR(50) | NOT NULL |
| VehicleType | NVARCHAR(20) | — |
| Status | NVARCHAR(20) | DEFAULT 'Offline' |

### [Order]
| Column | Data Type | Constraint |
|--------|-----------|-----------|
| OrderID | INT | PK, IDENTITY(1,1) |
| CustomerID | INT | FK → Customer |
| RestaurantID | INT | FK → Restaurant |
| RiderID | INT | FK → Rider |
| OrderDate | DATETIME2 | — |
| Status | NVARCHAR(20) | DEFAULT 'Placed' |
| TotalAmount | DECIMAL(10,2) | — |

### OrderItem
| Column | Data Type | Constraint |
|--------|-----------|-----------|
| OrderItemID | INT | PK, IDENTITY(1,1) |
| OrderID | INT | FK → [Order] |
| ItemID | INT | FK → MenuItem |
| Quantity | INT | CHECK (Quantity > 0) |

---

## Script Execution Guide

> ⚠️ **Execute scripts in the exact order shown below in SSMS.**

### Step 1 – Create the Database
**File:** `Scripts/01_CreateDatabase.sql`

1. Open SSMS and connect to your SQL Server instance
2. Open `01_CreateDatabase.sql`
3. Click **Execute** (F5)
4. ✅ Expected: Message `FoodExpressDB created successfully.`

### Step 2 – Create Tables
**File:** `Scripts/02_CreateTables.sql`

1. In SSMS, change the database context to `FoodExpressDB`
2. Open `02_CreateTables.sql`
3. Click **Execute** (F5)
4. ✅ Expected: 6 tables visible in Object Explorer under `FoodExpressDB > Tables`

### Step 3 – Insert Sample Data
**File:** `Scripts/03_InsertSampleData.sql`

1. Ensure you are connected to `FoodExpressDB`
2. Open `03_InsertSampleData.sql`
3. Click **Execute** (F5)
4. ✅ Expected: Data inserted into all 6 tables; OrderItem has 200+ rows

### Step 4 – Test Constraints
**File:** `Scripts/04_ConstraintTesting.sql`

1. Open `04_ConstraintTesting.sql`
2. Click **Execute** (F5)
3. ✅ Expected: PRINT messages showing PASSED/FAILED for each constraint test
4. ⚠️ Invalid inserts are expected to be caught by TRY/CATCH — this is intentional

### Step 5 – Run Verification Queries (Sprint 1 Demo)
**File:** `Scripts/05_VerificationQueries.sql`

1. Open `05_VerificationQueries.sql`
2. Run each section one by one
3. ✅ Capture screenshots of each result set for your Hexaware submission

---

## ER Diagram

See [`ERDiagram/FoodExpress_ER_Diagram.md`](ERDiagram/FoodExpress_ER_Diagram.md) for the full entity-relationship diagram.

---

*FoodExpress | Sprint 1 Database | Hexaware Training Capstone*
