#!/bin/bash

# Load variables
source variables.sh

# Set the namespace variable
NAMESPACE=$NS_CLUSTER

# Create the namespace if it does not exist
kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE

# Apply all resources in the specified namespace
cd pgadmin4-manifests/
kubectl kustomize . | kubectl apply -n $NAMESPACE -f -
cd ../

# Wait until all pgadmin pods are ready
echo "Waiting for pgadmin pods to be ready..."
kubectl wait --for=condition=ready pod -l app=pgadmin4 -n $NAMESPACE --timeout=300s

# Get the status of all resources
kubectl get all -n $NAMESPACE -l app=pgadmin4

