-- Step 4.5. Claim: every user has rated at least 20 movies.
-- Lists users who break the claim, so an empty result confirms it.
-- predicted: 0 rows
-- actual: 0 rows. Gap: none; no user has fewer than 20 ratings, so the claim holds.
SELECT user_id, COUNT(*) AS n_ratings
FROM ratings
GROUP BY user_id
HAVING COUNT(*) < 20;
