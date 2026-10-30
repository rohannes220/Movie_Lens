PYTHON ?= python3

RAW = raw/ml-100k/u.data

all: queries

$(RAW):
	$(PYTHON) src/download.py

db: $(RAW)
	mkdir -p data output
	$(PYTHON) src/load.py

queries: db
	$(PYTHON) src/run_queries.py

clean:
	rm -f data/movielens.db output/rejected.csv
	rm -rf output/results

.PHONY: all db queries clean
