-- find each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
SELECT *
FROM accounts a
FULL JOIN sales_reps r
ON a.sales_rep_id = r.id

-- find each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)
SELECT *
FROM accounts a
FULL JOIN sales_reps r
ON a.sales_rep_id = r.id
WHERE a.sales_rep_id IS NULL OR r.id IS NULL 