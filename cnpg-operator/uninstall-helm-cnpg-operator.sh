#!/bin/bash

# Define variables
NS_OPERATOR="cnpg-system"  # Namespace where the CNPG operator is installed
RELEASE_OPERATOR="cnpg"

# Uninstall the CNPG operator Helm chart
helm uninstall $RELEASE_OPERATOR --namespace $NS_OPERATOR
echo "Helm release '$RELEASE_OPERATOR' uninstalled from namespace '$NS_OPERATOR'."

# Optional: Delete the namespace if you want to remove it entirely
# Uncomment the following line if you wish to delete the namespace
# kubectl delete namespace $NS_OPERATOR

echo "CNPG operator uninstallation complete."

