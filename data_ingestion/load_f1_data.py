import os
import re
from google.cloud import storage
from google.cloud import bigquery

# Set your GCP project name here
PROJECT_NAME = 'taxi-rides-ny-412407'

def list_blobs(bucket_name):
    """Lists all the blobs in the bucket."""
    # bucket_name = "your-bucket-name"

    storage_client = storage.Client()

    # Note: Client.list_blobs requires at least package version 1.17.0.
    blobs = storage_client.list_blobs(bucket_name)

    # Note: The call returns a response only when the iterator is consumed.
    return blobs

def load_bigquery(table, bucket_name):
    # Construct a BigQuery client object.
    client = bigquery.Client()

    # TO DO(developer): Set table_id to the ID of the table to create.
    # table_id = "your-project.your_dataset.your_table_name"

    job_config = bigquery.LoadJobConfig(
        autodetect = True,
        skip_leading_rows=1,
        # The source format defaults to CSV, so the line below is optional.
        source_format=bigquery.SourceFormat.CSV,
    )
    database = PROJECT_NAME
    schema = 'bronze'

    uri = f'gs://{bucket_name}/{table}.csv'

    table_id = f'{database}.{schema}.{table}'

    load_job = client.load_table_from_uri(
        uri, table_id, job_config=job_config
    )  # Make an API request.

    load_job.result()  # Waits for the job to complete.

    destination_table = client.get_table(table_id)  # Make an API request.
    print("Loaded {} rows.".format(destination_table.num_rows))

if __name__ == "__main__":
    GCP_GCS_BUCKET = f'{PROJECT_NAME}-data-lake-production'
    csv_files = list_blobs(GCP_GCS_BUCKET)
    files = [re.sub(r'\.csv$', '', file.name) for file in csv_files]
    print(files)

    for file in files:
        load_bigquery(file, GCP_GCS_BUCKET)