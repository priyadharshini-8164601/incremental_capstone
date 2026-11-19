# FoodExpress – Food Delivery Platform

## Project Overview

**FoodExpress** is a console-based Food Delivery Platform developed as a capstone project for the Hexaware Training Programme.

The platform is built for a fictional company called **Urban Bite Technologies** and connects three main participants:

| Participant | Role |
|------------|------|
| 🧑 **Customer** | Browses restaurants and places food orders |
| 🏪 **Restaurant** | Manages menus and receives customer orders |
| 🛵 **Rider** | Delivers orders to customers |

---

## Main Functionalities

1. **Rider Assignment** – Automated rider assignment based on proximity and workload
2. **Restaurant Order Queue** – Manage order queues within configurable hourly capacity
3. **Delivery Estimates** – Estimate delivery time using historical data
4. **Weekly Payouts** – Automated and auditable weekly restaurant payout calculations

---

## Technology Stack

| Component | Technology |
|-----------|-----------|
| Database | Microsoft SQL Server |
| DB Tool | SQL Server Management Studio (SSMS) |
| SQL Language | T-SQL |

---

## Project Structure

```
FoodExpress/
│
├── Database/
│   ├── Scripts/
│   │   ├── 01_CreateDatabase.sql       ← Creates FoodExpressDB
│   │   ├── 02_CreateTables.sql         ← DDL for all 6 tables + constraints + indexes
│   │   ├── 03_InsertSampleData.sql     ← Sample data (200+ OrderItems)
│   │   ├── 04_ConstraintTesting.sql    ← Constraint verification with TRY/CATCH
│   │   └── 05_VerificationQueries.sql  ← Sprint 1 review queries
│   │
│   ├── ERDiagram/
│   │   ├── FoodExpress_ER_Diagram.md   ← Mermaid ER diagram (text)
│   │   └── FoodExpress_ER_Diagram.png  ← Visual ER diagram image
│   │
│   └── README.md                       ← Database setup and execution guide
│
└── README.md                           ← This file
```

---

## Sprints

| Sprint | Scope | Status |
|--------|-------|--------|
| **Sprint 1 (Days 1–2)** | Database design, DDL, sample data, constraints | ✅ In Progress |
| Sprint 2 | Application layer (Python/Java/C#) | ⬜ Not started |
| Sprint 3+ | Business logic, APIs, testing | ⬜ Not started |

---

## Getting Started

See [`Database/README.md`](Database/README.md) for full instructions on setting up and running the database scripts.

---

*Capstone Project | Hexaware Training Programme | FoodExpress – Urban Bite Technologies*
