## Step 3 – Load the data

### 3a. Predictions (written before running load.py)




| Table        | Predicted | Actual | Difference explained |
|--------------|-----------|--------|----------------------|
| genres       | 19        |   19   | None                 |
| users        | 943       |   943  | None                 |
| movies       | 1,682     |  1,682 | None                 |
| movie_genres | 2,893     |  2,893 | None                 |
| ratings      | 100,000   | 100,000| None                 |
| rejected     | 0         |   0    | None                 |

Expected refusals: none. Every rating is 1–5, IDs are in range, gender is M/F,
all occupations are on the list, and movie 267's blank release date is allowed
because release_date can be NULL.


### 3b–3c. Refusals

No rows were refused, so `output/rejected.csv` holds only its header. The schema
enforces every single-row claim the README makes, and the data meets all of them.
The one row we expected might fail, movie 267 ("unknown", blank release date),
loads because `release_date` allows NULL. A blank date means "unknown", so
storing NULL is accurate. Rejecting the row instead would lose its ratings.
The loader still catches and logs any refused row, so a future version of the
data with a bad value would show up in `rejected.csv` instead of stopping the load.


### 3d. Makefile

`make` downloads the data if `raw/` is missing, then rebuilds `data/movielens.db`
from scratch on every run. STRICT tables need SQLite 3.37 or newer. If your
`python3` is older, run `make PYTHON=python` with a newer Python.

### 3e. Actual vs predicted

Every count matched its prediction (table in 3a), and no row was refused.



## Step 4 – Check the README's claims

| Claim | Query file | Result | Holds? |
|---|---|---|---|
| 100,000 ratings | `step4_1_ratings_count.sql` | 100,000 | Yes |
| Ratings by 943 users | `step4_2_distinct_raters.sql` | 943 distinct users | Yes |
| Ratings on 1,682 movies | `step4_3_distinct_movies.sql` | 1,682 distinct movies | Yes |
| Users and movies numbered consecutively from 1 | `step4_4_consecutive_ids.sql` | Users 1–943, movies 1–1,682, no gaps | Yes |
| Every user rated at least 20 movies | `step4_5_min_20_ratings.sql` | 0 users below 20 | Yes |

Queries 4.2 and 4.3 count IDs in the `ratings` table, not the `users` and `movies`
tables, because the claim is about who made the ratings and what was rated.


## Step 5 – Questions in SQL

Each query is its own file in `sql/queries/`, with the predicted count, actual
count and gap explained at the top.

| Q | File | Predicted | Actual | Gap |
|---|---|---|---|---|
| Q1 | `q1_top10_most_rated.sql` | 10 | 10 | None. No tie at 10th place, so RANK() kept 10. |
| Q2 | `q2_mean_rating_by_occupation.sql` | 11 (written after the first run) | 7 | Users are uneven across occupations; student and other hold a third of users. |
| Q3 | `q3_zip_not_starting_with_digit.sql` | 0 | 18 | Non-digit zips are 1.9% of users, so a 40-row sample showed none. |
| Q4 | `q4_ratings_by_genre.sql` | 19 | 19 | None. |
| Q4 total | `q4b_genre_total_vs_100k.sql` | ~172,000 | 212,595 | The multiplier is genres per rating (2.126), not per movie (1.72). |
| Q5 | `q5_ratings_per_month.sql` | 8 | 8 | Row count matches; Sep and Apr are partial months, Nov 1997 is a spike. |
| Q6 | `q6_student_not_programmer.sql` | 400–500 | 268 | Programmers rated 1,133 movies, so most student movies overlap. |

**Q1 ties.** `LIMIT 10` would drop a movie tied for 10th without saying so.
`RANK()` gives tied movies the same rank, and keeping `rnk <= 10` returns all of them.

**Q2 WHERE vs HAVING.** WHERE filters rows before grouping; HAVING filters groups
after. "At least 50 raters" is a count over a group, so it belongs in HAVING.

