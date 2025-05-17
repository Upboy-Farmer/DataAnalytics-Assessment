WITH transaction_stats AS (
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,
        DATEDIFF(MONTH, MIN(s.created_on), MAX(s.created_on)) + 1 AS months_active
    FROM dbo.savings_savingsaccount s
    GROUP BY s.owner_id
),
avg_tx_per_user AS (
    SELECT
        ts.owner_id,
        CAST(ts.total_transactions * 1.0 / ts.months_active AS DECIMAL(10, 2)) AS avg_tx_per_month
    FROM transaction_stats ts
),
categorized AS (
    SELECT 
        CASE 
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_tx_per_month
    FROM avg_tx_per_user
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    CAST(AVG(avg_tx_per_month) AS DECIMAL(10, 1)) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        WHEN frequency_category = 'Low Frequency' THEN 3
    END;

