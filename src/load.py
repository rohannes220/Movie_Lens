#!/usr/bin/env python3
"""Build data/movielens.db from raw/ml-100k, logging every refused row."""
import csv
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "raw" / "ml-100k"
DB = ROOT / "data" / "movielens.db"
SCHEMA = ROOT / "sql" / "schema.sql"
REJECTS = ROOT / "output" / "rejected.csv"


def read_lines(name, encoding="latin-1"):
    for line in (RAW / name).read_text(encoding=encoding).splitlines():
        if line.strip():
            yield line


def genre_rows():
    for line in read_lines("u.genre"):
        name, gid = line.split("|")
        yield (int(gid), name)


def user_rows():
    for line in read_lines("u.user"):
        uid, age, gender, occ, zip_code = line.split("|")
        yield (int(uid), int(age), gender, occ, zip_code)


def movie_rows():
    for line in read_lines("u.item"):
        f = line.split("|")
        yield (int(f[0]), f[1], f[2] or None, f[3] or None, f[4] or None)


def movie_genre_rows():
    for line in read_lines("u.item"):
        f = line.split("|")
        for gid, flag in enumerate(f[5:24]):
            if flag == "1":
                yield (int(f[0]), gid)


def rating_rows():
    for line in read_lines("u.data", encoding="utf-8"):
        uid, mid, rating, ts = line.split("\t")
        yield (int(uid), int(mid), int(rating), int(ts))


LOADS = [
    ("genres", "INSERT INTO genres(genre_id, genre_name) VALUES (?,?)", genre_rows),
    ("users", "INSERT INTO users(user_id, age, gender, occupation, zip_code) VALUES (?,?,?,?,?)", user_rows),
    ("movies", "INSERT INTO movies(movie_id, movie_title, release_date, video_release_date, imdb_url) VALUES (?,?,?,?,?)", movie_rows),
    ("movie_genres", "INSERT INTO movie_genres(movie_id, genre_id) VALUES (?,?)", movie_genre_rows),
    ("ratings", "INSERT INTO ratings(user_id, movie_id, rating, timestamp) VALUES (?,?,?,?)", rating_rows),
]


def main():
    DB.parent.mkdir(parents=True, exist_ok=True)
    REJECTS.parent.mkdir(parents=True, exist_ok=True)
    if DB.exists():
        DB.unlink()
    conn = sqlite3.connect(DB)
    conn.executescript(SCHEMA.read_text())

    rejected = []
    for table, sql, source in LOADS:
        ok = 0
        for row in source():
            try:
                conn.execute(sql, row)
                ok += 1
            except sqlite3.Error as e:
                rejected.append({"table": table, "row": repr(row),
                                 "error": str(e), "action": "left out"})
        conn.commit()
        print(f"{table:13s}: {ok} loaded")

    with open(REJECTS, "w", newline="") as f:
        w = csv.DictWriter(f, fieldnames=["table", "row", "error", "action"])
        w.writeheader()
        w.writerows(rejected)
    print(f"rejected     : {len(rejected)} -> {REJECTS}")
    conn.close()


if __name__ == "__main__":
    main()
