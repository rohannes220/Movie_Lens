import hashlib
import os
import ssl
import urllib.request
import zipfile
from datetime import datetime

# Source URL and directories
DATASET_URL = "https://files.grouplens.org/datasets/movielens/ml-100k.zip"
RAW_DIR = "raw"
ZIP_PATH = os.path.join(RAW_DIR, "ml-100k.zip")


def acquire_data():
    """Download and unpack the dataset reproducibly into raw/."""
    os.makedirs(RAW_DIR, exist_ok=True)

    # 1. Download dataset if not already present
    if not os.path.exists(ZIP_PATH):
        print(f"Downloading dataset from {DATASET_URL}...")
        context = ssl._create_unverified_context()
        urllib.request.urlretrieve(DATASET_URL, ZIP_PATH, context=context)
        print("Download complete.")

    # 2. Calculate and print SHA-256 Checksum
    sha256_hash = hashlib.sha256()
    with open(ZIP_PATH, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)

    checksum = sha256_hash.hexdigest()
    download_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    print("\n--- Metadata for README ---")
    print(f"Source URL: {DATASET_URL}")
    print(f"Download Date: {download_date}")
    print(f"SHA-256 Checksum: {checksum}")

    # 3. Extract the contents into raw/
    print("\nExtracting zip contents...")
    with zipfile.ZipFile(ZIP_PATH, "r") as zip_ref:
        zip_ref.extractall(RAW_DIR)
    print("Extraction complete.")


if __name__ == "__main__":
    acquire_data()