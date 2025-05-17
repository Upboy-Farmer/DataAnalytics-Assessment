WITH transaction_summary AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) AS total_confirmed_amount
    FROM dbo.savings_savingsaccount s
    GROUP BY s.owner_id
),
user_tenure AS (
    SELECT 
        u.id AS customer_id,
        u.name,
        DATEDIFF(MONTH, u.date_joined, GETDATE()) AS tenure_months
    FROM dbo.users_customuser u
)
SELECT 
    SUBSTRING(u.customer_id, 2, LEN(u.customer_id)) AS customer_id,
    u.name,
    u.tenure_months,
    ts.total_transactions,
    CAST((
        (ts.total_confirmed_amount * 0.001 / 100)  -- profit in naira
        / NULLIF(u.tenure_months, 0)               -- prevent divide-by-zero
    ) * 12 AS DECIMAL(10, 2)) AS estimated_clv
FROM user_tenure u
INNER JOIN transaction_summary ts ON u.customer_id = ts.owner_id
ORDER BY estimated_clv DESC;
