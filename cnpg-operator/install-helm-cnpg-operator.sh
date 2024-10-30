#!/bin/bash

VALUES="custom-values-cnpg-operator.yaml"

helm repo add cnpg https://cloudnative-pg.github.io/charts

helm upgrade --install cnpg cnpg/cloudnative-pg \
    --namespace cnpg-system --create-namespace \
    -f $VALUES --wait --debug
    
