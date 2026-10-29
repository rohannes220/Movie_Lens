-- Step 4.4. Claim: users and movies are numbered consecutively from 1.
-- Consecutive with no gaps means MIN = 1 and MAX = COUNT = COUNT(DISTINCT).
-- predicted: 2 rows, both with min 1, max = count, consecutive = 1
-- actual: 2 rows; users 943 (1..943), movies 1682 (1..1682), consecutive = 1 for both. Gap: none; claim confirmed.
SELECT 'users' AS tbl, COUNT(*) AS n, MIN(user_id) AS min_id, MAX(user_id) AS max_id,
       (MIN(user_id) = 1 AND MAX(user_id) = COUNT(*)
        AND COUNT(DISTINCT user_id) = COUNT(*)) AS consecutive
FROM users
UNION ALL
SELECT 'movies', COUNT(*), MIN(movie_id), MAX(movie_id),
       (MIN(movie_id) = 1 AND MAX(movie_id) = COUNT(*)
        AND COUNT(DISTINCT movie_id) = COUNT(*))
FROM movies;
