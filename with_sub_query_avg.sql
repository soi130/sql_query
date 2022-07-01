-- What is the lifetime average amount spent in terms of total_amt_usd, 
-- including only the companies that spent more per order, on average, than the average of all orders.

WITH avg_per_order AS (SELECT AVG(total_amt_usd) avg_all
                      FROM orders o),
      higher_comp AS (SELECT o.account_id, AVG(total_amt_usd) avg_ltm
                        FROM orders o
                     GROUP BY 1
                     HAVING AVG(total_amt_usd) > (SELECT * FROM avg_per_order))
                     
 SELECT AVG(avg_ltm) 
 FROM higher_comp
 ;
              
     
                    
                    
                 