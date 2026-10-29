-- Q4. For each genre, the number of ratings and the mean rating.
-- predicted: 19 rows (one per genre in u.genre)
-- actual: 19 rows. Gap: none; every genre has at least one rating (unknown has only 10).
SELECT g.genre_name,
       COUNT(*) AS n_ratings,
       ROUND(AVG(r.rating), 3) AS mean_rating
FROM ratings r
JOIN movie_genres mg ON mg.movie_id = r.movie_id
JOIN genres g ON g.genre_id = mg.genre_id
GROUP BY g.genre_id, g.genre_name
ORDER BY n_ratings DESC;