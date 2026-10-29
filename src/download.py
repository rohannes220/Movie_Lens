import hashlib
import os
import urllib.request
import zipfile
from datetime import datetime

DATASET_URL = "https://files.grouplens.org/datasets/movielens/ml-100k.zip"
RAW_DIR = "raw"
ZIP_PATH = os.path.join(RAW_DIR, "ml-100k.zip")
# Set this after one download you have verified; None skips the check.
EXPECTED_SHA256 = None


def sha256_of(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for block in iter(lambda: f.read(65536), b""):
            h.update(block)
    return h.hexdigest()


def acquire_data():
    """Download (once) and unpack the dataset into raw/."""
    os.makedirs(RAW_DIR, exist_ok=True)

    if not os.path.exists(ZIP_PATH):
        tmp = ZIP_PATH + ".part"
        print(f"Downloading {DATASET_URL} ...")
        urllib.request.urlretrieve(DATASET_URL, tmp)
        os.replace(tmp, ZIP_PATH)
        print("Download complete.")

    checksum = sha256_of(ZIP_PATH)
    if EXPECTED_SHA256 is not None and checksum != EXPECTED_SHA256:
        raise SystemExit(f"Checksum mismatch: got {checksum}, expected {EXPECTED_SHA256}")

    print("\n--- Metadata for README ---")
    print(f"Source URL: {DATASET_URL}")
    print(f"Download date: {datetime.now():%Y-%m-%d}")
    print(f"SHA-256: {checksum}")

    with zipfile.ZipFile(ZIP_PATH) as z:
        z.extractall(RAW_DIR)
    print("Extraction complete.")


if __name__ == "__main__":
    acquire_data()
