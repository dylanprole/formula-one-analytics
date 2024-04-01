This repository is a test dbt project which is deployed to staging and production environments in BigQuery using GitHub Actions.

### Staging
- Models are deployed to a staging environment when a pull request is made.

### Production
- Models are deployed to a production environment when the pull request is merged to main.

### Resources:
- How to setup a GitHub Actions file for dbt to BigQuery [Link](https://medium.com/hashmapinc/dbt-orchestration-in-azure-devops-pipelines-3d565c39f302)
