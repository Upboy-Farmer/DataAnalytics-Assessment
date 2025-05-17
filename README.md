# Data Analyst Assessment – SQL Solutions

This repository presents solutions to a four-part SQL-based data analytics assessment. Each question addresses a real-world business scenario, applying relational database logic to solve problems across customer insights, transaction analysis, account monitoring, and customer value estimation.

All queries are written in **T-SQL for Microsoft SQL Server** and are designed to be efficient, scalable, and production-ready.

---

## Question 1 – High-Value Customers with Multiple Products

### Objective
Identify users who:
- Have at least one funded **savings plan**
- Have at least one funded **investment plan**
- Have made confirmed deposits into their savings accounts

### Approach
- Joined `users_customuser`, `plans_plan`, and `savings_savingsaccount` tables using `owner_id`
- Used conditional aggregation to count users with at least one savings and one investment plan
- Aggregated confirmed deposit amounts and converted them from **kobo to naira**
- Applied `HAVING` to filter for users with both plan types
- Cleaned user ID format by stripping prefix characters using `SUBSTRING`

---

## Question 2 – Transaction Frequency Analysis

### Objective
Segment users by how frequently they transact based on the average number of transactions per month.

### Categories
- **High Frequency**: ≥ 10 transactions/month  
- **Medium Frequency**: 3–9 transactions/month  
- **Low Frequency**: ≤ 2 transactions/month

### Approach
- Calculated each user’s active duration using `DATEDIFF(MONTH, MIN(created_on), MAX(created_on)) + 1`
- Aggregated transaction counts and computed average transactions per month
- Used a `CASE` statement to assign frequency categories
- Grouped by frequency category to report:
  - Number of users in each group
  - Their average monthly transaction count (rounded to 1 decimal place)

---

## Question 3 – Account Inactivity Alert

### Objective
Identify **active savings or investment plans** that have had **no inflow transactions in the past 365 days**.

### Approach
- Defined an active plan where `is_deleted = 0` and `is_archived = 0`
- Pulled the most recent transaction date per user from `savings_savingsaccount`
- Joined back to `plans_plan` using `owner_id`
- Calculated the number of days since the last transaction
- Filtered for plans with **inactivity greater than 365 days**
- Cleaned and formatted `plan_id` and `owner_id` values
- Displayed transaction date using `CONVERT(DATE, ...)` to remove time

---

## Question 4 – Customer Lifetime Value (CLV) Estimation

### Objective
Estimate customer lifetime value (CLV) using a simplified profitability model based on tenure and transaction volume.

### CLV Formula
```
CLV = (total_transactions / tenure_months) * 12 * 0.001
```

### Approach
- Calculated **account tenure** using `DATEDIFF(MONTH, date_joined, GETDATE())`
- Aggregated **confirmed transaction volume** from `savings_savingsaccount`
- Applied the given formula using:
  - 0.1% profit per transaction (`0.001`)
  - Annualized the result across a 12-month period
- Converted values from **kobo to naira**
- Handled zero-tenure edge cases safely using `NULLIF` to avoid divide-by-zero errors

---

## 🔧 Technical Summary

- **SQL Engine**: Microsoft SQL Server (T-SQL)
- **Tools Used**: SQL Server Management Studio (SSMS)
- **Design Focus**: Performance, readability, data integrity, and formatting consistency
