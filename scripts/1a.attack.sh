#!/usr/bin/env bash

PROJECT_ID="mitre-default"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

gcloud auth activate-service-account --key-file key.json
gcloud auth list
gcloud projects get-iam-policy $PROJECT_ID