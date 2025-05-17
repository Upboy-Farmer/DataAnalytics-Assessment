WITH latest_transactions AS (
    SELECT 
        s.owner_id,
        MAX(s.created_on) AS last_transaction_date
    FROM dbo.savings_savingsaccount s
    GROUP BY s.owner_id
)
SELECT 
    SUBSTRING(p.id, 2, LEN(p.id)) AS plan_id,
    SUBSTRING(p.owner_id, 2, LEN(p.owner_id)) AS owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    CONVERT(DATE, lt.last_transaction_date) AS last_transaction_date,
    DATEDIFF(DAY, lt.last_transaction_date, GETDATE()) AS inactivity_days
FROM dbo.plans_plan p
LEFT JOIN latest_transactions lt ON p.owner_id = lt.owner_id
WHERE 
    p.is_deleted = 0
    AND p.is_archived = 0
    AND lt.last_transaction_date IS NOT NULL
    AND DATEDIFF(DAY, lt.last_transaction_date, GETDATE()) > 365;
