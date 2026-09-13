# E-Commerce Sales & Customer Analytics

An end-to-end e-commerce data analytics project built using PostgreSQL, SQL, Power BI and DAX.

The project covers database design, realistic transaction data generation, data-quality validation, business analysis using SQL, KPI development and interactive Power BI visualization.

# Project Overview

This project simulates an e-commerce platform and analyzes customer behavior, sales performance, products, shopping sessions and payment activity.

The database contains 12 related tables representing the major entities involved in an e-commerce transaction lifecycle.

The project follows a realistic transaction flow:

Shopping Session → Cart → Order → Order Items → Payment

# Tech Stack

- PostgreSQL
- SQL
- Power BI
- DAX
- DBeaver
- Git & GitHub

# Database Schema

The project consists of 12 tables:

1. `user`
2. `user_address`
3. `user_payment`
4. `product_category`
5. `product_inventory`
6. `discount`
7. `product`
8. `shopping_session`
9. `cart_item`
10. `order_details`
11. `order_items`
12. `payment_details`

The tables are connected using primary and foreign-key relationships to represent customers, products, shopping sessions, orders and payments.

# Data Quality Validation

Data-quality checks were performed before analysis to validate the database.

The validation included:

- Row-count verification
- Foreign-key integrity checks
- Orphan-record detection
- Invalid quantity and price checks
- Orders without order items
- Orders without payments
- Payment amount consistency
- Converted vs abandoned shopping sessions
- Duplicate product and order checks

All final validation checks passed without data inconsistencies.

# SQL Analysis

A total of 50 business-oriented SQL queries were developed.

The analysis covers:

## Customer Analysis

- Registered customers
- Customer order frequency
- Repeat customers
- Customer spending
- Customer segmentation

## Sales Analysis

- Total orders
- Total revenue
- Average order value
- Monthly sales trends
- Revenue contribution
- Top-performing products
- Category performance

## Shopping Behavior

- Shopping sessions
- Cart activity
- Cart abandonment
- Abandoned cart value
- Customer purchasing behavior

## Payment Analysis

- Payment status
- Payment success rate
- Payment distribution
- Payment amount consistency

## Advanced SQL

The project also uses advanced SQL concepts including:

- Common Table Expressions (CTEs)
- Window functions
- `ROW_NUMBER()`
- `RANK()`
- `DENSE_RANK()`
- `LAG()`
- Aggregate functions
- Conditional aggregation
- Percentile-based analysis
- Subqueries

# Power BI Dashboard

The final Power BI dashboard provides an interactive view of sales and customer performance.

## Key KPIs

- Total Customers
- Total Orders
- Total Revenue
- Average Order Value
- Repeat Customer Rate
- Cart Abandonment Rate
- Payment Success Rate

### Dashboard Visuals

- Monthly Sales Trend
- Revenue by Category
- Top 5 Products by Revenue
- Customer Segmentation
- Payment Status

The dashboard also includes filters for:

- Month
- Product Category

![E-Commerce Dashboard](images/ecommerce_dashboard.png)

---

## Key Results

Based on the final dataset:

| Metric | Result |
|---|---:|
| Total Customers | 50 |
| Total Orders | 65 |
| Total Revenue | ₹1.75M |
| Average Order Value | ₹26.99K |
| Repeat Customer Rate | 40.00% |
| Cart Abandonment Rate | 27.78% |
| Payment Success Rate | 84.62% |

---

## Project Structure

```text
ecommerce-sql-project/
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_data_quality_checks.sql
│   └── 03_ecommerce_analysis.sql
│
├── dashboard/
│   └── ecommerce_dashboard.pbix
│
├── images/
│   └── ecommerce_dashboard.png
│
└── README.md