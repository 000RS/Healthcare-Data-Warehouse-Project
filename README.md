# 🏥 Healthcare Data Warehouse & Business Intelligence Solution

A comprehensive SQL-based Business Intelligence project demonstrating the complete design and implementation of a Healthcare Data Warehouse. This project showcases the full data warehousing lifecycle, including OLTP database design, OLAP star schema modelling, ETL development, and Data Quality validation to support business intelligence and analytical reporting.

---

##  Project Overview

Healthcare organizations generate large volumes of operational data every day. While OLTP databases efficiently manage daily transactions, they are not optimized for analytical reporting and decision-making.

This project transforms operational healthcare data into a structured data warehouse using ETL processes and a Star Schema design, enabling efficient reporting and business intelligence.

---

##  Objectives

- Design a normalized OLTP database for healthcare operations.
- Build an OLAP Data Warehouse using a Star Schema.
- Develop an ETL pipeline to extract, transform, and load data.
- Implement Data Quality validation and logging.
- Create a clean analytical database for reporting.

---

##  Key Features

- ✅ OLTP Database Design
- ✅ OLAP Star Schema Design
- ✅ ETL Pipeline
- ✅ Data Quality Validation
- ✅ Data Quality Logging
- ✅ Fact & Dimension Tables
- ✅ SQL-Based Implementation

---

##  Technologies Used

| Category | Technologies |
 ------------------------
| Database | MySQL |
| Language | SQL |
| Concepts | OLTP, OLAP, ETL |
| Data Warehousing | Star Schema |
| Data Quality | Validation & Logging |
| Version Control | Git & GitHub |

---

## 📂 Repository Structure

```text
healthcare-bi-data-warehouse/
│
├── README.md
├── LICENSE
│
├── sql/
│   ├── 01_HospitalOLTP.sql
│   ├── 02_HospitalOLAP.sql
│   ├── 03_etl.sql
│   └── 04_dirty+dqlog.sql
│
├── docs/
│   └── Presentation.pptx
│
└── screenshots/
    ├── OLTP.png
    ├── OLAP.png
    ├── DQLOG.png
    ├── VALIDATION.png
    |-- FACT TABLE.png
```

---

#  OLTP Database

The OLTP database manages operational healthcare data including:

- Departments
- Doctors
- Patients
- Rooms
- Appointments
- Admissions
- Treatments
- Billing

The database is fully normalized and uses primary and foreign key relationships to maintain data integrity.

---

#  OLAP Data Warehouse

The OLAP database is designed using a Star Schema to support analytical reporting and business intelligence.

The warehouse enables analysis of:

- Patient Admissions
- Treatment Costs
- Department Performance
- Billing Trends
- Healthcare Operations

---

#  ETL Process

The ETL pipeline follows these stages:

1. Extract operational data from the OLTP database.
2. Transform and standardize the data.
3. Apply Data Quality validation rules.
4. Log invalid records into the Data Quality Log.
5. Load clean data into the Data Warehouse.

---

#  Data Quality Management

The project applies multiple Data Quality rules to improve data reliability.

Examples include:

- Reject invalid records
- Correct inconsistent formatting
- Validate required fields
- Log failed records
- Preserve clean records for analysis

---

#  Project Screenshots

## OLTP Entity Relationship Diagram

*(Insert screenshot from the `screenshots` folder.)*

---

## OLAP Star Schema

*(Insert screenshot from the `screenshots` folder.)*

---

## ETL Process

*(Insert screenshot from the `screenshots` folder.)*

---

## Data Quality Log

*(Insert screenshot from the `screenshots` folder.)*

---

#  Skills Demonstrated

- SQL Development
- Database Design
- Data Warehousing
- ETL Development
- Star Schema Modelling
- Data Quality Management
- Business Intelligence
- Relational Database Design
- Data Transformation

---

#  Future Enhancements

- Build interactive Power BI dashboards
- Automate ETL workflows
- Deploy the warehouse on Snowflake
- Add incremental data loading
- Expand analytical reporting capabilities

---

#  Author

**Rehaan**

Bachelor of Computing Systems  
Business Intelligence Major  
Unitec Institute of Technology

---

## ⭐ If you found this project interesting, feel free to explore the SQL scripts and documentation included in this repository.
