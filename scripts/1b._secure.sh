#!/usr/bin/env bash

PROJECT_ID="mitre-secure"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

cat >iam.automaticIamGrantsForDefaultServiceAccounts.json <<EOF
{
  "name": "projects/${PROJECT_NUMBER}/policies/iam.automaticIamGrantsForDefaultServiceAccounts",
  "spec": {
    "rules": [
      {
        "enforce": true
      }
    ]
  }
}
EOF
gcloud org-policies set-policy iam.automaticIamGrantsForDefaultServiceAccounts.json
gcloud org-policies describe iam.automaticIamGrantsForDefaultServiceAccounts --project ${PROJECT_ID} --format=json



cat >iam.disableServiceAccountKeyCreation.json <<EOF
{
  "name": "projects/${PROJECT_NUMBER}/policies/iam.disableServiceAccountKeyCreation",
  "spec": {
    "rules": [
      {
        "enforce": true
      }
    ]
  }
}
EOF
gcloud org-policies set-policy iam.disableServiceAccountKeyCreation.json
gcloud org-policies describe iam.disableServiceAccountKeyCreation --project ${PROJECT_ID} --format=json



gcloud services enable compute.googleapis.com orgpolicy.googleapis.com \
    --project ${PROJECT_ID}


# Enable Service Account Key Creation Org POLICY
# SERVICE_ACCOUNT_EMAIL="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"
# gcloud iam service-accounts keys create key2.json --iam-account $SERVICE_ACCOUNT_EMAIL