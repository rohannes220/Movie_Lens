-- Enable foreign keys in SQLite
PRAGMA foreign_keys = ON;

-- 1. USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY CHECK (user_id BETWEEN 1 AND 943),
    age INTEGER NOT NULL CHECK (age > 0 AND age < 120),
    gender TEXT NOT NULL CHECK (gender IN ('M', 'F')),
    occupation TEXT NOT NULL CHECK (occupation IN (
    'administrator','artist','doctor','educator','engineer','entertainment',
    'executive','healthcare','homemaker','lawyer','librarian','marketing',
    'none','other','programmer','retired','salesman','scientist','student',
    'technician','writer')),
    zip_code TEXT NOT NULL
) STRICT;

-- 2. MOVIES TABLE
CREATE TABLE IF NOT EXISTS movies (
    movie_id INTEGER PRIMARY KEY CHECK (movie_id BETWEEN 1 AND 1682),
    movie_title TEXT NOT NULL,
    release_date TEXT,
    video_release_date TEXT,
    imdb_url TEXT
) STRICT;

-- 3. GENRES LOOKUP TABLE (Tidy Format)
CREATE TABLE IF NOT EXISTS genres (
    genre_id INTEGER PRIMARY KEY CHECK (genre_id BETWEEN 0 AND 18),
    genre_name TEXT NOT NULL UNIQUE
) STRICT;

-- 4. MOVIE_GENRES JUNCTION TABLE (Tidy Format)
CREATE TABLE IF NOT EXISTS movie_genres (
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES movies (movie_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres (genre_id) ON DELETE CASCADE
) STRICT;

-- 5. RATINGS TABLE
CREATE TABLE IF NOT EXISTS ratings (
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    timestamp INTEGER NOT NULL CHECK (timestamp > 0),
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES movies (movie_id) ON DELETE CASCADE
) STRICT;
