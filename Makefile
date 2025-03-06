.PHONY: create_service_accounts

_SECRETS_FOLDER?="${HOME}/dev/.secrets"
ADMIN_SERVICE_ACCOUNT_NAME?="admin-sa"
METABASE_SERVICE_ACCOUNT_NAME?="metabase-sa"
BIGQUERY_SERVICE_ACCOUNT_NAME?="bigquery-sa"
CLOUDSQL_SERVICE_ACCOUNT_NAME?="cloudsql-sa"

# Define roles for each service account
ADMIN_ROLES=roles/storage.admin \
           roles/bigquery.admin \
           roles/serviceusage.serviceUsageAdmin \
           roles/compute.admin \
           roles/iam.serviceAccountUser \
           roles/cloudsql.admin \
           roles/networkmanagement.admin \
           roles/servicenetworking.networksAdmin \
           roles/monitoring.metricWriter \
           roles/logging.logWriter

METABASE_ROLES=roles/bigquery.dataViewer \
              roles/bigquery.jobUser \
              roles/bigquery.metadataViewer

BIGQUERY_ROLES=roles/bigquery.dataEditor \
              roles/bigquery.jobUser \
              roles/bigquery.readSessionUser

CLOUDSQL_ROLES=roles/cloudsql.client

help:
	@echo "make"
	@echo "    create_service_accounts"

create_service_accounts:
	@mkdir -p ${_SECRETS_FOLDER}

	@# Create service accounts if they don't exist
	@echo "Creating service accounts..."
	@for sa in ${ADMIN_SERVICE_ACCOUNT_NAME} ${METABASE_SERVICE_ACCOUNT_NAME} ${BIGQUERY_SERVICE_ACCOUNT_NAME} ${CLOUDSQL_SERVICE_ACCOUNT_NAME}; do \
		echo "Creating $$sa service account..."; \
		gcloud iam service-accounts create $$sa --quiet 2>/dev/null || echo "Service account $$sa already exists"; \
	done

	@# Admin service account roles
	@echo "Assigning roles to ${ADMIN_SERVICE_ACCOUNT_NAME}..."
	@for role in ${ADMIN_ROLES}; do \
		echo "Assigning $$role to ${ADMIN_SERVICE_ACCOUNT_NAME}..."; \
		gcloud projects add-iam-policy-binding ${CLOUDSDK_CORE_PROJECT} \
			--member="serviceAccount:${ADMIN_SERVICE_ACCOUNT_NAME}@${CLOUDSDK_CORE_PROJECT}.iam.gserviceaccount.com" \
			--role="$$role" --quiet || echo "Failed to assign $$role to ${ADMIN_SERVICE_ACCOUNT_NAME}"; \
	done

	@# Metabase service account roles
	@echo "Assigning roles to ${METABASE_SERVICE_ACCOUNT_NAME}..."
	@for role in ${METABASE_ROLES}; do \
		echo "Assigning $$role to ${METABASE_SERVICE_ACCOUNT_NAME}..."; \
		gcloud projects add-iam-policy-binding ${CLOUDSDK_CORE_PROJECT} \
			--member="serviceAccount:${METABASE_SERVICE_ACCOUNT_NAME}@${CLOUDSDK_CORE_PROJECT}.iam.gserviceaccount.com" \
			--role="$$role" --quiet || echo "Failed to assign $$role to ${METABASE_SERVICE_ACCOUNT_NAME}"; \
	done

	@# BigQuery service account roles
	@echo "Assigning roles to ${BIGQUERY_SERVICE_ACCOUNT_NAME}..."
	@for role in ${BIGQUERY_ROLES}; do \
		echo "Assigning $$role to ${BIGQUERY_SERVICE_ACCOUNT_NAME}..."; \
		gcloud projects add-iam-policy-binding ${CLOUDSDK_CORE_PROJECT} \
			--member="serviceAccount:${BIGQUERY_SERVICE_ACCOUNT_NAME}@${CLOUDSDK_CORE_PROJECT}.iam.gserviceaccount.com" \
			--role="$$role" --quiet || echo "Failed to assign $$role to ${BIGQUERY_SERVICE_ACCOUNT_NAME}"; \
	done

	@# CloudSQL service account roles
	@echo "Assigning roles to ${CLOUDSQL_SERVICE_ACCOUNT_NAME}..."
	@for role in ${CLOUDSQL_ROLES}; do \
		echo "Assigning $$role to ${CLOUDSQL_SERVICE_ACCOUNT_NAME}..."; \
		gcloud projects add-iam-policy-binding ${CLOUDSDK_CORE_PROJECT} \
			--member="serviceAccount:${CLOUDSQL_SERVICE_ACCOUNT_NAME}@${CLOUDSDK_CORE_PROJECT}.iam.gserviceaccount.com" \
			--role="$$role" --quiet || echo "Failed to assign $$role to ${CLOUDSQL_SERVICE_ACCOUNT_NAME}"; \
	done

	@# Create service account keys if they don't exist
	@echo "Creating service account keys..."
	@for sa in ${ADMIN_SERVICE_ACCOUNT_NAME} ${METABASE_SERVICE_ACCOUNT_NAME} ${BIGQUERY_SERVICE_ACCOUNT_NAME} ${CLOUDSQL_SERVICE_ACCOUNT_NAME}; do \
		if [ ! -f "${_SECRETS_FOLDER}/$$sa-key.json" ]; then \
			echo "Creating key for $$sa..."; \
			gcloud iam service-accounts keys create ${_SECRETS_FOLDER}/$$sa-key.json \
				--iam-account=$$sa@${CLOUDSDK_CORE_PROJECT}.iam.gserviceaccount.com || echo "Failed to create key for $$sa"; \
		else \
			echo "Key for $$sa already exists"; \
		fi; \
	done

	@echo "Service account creation and configuration completed!"
