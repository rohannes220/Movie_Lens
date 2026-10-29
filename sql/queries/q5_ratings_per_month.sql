-- Q5. Ratings made in each calendar month. Timestamps are Unix seconds (UTC),
--   converted with strftime(..., 'unixepoch').
-- predicted: 8 rows (README: collected Sept 19, 1997 - Apr 22, 1998, so Sep..Apr),
--   about 12,500 ratings each if spread evenly (100,000 / 8)
-- actual: 8 rows, 1997-09 to 1998-04. Gap: row count matches. Monthly counts are
--   uneven, not ~12,500 each: Sep (6,704) and Apr (9,359) are partial months in
--   the README's collection window, and Nov 1997 (23,980) is a spike of about
--   twice the even share that the README does not explain.
SELECT strftime('%Y-%m', timestamp, 'unixepoch') AS month,
       COUNT(*) AS n_ratings
FROM ratings
GROUP BY month
ORDER BY month;
