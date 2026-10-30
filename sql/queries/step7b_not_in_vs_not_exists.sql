-- Step 7b: NOT IN versus NOT EXISTS
-- Expected: NOT IN = 0 rows, NOT EXISTS = 1 row

-- Query 1: NOT IN
SELECT movie_id, movie_title
FROM movies
WHERE release_date NOT IN (
    SELECT release_date
    FROM movies
);

-- Query 2: NOT EXISTS
SELECT m.movie_id, m.movie_title
FROM movies m
WHERE NOT EXISTS (
    SELECT 1
    FROM movies m2
    WHERE m2.release_date = m.release_date
);
