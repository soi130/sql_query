--create a running total of standard_amt_usd (in the orders table) over order time with no date truncation

SELECT *,
    SUM(total_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders

-- create a running total of standard_amt_usd (in the orders table) over order time, 
-- but this time, date truncate occurred_at by year and partition by that same year-truncated occurred_at variable. 
-- Your final table should have three columns: One with the amount being added for each row, 
-- one for the truncated date, and a final column with the running total within each year.

SELECT DATE_TRUNC('year',occurred_at) AS year,
        standard_amt_usd,
        SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year',occurred_at) ORDER BY occurred_at) AS cum_sum

FROM orders
ORDER BY 1

-- RANK and ROW Number
-- Select the id, account_id, and total variable from the orders table, 
-- then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition. 
-- Your final table should have these four columns.

SELECT id,
        account_id,
        total,
        RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank 

FROM orders

-- others windows aggregate functions
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders

-- Now remove ORDER BY DATE_TRUNC('month',occurred_at) in each line of the query that contains it in the SQL Explorer below. Evaluate your new query, 
-- compare it to the results in the SQL Explorer above, and answer the subsequent quiz questions.

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id) AS max_std_qty
FROM orders

--Without 'ORDER BY' clause in a window function, the entire window (partition) in considered as a whole. 
--Thus all the values will be the same in each line in a partition.

---------------------------------------------------------------
-- Using windows alias in windows function

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))

--determine how the current order's total revenue ("total" meaning from sales of all types of paper) compares to the next order's total revenue.
SELECT id, 
        total_amt_usd,
        LEAD(total_amt_usd) OVER (ORDER BY id) AS lead,
        (LEAD(total_amt_usd) OVER (ORDER BY id)-total_amt_usd) AS lead_diff
FROM orders

-- NTILE FUNCTION --
--Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders. 
--Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased, 
-- and one of four levels in a standard_quartile column.
SELECT account_id,
        occurred_at,
        standard_qty,
        NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quantile
FROM orders

-- Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders. 
-- Your resulting table should have the account_id, the occurred_at time for each order, 
-- the total amount of gloss_qty paper purchased, and one of two levels in a gloss_half column.

SELECT account_id,
        occurred_at,
        gloss_qty,
        NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders

--Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders. 
--Your resulting table should have the account_id, the occurred_at time for each order, 
--the total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.

SELECT account_id,
        occurred_at,
        total_amt_usd,
        NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
FROM orders