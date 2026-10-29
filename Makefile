PYTHON ?= python3

RAW = raw/ml-100k/u.data

all: db

$(RAW):
	$(PYTHON) src/download.py

db: $(RAW)
	mkdir -p data output
	$(PYTHON) src/load.py

clean:
	rm -f data/movielens.db output/rejected.csv

.PHONY: all db clean
