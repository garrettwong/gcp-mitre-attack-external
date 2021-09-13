#!/usr/bin/env bash

PROJECT_ID="mitre-default"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

gcloud services enable compute.googleapis.com \
    --project ${PROJECT_ID}

SERVICE_ACCOUNT_EMAIL="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"
gcloud iam service-accounts keys create key.json --iam-account $SERVICE_ACCOUNT_EMAIL
