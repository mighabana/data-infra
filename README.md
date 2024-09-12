# About

This is my personal data infrastructure setup managed and maintained with Terraform.


### Tools and Services

My current expertise is setting up on Google Cloud Platform, so most of my tooling is based around that:

1. Data Warehouse - BigQuery
2. BLOB Storage - Google Cloud Storage
3. Orchestration - Self-managed Airflow
4. Data Pipelines - Self-managed Python Scripts

# Setup

1. Using the `terraform.tfvars.template` file create a new file called `terraform.tfvars` inside the project folder and replace the missing variables with your own values
2. Modify the backend naming conventions as needed in the `main.tf` file
3. Initialize Terraform

```bash
terraform init
```

4. Validate the configurations. 

```bash
terraform plan
```

5. Apply the configurations.

```bash
terraform apply
```


