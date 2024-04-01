import io
import os
import requests
import subprocess
import zipfile
import pandas as pd

from subprocess import run
from google.cloud import storage

"""
Pre-reqs: 
1. `pip install pandas pyarrow google-cloud-storage`
2. Set GOOGLE_APPLICATION_CREDENTIALS to your project/service-account key
3. Set GCP_GCS_BUCKET as your bucket or change default value of BUCKET
"""

# url of f1 dataset
f1_csv = 'http://ergast.com/downloads/f1db_csv.zip'

# Set your GCP project name here
PROJECT_NAME = 'taxi-rides-ny-412407'

# name of gcs bucket to save files
BUCKET = f'{PROJECT_NAME}-data-lake-production'

def upload_to_gcs(bucket, object_name, local_file):
    """
    Ref: https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-python
    """

    client = storage.Client()
    bucket = client.bucket(bucket)
    blob = bucket.blob(object_name)
    blob.upload_from_filename(local_file)

def f1_to_gcs():

    # name of file
    f1_file = 'f1db'

    # download file using requests
    r = requests.get(f1_csv)
    open(f1_file, 'wb').write(r.content)
    print(f'Downloading {f1_file}...')
    print(f'\tLocal: {f1_file}')
    print()

    # create directory for csv files
    dir = './raw_csv'
    os.mkdir(dir)

    # unzip folder and output to directory
    with zipfile.ZipFile(f'./{f1_file}', 'r') as zip_ref:
        zip_ref.extractall(dir)

    # upload each csv to gcs
    for file in os.listdir(dir):
        # display current file
        print(f'File: {file}')

        # Remove null characters "\N"
        null_char = r'\\N'
        subprocess.call([f"sed -i -e 's|{null_char}||g' {dir}/{file}"], shell=True)

        # upload it to gcs
        print('\tUploading to Google Storage...')
        upload_to_gcs(BUCKET, file, f'{dir}/{file}')

        # clean up files
        print('\tUpload complete!')

        print(f'\tCleaning up {file}...')
        os.remove(f'{dir}/{file}')
        print()

    print('All files uploaded successfully!')
    print(f'\tCleaning up {f1_file}...')
    os.remove(f1_file)

# f1
f1_to_gcs()