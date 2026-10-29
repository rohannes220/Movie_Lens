-- Q1. Which ten movies have the most ratings, and how many does each have?
-- Ties: RANK() gives tied movies the same rank, and we keep every movie ranked
-- 10 or better, so a tie at 10th place returns more than 10 rows instead of
-- LIMIT 10 silently dropping a tied movie.
-- predicted: 10 rows (more only if there is a tie at 10th place)
-- actual: 10 rows (Star Wars 583 down to Independence Day 429). Gap: none; no tie at 10th place, so RANK() kept exactly 10.
WITH counts AS (
    SELECT m.movie_id, m.movie_title, COUNT(*) AS n_ratings
    FROM ratings r
    JOIN movies m ON m.movie_id = r.movie_id
    GROUP BY m.movie_id, m.movie_title
),
ranked AS (
    SELECT *, RANK() OVER (ORDER BY n_ratings DESC) AS rnk
    FROM counts
)
SELECT rnk, movie_id, movie_title, n_ratings
FROM ranked
WHERE rnk <= 10
ORDER BY rnk, movie_title;
