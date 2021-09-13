#!/usr/bin/env bash

PROJECT_ID="mitre-secure"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

gcloud compute project-info add-metadata \
    --metadata="enable-oslogin=TRUE"

cat > compute.requireOsLogin.json <<EOF
{
  "name": "projects/${PROJECT_NUMBER}/policies/compute.requireOsLogin",
  "spec": {
    "rules": [
      {
        "enforce": true
      }
    ]
  }
}
EOF

gcloud org-policies set-policy compute.requireOsLogin.json
gcloud org-policies describe compute.requireOsLogin --project ${PROJECT_ID} --format=json

# gcloud org-policies delete compute.requireOsLogin --project $PROJECT_ID


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