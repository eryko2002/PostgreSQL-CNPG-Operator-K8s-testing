#!/bin/bash

source variables.sh

# Check whether cnpg-cluster namespace exists, if not - create it!
if ! kubectl get ns $NS_CLUSTER > /dev/null 2>&1; then
    kubectl create -f manifests/ns-cnpg-cluster.yaml > /dev/null 2>&1
    echo "Namespace '$NS_CLUSTER' created successfully."
else
    echo "Namespace '$NS_CLUSTER' already exists."
fi
