--For the account that purchased the most (in total over their lifetime as a customer) standard_qty paper, 
--how many accounts still had more in total purchases?

WITH standard_sum AS (SELECT account_id, SUM(standard_qty) standard_qty, SUM(total) total
                      FROM orders o
                      GROUP BY 1) ,
     standard_max AS (SELECT MAX(standard_qty)
                      FROM standard_sum),
      max_account AS (SELECT *
                      FROM standard_sum
                      JOIN standard_max
                          ON standard_sum.standard_qty = standard_max.max)
    
                    
SELECT *
FROM standard_sum
WHERE standard_sum.total > (SELECT total FROM max_account)
    


              

