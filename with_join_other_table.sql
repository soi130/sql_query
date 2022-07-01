-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, 
-- how many web_events did they have for each channel?
WITH    ltv AS (SELECT account_id account_id, SUM(total_amt_usd) ltv
                FROM orders o
                GROUP BY 1),
        max_ltv AS (SELECT MAX(ltv) max_ltv
                FROM ltv),
        max_ltv_account AS (SELECT *
                        FROM ltv
                        JOIN max_ltv
                            ON  ltv.ltv = max_ltv.max_ltv
                        JOIN web_events w
                            ON w.account_id = ltv.account_id)

SELECT max_ltv_account.channel, count(*) 
FROM max_ltv_account
GROUP BY 1
ORDER BY 2 DESC
;
