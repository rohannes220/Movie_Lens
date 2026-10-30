-- Step 6a: CTE version
-- Movies with 30+ ratings whose average rating is
-- at least 0.5 above the average for a genre.

WITH genre_avg AS (
    SELECT
        mg.genre_id,
        AVG(r.rating) AS genre_avg_rating
    FROM ratings r
    JOIN movie_genres mg ON r.movie_id = mg.movie_id
    GROUP BY mg.genre_id
),
movie_avg AS (
    SELECT
        m.movie_id,
        m.movie_title,
        AVG(r.rating) AS movie_avg_rating,
        COUNT(*) AS total_ratings
    FROM movies m
    JOIN ratings r ON m.movie_id = r.movie_id
    GROUP BY m.movie_id, m.movie_title
    HAVING COUNT(*) >= 30
),
movie_comparison AS (
    SELECT
        ma.movie_title,
        g.genre_name,
        ma.movie_avg_rating,
        ga.genre_avg_rating,
        ma.total_ratings
    FROM movie_avg ma
    JOIN movie_genres mg ON ma.movie_id = mg.movie_id
    JOIN genres g ON mg.genre_id = g.genre_id
    JOIN genre_avg ga ON mg.genre_id = ga.genre_id
),
final_result AS (
    SELECT *
    FROM movie_comparison
    WHERE movie_avg_rating >= genre_avg_rating + 0.5
)
SELECT
    movie_title,
    genre_name,
    ROUND(movie_avg_rating, 2) AS movie_avg_rating,
    ROUND(genre_avg_rating, 2) AS genre_avg_rating,
    total_ratings
FROM final_result
ORDER BY movie_avg_rating DESC, movie_title, genre_name;
