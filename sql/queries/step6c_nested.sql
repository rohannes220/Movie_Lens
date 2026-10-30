-- Step 6c: Nested subquery version
-- Same question as Step 6a, without CTEs.

SELECT
    ma.movie_title,
    g.genre_name,
    ROUND(ma.movie_avg_rating, 2) AS movie_avg_rating,
    ROUND(ga.genre_avg_rating, 2) AS genre_avg_rating,
    ma.total_ratings
FROM (
    SELECT
        m.movie_id,
        m.movie_title,
        AVG(r.rating) AS movie_avg_rating,
        COUNT(*) AS total_ratings
    FROM movies m
    JOIN ratings r ON m.movie_id = r.movie_id
    GROUP BY m.movie_id, m.movie_title
    HAVING COUNT(*) >= 30
) AS ma
JOIN movie_genres mg
    ON ma.movie_id = mg.movie_id
JOIN genres g
    ON mg.genre_id = g.genre_id
JOIN (
    SELECT
        g.genre_id,
        AVG(r.rating) AS genre_avg_rating
    FROM ratings r
    JOIN movie_genres mg
        ON r.movie_id = mg.movie_id
    JOIN genres g
        ON mg.genre_id = g.genre_id
    GROUP BY g.genre_id
) AS ga
    ON g.genre_id = ga.genre_id
WHERE ma.movie_avg_rating >= ga.genre_avg_rating + 0.5
ORDER BY ma.movie_avg_rating DESC, ma.movie_title, g.genre_name;
