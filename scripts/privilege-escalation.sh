#!/usr/bin/env bash

# requires an account with organization policy administrator

function __get_org_id() {
  ORG_ID=$(gcloud organizations list --format='value(ID)')
  echo $ORG_ID
}

function org_policy_list() {
  ORG_ID=$(__get_org_id)
  gcloud beta resource-manager org-policies list --organization $ORG_ID
}

function org_iam_policy_modify() {
  PROJECT_ID=$1

  gcloud beta resource-manager org-policies \
    enable-enforce  compute.disableSerialPortAccess \
    --project=$PROJECT_ID
}

