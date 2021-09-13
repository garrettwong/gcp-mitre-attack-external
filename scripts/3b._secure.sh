#!/usr/bin/env bash

PROJECT_ID="mitre-secure"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

gcloud services enable storage.googleapis.com
gcloud services enable accesscontextmanager.googleapis.com cloudresourcemanager.googleapis.com

# create bucket and upload files
gsutil mb -l us-west1 gs://${PROJECT_ID}-sensitive-ab16
gsutil -m cp -R . gs://${PROJECT_ID}-sensitive-ab16/
gsutil ls gs://${PROJECT_ID}-sensitive-ab16/

# check exfil bucket
gsutil ls gs://exfiltrater-gcs

# VPC service controls
ORG_ID=$(gcloud organizations list --format='value(ID)')
# gcloud access-context-manager policies create \
#     --organization $ORG_ID \
#     --title POLICY_TITLE
POLICY_ID=$(gcloud access-context-manager policies list --organization $ORG_ID --format="value(name)")
echo $POLICY_ID

gcloud access-context-manager perimeters create MITRESecureDemo \
    --title="MITRE Secure Demo Perimeter" \
    --resources="projects/${PROJECT_NUMBER}" \
    --restricted-services="storage.googleapis.com" \
    --policy="${POLICY_ID}" \
    --project ${PROJECT_ID}
