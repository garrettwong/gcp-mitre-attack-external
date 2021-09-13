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

# create instance
gcloud beta compute \
    --project=${PROJECT_ID} instances create instance-1 \
    --zone=us-central1-a --machine-type=e2-medium --subnet=default \
    --network-tier=PREMIUM --maintenance-policy=MIGRATE \
    --service-account=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --image-family=debian-10 --image-project=debian-cloud \
    --boot-disk-size=10GB --boot-disk-type=pd-balanced \
    --boot-disk-device-name=instance-1 --no-shielded-secure-boot \
    --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any