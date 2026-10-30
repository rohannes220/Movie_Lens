# MovieLens 100K in SQLite

**DS5110 – Essentials of Data Science | Homework 3**

## Project Overview

This project uses the GroupLens MovieLens 100K dataset to build and analyze a relational database using SQLite. The database uses STRICT tables, primary keys, foreign keys, and CHECK constraints to enforce data integrity.

The project covers reproducible data acquisition, database design, data loading, validation, SQL analysis, and comparisons between SQL and pandas. Invalid records are logged separately, and the database can be rebuilt from scratch.

## 1. Data Provenance

- **Dataset:** MovieLens 100K, GroupLens Research, University of Minnesota
- **Source URL:** https://files.grouplens.org/datasets/movielens/ml-100k.zip
- **Download Date:** October 28, 2026
- **SHA-256 Checksum:** `50d2a982c66986937beb9ffb3aa76efe955bf3d5c6b761f4e3a7cd717c6a3229`

The dataset is downloaded through `src/download.py` and extracted into `raw/`. The raw data is excluded from Git using `.gitignore` because the dataset's terms of use restrict redistribution.

**Dataset Citation:**

Harper, F. Maxwell, and Joseph A. Konstan. (2015). *The MovieLens Datasets: History and Context.* ACM Transactions on Interactive Intelligent Systems, 5(4), Article 19.

https://doi.org/10.1145/2827872

## 2. Database Schema

The database contains five tables:

- **users:** Stores user information, including age, gender, occupation, and ZIP code.
- **movies:** Stores movie titles, release dates, and IMDb URLs.
- **genres:** Stores genre IDs and names.
- **movie_genres:** Connects movies to their genres.
- **ratings:** Stores user ratings and timestamps.

### Entity Relationship Diagram

<img width="948" height="663" alt="Screenshot 2026-10-30 at 1 33 51 PM" src="https://github.com/user-attachments/assets/69b673fd-fd17-41fe-87fd-475f88b86f0e" />


### Genre Normalization

The original MovieLens dataset represents genres using 19 binary columns.

Instead of retaining these columns in the `movies` table, we created a junction table called `movie_genres`.

Each row represents a relationship between one movie and one genre. This produces a normalized, long-format structure and avoids storing numerous binary flags.

It also allows additional genres to be introduced without changing the structure of the `movies` table.

## 3. Database Constraints

The database uses STRICT tables and SQL constraints to enforce data integrity.

### Enforced Constraints

- Ratings must be between 1 and 5.
- User IDs must be between 1 and 943.
- Movie IDs must be between 1 and 1682.
- Rating timestamps must be positive integers.
- Genre IDs must be between 0 and 18.
- Occupations must match one of the 21 documented occupations.
- Gender values must be either `M` or `F`, consistent with the dataset.
- Foreign keys ensure that ratings reference existing users and movies, and movie-genre relationships reference valid movies and genres.

### Claims Validated Through SQL

Certain dataset claims cannot be fully enforced using ordinary column-level constraints. These are checked after loading the data.

**Consecutive IDs**

The dataset states that user and movie IDs are consecutive. We validate this by checking for missing IDs within the expected ranges.

**Minimum Ratings per User**

The dataset states that every user rated at least 20 movies.

We validate this using:

```sql
SELECT user_id
FROM ratings
GROUP BY user_id
HAVING COUNT(*) < 20;
```

The expected result is zero rows.

The validation queries and their results are documented in the project's SQL files and write-up.

## 4. ZIP Code Data Type

The `zip_code` column is stored as `TEXT` instead of `INTEGER`.

This decision preserves leading zeros in ZIP codes. For example, `02138` would incorrectly become `2138` if stored as an integer.

Additionally, some records contain alphanumeric postal codes, such as `E2A4H`, `T8H1N`, and `V3N4P`.

Using `TEXT` preserves the original values without losing information.

## 5. How to Run the Project

### Requirements

- Python 3
- SQLite 3.37 or newer
- Make

SQLite 3.37 or newer is required because the schema uses STRICT tables.

To check the installed SQLite version:

```bash
python3 -c "import sqlite3; print(sqlite3.sqlite_version)"
```

### Build the Database

From the repository's root directory, run:

```bash
make
```

The Makefile:

1. Downloads the MovieLens 100K dataset if it is missing.
2. Extracts the dataset into `raw/`.
3. Rebuilds `data/movielens.db` from scratch.
4. Loads the records into the database.
5. Logs rejected rows to `output/rejected.csv`.

If the installed Python environment uses an older SQLite version, use a newer Python environment that includes SQLite 3.37 or later.

### Running SQL Queries

The SQL queries are stored in `sql/queries/`.

For example, the following command executes the query identifying the ten most-rated movies:

```bash
python3 -c "import sqlite3; print(sqlite3.connect('data/movielens.db').execute(open('sql/queries/q1_top10_most_rated.sql').read()).fetchall())"
```

## 6. Repository Structure

| Path | Description |
|---|---|
| `src/download.py` | Downloads and extracts the dataset |
| `src/load.py` | Loads data and logs rejected records |
| `sql/schema.sql` | Defines the database tables and constraints |
| `sql/queries/` | Contains SQL validation and analysis queries |
| `raw/` | Stores downloaded dataset files |
| `data/movielens.db` | Generated SQLite database |
| `output/rejected.csv` | Contains rejected rows and SQLite error messages |
| `WRITEUP.md` | Contains predictions, actual counts, explanations, and analysis |
| `Makefile` | Automates the database build |

## 7. Data Validation and Rejected Rows

The data loading process checks records against the constraints defined in `sql/schema.sql`.

Records that violate these constraints are recorded in `output/rejected.csv`, along with the corresponding SQLite error messages.

The raw dataset is not manually edited. Any corrections, mappings, or exclusions are handled in the loading script.

The predicted and actual row counts, differences, and explanations are documented in `WRITEUP.md`.

## 8. Use of AI Assistants

AI assistants were used to support development and understanding throughout the assignment.

**Claude (Anthropic)** was used to help draft `src/load.py`, `src/download.py`, the Makefile, SQL queries, and portions of `WRITEUP.md`. The generated code was executed and its results checked against the dataset.

**ChatGPT (OpenAI)** was used to explain SQL concepts, including Common Table Expressions (CTEs), subqueries, and the differences between `NOT IN` and `NOT EXISTS`. It also assisted with understanding the pandas comparisons in Step 7 and explaining portions of the code.

AI tools were used for coding assistance, clarification, and learning. The team remained responsible for reviewing the work, validating the results, and interpreting the findings.

## 9. Team Contributions

**Ehsan**
- Step 0: Raw data exploration, charts, and documentation gap analysis.
- Step 1: Reproducible dataset download and checksum documentation.
- Step 2: Database schema design, entity relationship diagram, and constraints.

**Niraj**
- Step 3: Data loading, rejected-row logging, and database construction.
- Step 4: Validation of dataset claims using SQL.
- Step 5: SQL queries, predicted row counts, actual results, and explanations.

**Rohan**
- Step 6: Reproducible build documentation and README.
- Step 7: Missing-value analysis and SQL-to-pandas comparisons.
- Step 8: Reflection on the differences between SQL and pandas.
