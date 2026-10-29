-- Q6. How many movies were rated by at least one student but by no programmer?
-- EXCEPT returns rows in the first set that are not in the second: movies rated
--   by students, minus movies rated by programmers. UNION would combine both
--   sets, and INTERSECT would keep only movies rated by both, so neither answers
--   this. EXCEPT also removes duplicates, so each movie is counted once.
-- predicted: 1 row, 400-500 movies (students rate widely; programmers mostly rate
--   popular titles that students also rate, so the leftover is obscure movies)
-- actual: 1 row, 268. Gap: predicted 400-500, got 268. Programmers covered far more
--   of the catalogue than assumed: 66 programmers rated 1,133 movies, so 1,071 of
--   the 1,339 movies students rated were also rated by a programmer.
SELECT COUNT(*) AS n_movies
FROM (
    SELECT r.movie_id FROM ratings r
    JOIN users u ON u.user_id = r.user_id
    WHERE u.occupation = 'student'
    EXCEPT
    SELECT r.movie_id FROM ratings r
    JOIN users u ON u.user_id = r.user_id
    WHERE u.occupation = 'programmer'
);
