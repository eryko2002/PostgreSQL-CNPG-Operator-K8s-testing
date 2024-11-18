#!/bin/bash

# Define base directory as the current working directory
BASE_DIR=$(pwd)

# Function to install or upgrade the Helm release
install_or_upgrade_cnpg_operator() {
    local values_file="$BASE_DIR/cnpg-operator/custom-values-cnpg-operator.yaml"
    
    echo "Adding Helm repository for CNPG..."
    helm repo add cnpg https://cloudnative-pg.github.io/charts

    echo "Installing or upgrading the CNPG operator..."
    helm upgrade --install cnpg cnpg/cloudnative-pg \
        --namespace cnpg-system --create-namespace \
        -f $values_file --wait --debug
}

# Function to check if all pods are Ready
wait_for_pods_ready() {
    local namespace="cnpg-system"

    echo "Waiting for all pods in namespace '$namespace' to become Ready..."

    while true; do
        local not_ready
        not_ready=$(kubectl get pods -n $namespace --no-headers | grep -v '1/1' | wc -l)
        
        if [ "$not_ready" -eq 0 ]; then
            echo "All pods in namespace '$namespace' are Ready!"
            break
        fi
        
        echo "Waiting for pods to become Ready..."
        sleep 5
    done
}

# Main function to orchestrate the steps
main() {
    echo "Base directory: $BASE_DIR"
    install_or_upgrade_cnpg_operator
    wait_for_pods_ready
}

# Execute the main function
main

