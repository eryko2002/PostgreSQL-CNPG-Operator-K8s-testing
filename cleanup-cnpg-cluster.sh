#!/bin/bash

source variables.sh

# Define namespace
NAMESPACE=$NS_CLUSTER

# Function to check if the namespace exists
namespace_exists() {
    kubectl get ns "$NAMESPACE" >/dev/null 2>&1
}

# Confirm and delete resources
cleanup_resources() {
    echo "Cleaning up resources in namespace: $NAMESPACE"

     # Delete the resources managed by the Kustomization
    kubectl delete -k pgadmin4-manifests/ -n $NAMESPACE --grace-period=0 --force >/dev/null 2>&1

    # Delete all pods
    echo "Deleting all pods..."
    kubectl delete pods --all -n "$NAMESPACE" --grace-period=0 --force >/dev/null 2>&1

    # Delete all PVCs
    echo "Deleting all persistent volume claims..."
    kubectl delete pvc --all -n "$NAMESPACE" --grace-period=0 --force >/dev/null 2>&1

    # Delete all podmonitors 
    echo "Deleting all podmonitors..."
    if [[ $(kubectl get podmonitors -n "$NAMESPACE" 2>/dev/null) ]]; then
        ./disable-podmonitor-cnpg-cluster.sh  # Execute the disable script
    fi

    # Delete the namespace
    echo "Deleting namespace..."
    kubectl delete ns "$NAMESPACE" --grace-period=0 --force >/dev/null 2>&1

    
}

# Main execution
if namespace_exists; then
    read -p "Are you sure you want to delete all resources in namespace '$NAMESPACE'? (y/n): " confirm
    if [[ "$confirm" == [yY] ]]; then
        cleanup_resources
        echo "Cleanup completed."
    else
        echo "Cleanup aborted."
    fi
else
    echo "Namespace '$NAMESPACE' does not exist. No cleanup necessary."
fi

