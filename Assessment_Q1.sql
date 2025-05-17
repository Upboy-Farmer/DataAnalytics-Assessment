
WITH deposit_totals AS (
    SELECT owner_id, SUM(confirmed_amount) AS total_confirmed
    FROM dbo.savings_savingsaccount
    GROUP BY owner_id
)
SELECT 
    SUBSTRING(u.id, 2, LEN(u.id)) AS owner_id,
    u.name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    CAST(ROUND(dt.total_confirmed / 100.0, 2) AS DECIMAL(10, 2)) AS total_deposit
FROM dbo.users_customuser u
LEFT JOIN dbo.plans_plan p ON u.id = p.owner_id
LEFT JOIN deposit_totals dt ON u.id = dt.owner_id
GROUP BY u.id, u.name, dt.total_confirmed
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) >= 1
ORDER BY total_deposit DESC;
