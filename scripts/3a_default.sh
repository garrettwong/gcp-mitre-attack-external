#!/usr/bin/env bash

PROJECT_ID="mitre-default"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

gcloud services enable storage.googleapis.com \
    --project ${PROJECT_ID}

# create bucket and upload files
gsutil mb gs://${PROJECT_ID}-sensitive-ab16
gsutil cp -R . gs://${PROJECT_ID}-sensitive-ab16/
gsutil ls gs://${PROJECT_ID}-sensitive-ab16/

# check exfil bucket
gsutil ls gs://exfiltrater-gcs