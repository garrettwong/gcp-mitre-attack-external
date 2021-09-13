#!/usr/bin/env bash

PROJECT_ID="mitre-secure"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

gcloud services enable compute.googleapis.com \
    --project ${PROJECT_ID}

cat >compute.vmExternalIpAccess.json <<EOF
{
  "name": "projects/${PROJECT_NUMBER}/policies/compute.vmExternalIpAccess",
  "spec": {
    "rules": [
      {
        "denyAll": true
      }
    ]
  }
}
EOF
gcloud org-policies set-policy compute.vmExternalIpAccess.json
gcloud org-policies describe compute.vmExternalIpAccess --project ${PROJECT_ID} --format=json



cat >gcp.resourceLocations.json <<EOF
{
  "name": "projects/${PROJECT_NUMBER}/policies/gcp.resourceLocations",
  "spec": {
    "rules": [
      {
        "values": {
          "allowedValues": [
            "in:us-east1-locations",
            "in:us-west1-locations"
          ]
        }
      }
    ]
  }
}
EOF
gcloud org-policies set-policy gcp.resourceLocations.json
gcloud org-policies describe gcp.resourceLocations --project ${PROJECT_ID} --format=json



cat > compute.restrictCloudNATUsage.json <<EOF
{
  "name": "projects/${PROJECT_NUMBER}/policies/compute.restrictCloudNATUsage",
  "spec": {
    "rules": [
      {
        "values": {
          "allowedValues": [
            "projects/mitre-secure/regions/us-central1/subnetworks/default",
            "projects/mitre-secure/regions/us-east4/subnetworks/default"
          ]
        }
      }
    ]
  }
}
EOF

gcloud org-policies set-policy compute.restrictCloudNATUsage.json
gcloud org-policies describe compute.restrictCloudNATUsage --project ${PROJECT_ID} --format=json
