#!/bin/bash

ZONE=$(terraform output -json | jq -r .zone.value)
NAME=$(terraform output -json | jq -r .cluster_name.value)
gcloud container clusters get-credentials $NAME --zone $ZONE
