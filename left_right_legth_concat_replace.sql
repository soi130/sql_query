--Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.


SELECT primary_poc,
        LEFT(primary_poc, STRPOS(primary_poc,' ') -1) AS poc_name, 
        RIGHT(primary_poc,(LENGTH(primary_poc)-STRPOS(primary_poc,' '))) AS poc_last 

FROM accounts

--Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
SELECT * ,
    LEFT(name, STRPOS(name,' ')-1) AS rep_name, 
    RIGHT(name, LENGTH(name)-STRPOS(name,' ')) AS rep_last

FROM sales_reps

--Each company in the accounts table wants to create an email address for each primary_poc. 
--The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.

SELECT * , 
    (LEFT(primary_poc, STRPOS(primary_poc,' ')-1)||'.'||RIGHT(primary_poc, LENGTH(primary_poc)-STRPOS(primary_poc,' '))||'@'||REPLACE(name,' ','')||'.com') AS poc_email
FROM accounts

-- We would also like to create an initial password, which they will change after their first log in. 
-- The first password will be the first letter of the primary_poc's first name (lowercase), 
-- then the last letter of their first name (lowercase), the first letter of their last name (lowercase), 
-- the last letter of their last name (lowercase), the number of letters in their first name, 
-- the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.

WITH email AS (SELECT * ,
               LEFT(primary_poc, STRPOS(primary_poc,' ')-1) AS rep_name,
               RIGHT(primary_poc, LENGTH(primary_poc)-STRPOS(primary_poc,' ')) AS rep_last,       
               (LEFT(primary_poc, STRPOS(primary_poc,' ')-1)||'.'||RIGHT(primary_poc, LENGTH(primary_poc)-STRPOS(primary_poc,' '))||'@'||REPLACE(name,' ','')||'.com') AS poc_email
                FROM accounts)
         
SELECT LOWER(LEFT(rep_name,1))||LOWER(RIGHT(rep_name,1))||LOWER(LEFT(rep_last,1))||LOWER(RIGHT(rep_last,1))||LENGTH(rep_name)||LENGTH(rep_last)||UPPER(REPLACE(name,' ','')) AS pw
FROM email


