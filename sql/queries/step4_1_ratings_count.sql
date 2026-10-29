-- Step 4.1. Claim: there are 100,000 ratings.
-- predicted: 1 row, value 100000
-- actual: 1 row, 100000. Gap: none; claim confirmed.
SELECT COUNT(*) AS n_ratings FROM ratings;
