--What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

WITH top_10_acc AS (SELECT o.account_id, SUM(total_amt_usd) ltv
                    FROM orders o
                    GROUP BY 1
                    ORDER BY 2 DESC
                    LIMIT 10)
SELECT AVG(ltv) average_ltv
FROM top_10_acc
                    
                    
                 