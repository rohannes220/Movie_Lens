-- Step 4.2. Claim: the ratings come from 943 users.
-- predicted: 1 row, value 943
-- actual: 1 row, 943. Gap: none; claim confirmed.
SELECT COUNT(DISTINCT user_id) AS n_users FROM ratings;
