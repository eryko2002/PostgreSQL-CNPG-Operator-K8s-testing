#!/bin/bash

set -x 
set -euo pipefail

# Source the environment variables from variables.sh
source variables.sh

# Apply the PodMonitor resource
cd manifests/
envsubst < ./podmonitor-cnpg-cluster.tmpl > ./podmonitor-cnpg-cluster.yaml
kubectl apply -f ./podmonitor-cnpg-cluster.yaml  # Correct the command to apply the generated YAML
envsubst < ./patch-prometheus.tmpl > ./patch-prometheus.yaml
cd ..

kubectl get podmonitor -n $NS_CLUSTER --show-labels

kubectl patch prometheus prometheus-kube-prometheus-prometheus -n prometheus-system --type merge --patch-file manifests/patch-prometheus.yaml


# Restart the Prometheus operator deployment
kubectl rollout restart deployment/prometheus-kube-prometheus-operator -n prometheus-system
kubectl rollout restart statefulset/prometheus-prometheus-kube-prometheus-prometheus -n prometheus-system

#kubectl delete po -n prometheus-system $(kubectl get po -n prometheus-system --no-headers | grep prometheus-kube-prometheus-operator | awk -F' ' '{print $1}')
#kubectl delete po -n prometheus-system $(kubectl get po -n prometheus-system --no-headers | grep prometheus-0 | awk -F' ' '{print $1}')

# Check rollout status
kubectl rollout status deployment/prometheus-kube-prometheus-operator -n prometheus-system
kubectl rollout status statefulset/prometheus-prometheus-kube-prometheus-prometheus -n prometheus-system

#Saving current state of Prometheus Operator resource
kubectl get Prometheus -n prometheus-system -oyaml > prometheus-operator-current.yaml 

kubectl get po -n prometheus-system 


set +x