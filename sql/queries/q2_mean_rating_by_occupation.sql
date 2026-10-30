-- Q2. Mean rating per occupation, counting only occupations with at least 50 raters.
-- WHERE filters rows before grouping; HAVING filters groups after.
-- "At least 50 raters" is a count over each occupation's group, so it goes in
-- HAVING; WHERE cannot see an aggregate. No WHERE condition is needed, because
-- the schema already guarantees every rating is 1-5 and not NULL.
-- predicted: 11 rows (estimate written after the first run; reasoning: 943 users / 21 occupations ≈ 45 each, assumed about half reach 50)
-- actual: 7 rows. Gap: predicted 11, got 7. Users are spread more unevenly than assumed: student (196) and other (105) hold a third of all users, so most occupations fall below 50.

SELECT u.occupation,
       COUNT(DISTINCT u.user_id) AS n_raters,
       ROUND(AVG(r.rating), 3) AS mean_rating
FROM ratings r
JOIN users u ON u.user_id = r.user_id
GROUP BY u.occupation
HAVING COUNT(DISTINCT u.user_id) >= 50
ORDER BY mean_rating DESC;
