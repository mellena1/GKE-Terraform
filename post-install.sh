#!/bin/bash

# Get kube config
if [ ! -d ~/.kube/configs ]; then
    echo "Creating ~/.kube/configs..."
    mkdir -p ~/.kube/configs
fi

# Get vars from terraform output
echo "Retrieving zone and name from tf output..."
ZONE=$(terraform output -json | jq -r .zone.value)
NAME=$(terraform output -json | jq -r .cluster_name.value)

# Get kubeconfig if it doesn't exist
if [ ! -f ~/.kube/configs/andrewmellenorg-gke ]; then
    echo "Getting cluster kubeconfig from gcloud..."
    KUBECONFIG=~/.kube/configs/andrewmellenorg-gke gcloud container clusters get-credentials $NAME --zone $ZONE &> /dev/null
fi

# Use sed to do replacement
echo "Changing name of config context..."
CUR_VAL="gke_"$NAME"_"$ZONE"_"$NAME
sed -i '' "s/$CUR_VAL/andrewmellenorg-gke/g" ~/.kube/configs/andrewmellenorg-gke
