-- Q4 (part 2). Total of the per-genre rating counts, compared with 100,000.
-- predicted: 1 row, about 172,000 (100,000 ratings x 1.72 genres per movie,
--   from 2,893 movie_genres rows / 1,682 movies)
-- actual: 1 row, 212,595 genre-rating rows vs 100,000 ratings (2.126 genres per rating).
-- Gap: predicted 172,000, got 212,595. Each rating is counted once per genre of
--   its movie, so the total exceeds 100,000. The prediction used genres per
--   movie (1.72), but the real multiplier is genres per rating (2.126): heavily
--   rated movies tend to have more genres, which pulls the per-rating average up.
SELECT COUNT(*) AS genre_rating_rows,
       (SELECT COUNT(*) FROM ratings) AS ratings,
       ROUND(1.0 * COUNT(*) / (SELECT COUNT(*) FROM ratings), 3) AS genres_per_rating
FROM ratings r
JOIN movie_genres mg ON mg.movie_id = r.movie_id;
