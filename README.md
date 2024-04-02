# Formula One Analytics
This repository contains an end-to-end data pipeline for ingesting, transforming, and visualizing formula one data.

![Image](./images/f1_data_pipeline.jpg)

## Problem description
This project was created to track Formula One results.

The source data for this project contains many different CSV files, allowing you to create endless different data models.

I have specifically chosen to track Driver Standings, as the data can be updated regularly to track the current 2024 Formula One season, including constructor wins.

An additional tile has been added to the dashboard to show which teams have dominated Formula One races over the past 5 years.

## Cloud
The main cloud platform used for this project is Google Cloud Platform.

There are several services utilized, including:
- Compute Engine
- Google Cloud Storage
- Google BigQuery

Google Cloud Storage and Google BigQuery resources are deployed with infrastructure as code, using Terraform.

The code for deploying these resources can be found in [infrastructure](./infrastructure).

Note: Staging and production infrastructure is deployed using GitHub actions as a CI/CD tool.

## Data ingestion (Batch)
The data ingestion is run in multiple steps, and orchestrated within a Docker file.

The following steps are done for data ingestions:
- [Ingest data]() from custom CSV API to GCS data lake.
- [Load data]() from data lake to Google BigQuery.

To perform data ingestion, a docker file can be built and run by running the following commands inside [/data_ingestion](./data_ingestion):
- `docker build -t f1-data:latest .`
- `docker run f1-data:latest`

This will build a docker container and run both Python scripts inside of the container, allowing the data ingestion pipeline to be run from any platform where Docker is installed.

## Data warehouse
Google BigQuery has been used for the data warehouse tool in this project.

The data is arranged using [Medallion Architecture](https://www.databricks.com/glossary/medallion-architecture) where each stage of data transformation is performed using dbt.

#### Partitioning
Tables are also partitioned to improve their performance. For example, the "F1 Driver Standings" table is partitioned by race season, as shown in the model config of [f1_driver_standings.sql](./transformations/gold/models/marts/f1_driver_standings.sql).

Race season was selected for partitioning as the dashboard utilizes filters which filter on race season, hence less data is queried if the table is partitioned this way.

## Transformations (dbt)
The tool used for transformation of data in this project is dbt.

This tool allows all code to be version controlled, and transformations to be done sequentially.

Data transformations done by dbt are performed using GitHub actions as a CI/CD tool.

This allows dbt to perform transformations in staging and productions environments when changes are made to the code and pushed to the main branch.

More information about using dbt with GitHub actions can be found [here](https://dbtips.substack.com/p/run-dbt-with-github-actions).

## Dashboard
For data visualization, Google Looker Studio has been used.

This allows easy integration with the Google Cloud Platform ecosystem.

Link to dashboard: [Formula One Analytics](https://lookerstudio.google.com/reporting/47305871-638b-47f6-a6ca-7b7d293b68c5)

![Image](./images/f1_dashboard.png)

The dashboard has three tiles:
- Driver standings
- Constructor Win Percentage
- Constructor Dominance - 2020 to 2024

The first two tiles can be filtered by race season.

## Reproducibility
Due to this project being run on a personal cloud account, it can be difficult to reproduce.

If you have your own Google Cloud Platform account, it is possible to reproduce this project.

#### Fork Repository
The first step is fork this repository and create your own. Having your own repository will allow you to set your personal GCP credentials in order to run the project.

#### GitHub Actions - Secrets Manager
In order to allow GitHub actions to perform changes on your GCP account, you must add your service account as a secret to the repository.

Instructions on how to add secrets to your GitHub repository can be found [here](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions).

#### Setting GCP Project
You must specify your own GCP project name in the following code:
- [dbt-transform-prod.yml](./.github/workflows/dbt-transform-prod.yml)
- [dbt-transform-staging.yml](./.github/workflows/dbt-transform-staging.yml)
- [prod/_variables.tf](./infrastructure/prod/_variables.tf)
- [staging/_variables.tf](./infrastructure/staging/_variables.tf)
- [dev/_variables.tf](./infrastructure/dev/_variables.tf)
- [data_ingestion/load_f1_data.py](data_ingestion/load_f1_data.py)


#### GCS Bucket Name
In order to specifiy which bucket the project will use as a data lake, you must set your own bucket name in the following code:
- [data_ingestion/Dockerfile](./data_ingestion/Dockerfile)
- [prod/_variables.tf](./infrastructure/prod/_variables.tf)
- [staging/_variables.tf](./infrastructure/staging/_variables.tf)
- [dev/_variables.tf](./infrastructure/dev/_variables.tf)

