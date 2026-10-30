-- Step 4.3. Claim: the ratings are on 1,682 movies.
-- predicted: 1 row, value 1682
-- actual: 1 row, 1682. Gap: none; claim confirmed.
SELECT COUNT(DISTINCT movie_id) AS n_movies FROM ratings;
