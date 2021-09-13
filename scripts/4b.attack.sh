#!/usr/bin/env bash

PROJECT_ID="mitre-secure"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="get(projectNumber)")
gcloud config set project $PROJECT_ID

# auth
gcloud auth activate-service-account --key-file key2.json

# this fails to due constraints/gcp.resourceLocations (only allows: us-west1 and us-east1)
gcloud beta compute \
    --project=${PROJECT_ID} instances create instance-4 \
    --zone=us-central1-a --machine-type=e2-medium \
    --subnet=default --maintenance-policy=MIGRATE \
    --service-account=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image-family=debian-10 \
    --image-project=debian-cloud --boot-disk-size=10GB \
    --boot-disk-type=pd-balanced --boot-disk-device-name=instance-4 \
    --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

# this fails to due constraints/compute.vmExternalIpAccess (only allows: --no-address)
gcloud beta compute \
    --project=${PROJECT_ID} instances create instance-4 \
    --zone=us-west1-a --machine-type=e2-medium \
    --subnet=default --maintenance-policy=MIGRATE \
    --service-account=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image-family=debian-10 \
    --image-project=debian-cloud --boot-disk-size=10GB \
    --boot-disk-type=pd-balanced --boot-disk-device-name=instance-4 \
    --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any

# this is allowed, but then we realize we don't have internet access
gcloud beta compute \
    --project=${PROJECT_ID} instances create instance-4 \
    --zone=us-west1-a --machine-type=e2-medium \
    --subnet=default --maintenance-policy=MIGRATE \
    --service-account=${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image-family=debian-10 \
    --image-project=debian-cloud --boot-disk-size=10GB \
    --boot-disk-type=pd-balanced --boot-disk-device-name=instance-4 \
    --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any \
    --metadata=startup-script=apt-get\ update$'\n'apt-get\ install\ -y\ apache2\ telnet \
    --no-address

# VM UP, but no internet??? let's create a nat
gcloud compute routers create crx-usw1 --network=default \
    --region us-west1 \
    --advertisement-mode=default --asn=64512 --description "Create to allow internet access for Cloud NAT"

# blocked by constraints/compute.restrictCloudNATUsage (NAT creation only allowed in us-central1 and us-east4 default subnets)
gcloud compute routers nats create natx-usw1 \
    --router=crx-usw1 \
    --region us-west1 \
    --auto-allocate-nat-external-ips \
    --nat-all-subnet-ip-ranges