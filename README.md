
# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository!
This project demonstrates a comprehensive data warehousing and analytics solution, from building a data warehouse to generating actionable insights. Designed as a portfolio project, it highlights industry best practices in data engineering and analytics.

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze** (raw), **Silver** (int), and **Gold** (prm) layers:
![Data Architecture](<docs/Data warehourse architecture.png>)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleaning, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

🎯 This repository is an excellent resource for professionals and students looking to showcase expertise in:
- SQL Development
- Data Architect
- Data Engineering  
- ETL Pipeline Developer  
- Data Modeling  
- Data Analytics  

### Roadmap
To follow all the steps done on this project, click on this Notion's link : [Data Warehouse Roadmap](https://app.notion.com/p/SQL-Data-Warehouse-Project-93be6949a262823b87ca01c6a1fb35cf?source=copy_link)

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analysis)

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                                   # Raw datasets used for the project (ERP and CRM data)
│
├── docs/                                       # Project documentation and architecture details
│   ├── Data warehouse architecture.drawio      # Draw.io file shows the project's architecture
│   ├── Data warehouse architecture.png         # PNG file shows the project's architecture
│   ├── naming_conventions.md                   # PNG file shows the project's architecture
│
├── scripts/                                    # All the SQL Scripts used for the project
│   ├── init_database.sql                       # SQL Script that create our 'DataWarehouse' database and the associate schemas
├── README.md                                   # Project overview and instructions
├── LICENSE                                     # License information for the repository
├── .gitignore                                  # Files and directories to be ignored by Git
```
---

## ✍️ Git rules

### Current workflow

This project is currently maintained by a single developer, so all work is committed directly to the `main` branch. No feature branches are used at this stage.

> **Important:** as soon as another contributor joins the project, working directly on `main` is no longer allowed. Every change must then be developed on a dedicated branch and merged through a pull request.

### Branch naming convention

Once branching becomes mandatory, branches must follow the format `<type>/<short-description>`, written in lowercase with words separated by hyphens.

| Type        | Usage                                  | Example                    |
|-------------|----------------------------------------|----------------------------|
| `feature/`  | New feature                            | `feature/user-login`       |
| `fix/`      | Bug fix                                | `fix/null-pointer-parser`  |
| `hotfix/`   | Urgent fix on production               | `hotfix/payment-crash`     |
| `docs/`     | Documentation only                     | `docs/update-readme`       |
| `refactor/` | Code restructuring without new behavior| `refactor/api-client`      |
| `test/`     | Adding or updating tests               | `test/auth-service`        |

### Commit message convention

Commit messages follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<optional scope>): <short description>
```

Rules:
- Use the **imperative mood** ("add", not "added" or "adds").
- Keep the subject line **under 72 characters**.
- Do not end the subject line with a period.
- Write the short description in **French**.

Accepted types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.

Examples:
```
feat(auth): add password reset endpoint
fix(parser): handle empty input correctly
docs: update installation instructions
chore: bump dependencies
```
