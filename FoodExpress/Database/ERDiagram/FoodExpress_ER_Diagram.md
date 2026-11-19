# FoodExpress – Entity Relationship Diagram

## Visual ER Diagram

![FoodExpress ER Diagram](FoodExpress_ER_Diagram.png)

---

## Mermaid ER Diagram (Text Format)

```mermaid
erDiagram
    CUSTOMER {
        int CustomerID PK "Auto-generated Primary Key"
        nvarchar50 FirstName "Customer first name"
        nvarchar50 LastName "Customer last name"
        nvarchar20 Phone "Contact phone number"
        nvarchar200 Address "Delivery address"
    }

    RESTAURANT {
        int RestaurantID PK "Auto-generated Primary Key"
        nvarchar100 Name "Restaurant name"
        nvarchar50 Cuisine "Type of cuisine"
        nvarchar50 City "City where restaurant is located"
        int CapacityPerHour "Max orders processed per hour"
    }

    MENUITEM {
        int ItemID PK "Auto-generated Primary Key"
        int RestaurantID FK "References Restaurant"
        nvarchar100 ItemName "Name of the food item"
        decimal Price "Item price - CHECK Price >= 0"
    }

    RIDER {
        int RiderID PK "Auto-generated Primary Key"
        nvarchar50 FirstName "Rider first name"
        nvarchar50 LastName "Rider last name"
        nvarchar20 VehicleType "Bike / Scooter / Bicycle"
        nvarchar20 Status "DEFAULT Offline - Available / Busy / Offline"
    }

    ORDER {
        int OrderID PK "Auto-generated Primary Key"
        int CustomerID FK "References Customer"
        int RestaurantID FK "References Restaurant"
        int RiderID FK "References Rider"
        datetime2 OrderDate "Date and time order was placed"
        nvarchar20 Status "DEFAULT Placed - Placed / Preparing / Delivered / Cancelled"
        decimal TotalAmount "Total order value"
    }

    ORDERITEM {
        int OrderItemID PK "Auto-generated Primary Key"
        int OrderID FK "References Order"
        int ItemID FK "References MenuItem"
        int Quantity "Number of units - CHECK Quantity > 0"
    }

    RESTAURANT ||--o{ MENUITEM : "has"
    CUSTOMER ||--o{ ORDER : "places"
    RESTAURANT ||--o{ ORDER : "receives"
    RIDER ||--o{ ORDER : "delivers"
    ORDER ||--o{ ORDERITEM : "contains"
    MENUITEM ||--o{ ORDERITEM : "appears in"
```

---

## Entities and Attributes Summary

| Entity | PK | FKs | Key Constraints |
|--------|-----|-----|----------------|
| **Customer** | CustomerID | — | — |
| **Restaurant** | RestaurantID | — | — |
| **MenuItem** | ItemID | RestaurantID | CHECK Price >= 0 |
| **Rider** | RiderID | — | DEFAULT Status = 'Offline' |
| **Order** | OrderID | CustomerID, RestaurantID, RiderID | DEFAULT Status = 'Placed' |
| **OrderItem** | OrderItemID | OrderID, ItemID | CHECK Quantity > 0 |

---

## Relationships Summary

| # | From | To | Cardinality | Relationship Label |
|---|------|----|------------|-------------------|
| 1 | Restaurant | MenuItem | 1 → Many | has |
| 2 | Customer | Order | 1 → Many | places |
| 3 | Restaurant | Order | 1 → Many | receives |
| 4 | Rider | Order | 1 → Many | delivers |
| 5 | Order | OrderItem | 1 → Many | contains |
| 6 | MenuItem | OrderItem | 1 → Many | appears in |

> **Cardinality Notation:** `||--o{` = one-to-many (zero or more on the many side)

---

## Notes

- `Order` is a reserved SQL keyword. The table is named `[Order]` in SQL Server.
- All primary keys use `IDENTITY(1,1)` for automatic generation.
- `OrderItem` is the highest-volume table — designed to hold 200+ rows.
- The ER diagram follows the **crow's foot notation** standard.

---

*FoodExpress | Sprint 1 | Hexaware Training Capstone*
