#!/bin/bash

CLUSTER_NAME="kubernetes"
CONTEXT=$(kubectl --kubeconfig ~/.kube/config config current-context)

echo "--- [LOCAL-PATH-PROVISIONER] Processing Local Path Provisioner for Cluster[$CLUSTER_NAME] and context $CONTEXT"

kubectl --context $CONTEXT create -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.26/deploy/local-path-storage.yaml
