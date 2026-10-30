-- Step 7a: Check missing values in the movies table
-- Expected: release_date = 1, video_release_date = 1682, imdb_url = 3

SELECT
    COUNT(*) AS total_movies,
    SUM(CASE WHEN release_date IS NULL THEN 1 ELSE 0 END) AS missing_release_date,
    SUM(CASE WHEN video_release_date IS NULL THEN 1 ELSE 0 END) AS missing_video_release_date,
    SUM(CASE WHEN imdb_url IS NULL THEN 1 ELSE 0 END) AS missing_imdb_url
FROM movies;
