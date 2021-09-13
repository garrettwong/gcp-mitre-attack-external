#!/usr/bin/env bash

PROJECT_ID="mitre-default"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

# auth
gcloud auth activate-service-account --key-file key.json

gcloud beta compute \
    --project=${PROJECT_ID} instances create instance-2 \
    --zone=us-central1-a --machine-type=e2-medium \
    --subnet=default --maintenance-policy=MIGRATE \
    --service-account=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image-family=debian-10 \
    --image-project=debian-cloud --boot-disk-size=10GB \
    --boot-disk-type=pd-balanced --boot-disk-device-name=default-123 \
    --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring \
    --reservation-affinity=any
