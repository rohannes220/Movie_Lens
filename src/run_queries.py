#!/usr/bin/env python3
"""Run every sql/queries/*.sql against data/movielens.db and save the results.

Each query's rows go to output/results/<file>.csv. A file holding several
statements (for example step7b, which compares NOT IN with NOT EXISTS) gets
one CSV per statement: <file>_1.csv, <file>_2.csv, ...
"""
import csv
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DB = ROOT / "data" / "movielens.db"
QUERIES = ROOT / "sql" / "queries"
RESULTS = ROOT / "output" / "results"


def statements(sql_text):
    """Split a SQL file into complete statements, skipping comment-only chunks."""
    buf = ""
    for line in sql_text.splitlines(keepends=True):
        buf += line
        if sqlite3.complete_statement(buf):
            code = [l for l in buf.splitlines() if l.strip() and not l.strip().startswith("--")]
            if code:
                yield buf.strip()
            buf = ""
    if any(l.strip() and not l.strip().startswith("--") for l in buf.splitlines()):
        yield buf.strip()  # last statement without a trailing semicolon


def save(path, cursor, rows):
    with open(path, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow([d[0] for d in cursor.description])
        w.writerows(rows)


def main():
    RESULTS.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(DB)
    for path in sorted(QUERIES.glob("*.sql")):
        stmts = list(statements(path.read_text()))
        for i, stmt in enumerate(stmts, 1):
            cur = conn.execute(stmt)
            rows = cur.fetchall()
            name = path.stem if len(stmts) == 1 else f"{path.stem}_{i}"
            save(RESULTS / f"{name}.csv", cur, rows)
            print(f"{name:40s} {len(rows):>5} rows")
    conn.close()
    print(f"results -> {RESULTS}")


if __name__ == "__main__":
    main()