**Q3 if zip were INTEGER.** STRICT would refuse the 18 non-numeric zips at load,
so the query would return 0, and the 96 zips starting with 0 would lose it.

**Q4 total vs 100,000.** Joining ratings to `movie_genres` repeats each rating once
per genre of its movie, so 100,000 ratings become 212,595 (rating, genre) rows.

**Q6 why EXCEPT.** EXCEPT keeps movies in the first set (rated by students) that are
not in the second (rated by programmers). UNION would merge both sets, and
INTERSECT would keep only movies rated by both.

## Step 6 – Build a Query from Named Steps

### 6a. CTEs and row counts

We used Common Table Expressions (CTEs) to find movies whose mean rating was at least 0.5 higher than their genre's mean rating, considering only movies with at least 30 ratings.

| Step | Actual rows | Explanation |
|---|---:|---|
| genre_avg | 19 | Average rating for each genre. |
| movie_avg | 806 | Movies with at least 30 ratings. |
| movie_comparison | 1,610 | Each qualifying movie matched with its genres. |
| final_result | 147 | Movie-genre comparisons meeting the 0.5 threshold. |

The row count increased from 806 to 1,610 because movies can belong to multiple genres. The final result contained 147 rows after filtering out comparisons that did not meet the rating threshold.

### 6b. Multiple genres

We chose to compare movies against every genre they belong to instead of selecting just one. For example, Star Wars (1977) belongs to both Action and Sci-Fi. Its average rating was approximately 4.36, compared with 3.48 for Action and 3.56 for Sci-Fi.

Comparing against each genre provides a more complete picture of the movie's performance.

### 6c. CTEs vs. nested subqueries

We rewrote the query using nested subqueries instead of CTEs. Both versions used the same calculations and filtering conditions and returned the same qualifying movie-genre comparisons.

We preferred the CTE version because each calculation had a clear name and could be checked separately. The nested subquery version was harder to debug because the calculations were embedded inside the main query.

## Step 7 – Missing Values in SQL and Pandas

### 7a. NULL values

We checked the database for missing values. Only the `movies` table contained NULL values.

| Column | NULL count |
|---|---:|
| release_date | 1 |
| video_release_date | 1,682 |
| imdb_url | 3 |

All 1,682 movies had a missing `video_release_date`, suggesting that this field was not populated in the dataset. The other tables contained no NULL values.

### 7b. NOT IN vs. NOT EXISTS

We tested how `NOT IN` and `NOT EXISTS` behave when NULL values are involved.

| Query | Actual rows |
|---|---:|
| NOT IN | 0 |
| NOT EXISTS | 1 |

The difference occurred because `NOT IN` can produce an UNKNOWN result when the subquery contains NULL. `NOT EXISTS` checks for matching rows and avoids this particular issue.

This demonstrates why NULL values must be considered when writing SQL queries.

### 7c. SQL vs. pandas

We loaded the `movies` table into pandas using `pd.read_sql()`.

The `movie_id` column was represented as `int64`, while the text columns were represented as string or object types.

The missing-value counts matched SQL: 1 missing release date, 1,682 missing video release dates, and 3 missing IMDb URLs.

### 7d. Reproducing Step 5 in pandas

We reproduced the Step 5 query for the ten most-rated movies using pandas.

We used `groupby()` to count ratings, `merge()` to add movie titles, and `rank()` to rank the results.

Both SQL and pandas returned the same ten movies with matching rating counts. Star Wars (1977) ranked first with 583 ratings, followed by Contact (1997) with 509 and Fargo (1996) with 508.

## Step 8 – Where SQL Earns Its Place

We found the Step 6 query easier to express in SQL than in pandas because it involved multiple joins, averages, and filtering conditions.

Using CTEs allowed us to separate the calculations into smaller steps. First, we calculated genre averages. Then we calculated movie averages and filtered for movies with at least 30 ratings. Finally, we joined the results and compared the averages.

In pandas, the same process would require multiple `groupby()` and `merge()` operations. SQL made the relationships between tables and the filtering logic easier to understand and debug.