--uses UNION ALL on two instances (and selecting all columns) of the accounts table.

SELECT *
FROM accounts a1
UNION ALL
SELECT *
FROM accounts a2

-- Add a WHERE clause to each of the tables that you unioned in the query above, 
-- filtering the first table where name equals Walmart and filtering the second table where name equals Disney. 

SELECT *
FROM accounts a1
WHERE a1.name = 'Walmart'

UNION ALL

SELECT *
FROM accounts a2
WHERE a2.name = 'Disney'

-- Perform the union in your first query (under the Appending Data via UNION header) in a common table expression 
-- and name it double_accounts. Then do a COUNT the number of times a name appears in the double_accounts table. 
-- If you do this correctly, your query results should have a count of 2 for each name.
WITH double_accounts AS (SELECT *
                            FROM accounts a1
                            UNION ALL
                            SELECT *
                            FROM accounts a2)
SELECT double_accounts.name,
        count(*)
FROM double_accounts
GROUP BY 1
