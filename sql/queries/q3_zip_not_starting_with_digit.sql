-- Q3. How many users have a zip code that does not start with a digit?
-- predicted: 1 row, value 0 (the first 40 zips were all numeric)
-- actual: 1 row, 18.
-- Gap: predicted 0, got 18. Non-digit zips are rare (18/943 ≈ 1.9%), so a
--   40-row sample would hold fewer than one on average; seeing none there did
--   not mean there were none.
-- If zip_code were INTEGER: this query would return 0. STRICT refuses
--   non-numeric zips at load, so those 18 users (and their ratings) would land
--   in rejected.csv, and the 96 zips starting with 0 would silently lose it
--   (01002 -> 1002).
SELECT COUNT(*) AS n_users
FROM users
WHERE substr(zip_code, 1, 1) NOT BETWEEN '0' AND '9';
