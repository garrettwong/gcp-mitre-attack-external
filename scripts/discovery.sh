#!/usr/bin/env bash

function discover_iam() {
    ORG_ID=$1
    SERVICE_ACCOUNT_EMAIL=$2
    
    gcloud beta asset search-all-iam-policies \
        --scope=organizations/$ORG_ID \
        --query="policy:${SERVICE_ACCOUNT_EMAIL}"

    gcloud beta asset search-all-resources --scope="organizations/${ORG_ID}" --format=json --asset-types="*/Project" --query='location:us-central1'
    gcloud beta asset search-all-resources --scope="organizations/${ORG_ID}" --format=json --asset-types="cloudresourcemanager.googleapis.com/Project" --query='location:us-central1'
    gcloud beta asset search-all-resources --scope="organizations/${ORG_ID}" --format=json --asset-types="cloudresourcemanager.googleapis.com/Project"
    gcloud beta asset search-all-resources --scope="organizations/${ORG_ID}" --format=json --asset-types="compute.googleapis.com/Subnetwork"
}
