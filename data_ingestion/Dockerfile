FROM python:3.9.1

ARG USER_CODE_PATH=/home/src/data_ingestion

COPY ./.keys/taxi-rides-ny-412407-0d67f6e0486c.json ${USER_CODE_PATH}/.keys/taxi-rides-ny-412407-0d67f6e0486c.json

ENV GOOGLE_APPLICATION_CREDENTIALS=${USER_CODE_PATH}/.keys/taxi-rides-ny-412407-0d67f6e0486c.json

RUN apt-get install wget
RUN pip install requests pandas pyarrow google-cloud-storage google-cloud-bigquery

WORKDIR /app
COPY ingest_f1_data.py ingest_f1_data.py
COPY load_f1_data.py load_f1_data.py

CMD python ingest_f1_data.py && python load_f1_data.py