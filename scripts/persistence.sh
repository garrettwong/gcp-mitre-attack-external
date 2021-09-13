#!/usr/bin/env bash

function deploy_vm() {
    PROJECT_ID=$1
    ZONE=$2

    PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
    SERVICE_ACCOUNT_EMAIL="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"
    RAND=$(hexdump -n 2 -e '2/2 "%04X" 1 "\n"' /dev/random | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')

    gcloud beta compute --project=$PROJECT_ID \
        instances create instance-${RAND} \
        --zone=$ZONE \
        --machine-type=e2-medium \
        --subnet=default \
        --network-tier=PREMIUM \
        --metadata=startup-script=apt-get\ update$'\n'apt-get\ install\ -y\ apach2\ telnet \
        --maintenance-policy=MIGRATE \
        --service-account=$SERVICE_ACCOUNT_EMAIL \
        --scopes=https://www.googleapis.com/auth/cloud-platform \
        --image-family=debian-10 \
        --image-project=debian-cloud \
        --boot-disk-size=50GB \
        --boot-disk-type=pd-balanced \
        --boot-disk-device-name=instance-${RAND} \
        --shielded-secure-boot \
        --shielded-vtpm \
        --shielded-integrity-monitoring \
        --reservation-affinity=any
}
