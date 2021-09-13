#!/usr/bin/env bash

PROJECT_ID="mitre-secure"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

# Enable Service Account Key Creation Org POLICY
SERVICE_ACCOUNT_EMAIL="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"

gcloud auth activate-service-account --key-file key2.json
gcloud auth list

# fails: no permission (Disable Automatic IAM Grant)
gcloud projects get-iam-policy $PROJECT_ID
