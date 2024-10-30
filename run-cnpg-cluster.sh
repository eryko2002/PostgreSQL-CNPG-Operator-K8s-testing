#!/bin/bash

#load variables
source variables.sh

# Set the namespace variable
NAMESPACE=$NS_CLUSTER

# Create the namespace if it does not exist
kubectl get namespace $NAMESPACE || kubectl create namespace $NAMESPACE

# Apply all resources in the specified namespace
cd manifests/
kubectl kustomize . | kubectl apply -n $NAMESPACE -f -
cd ../

kubectl get po -n $NS_CLUSTER -w