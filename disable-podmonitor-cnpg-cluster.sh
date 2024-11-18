#!/bin/bash

set -x 
set -euo pipefail

source variables.sh

PATCH_FILE="$(pwd)/manifests/remove-patch-prometheus.yaml"


kubectl delete podmonitors --all -n $NS_CLUSTER

kubectl patch prometheus prometheus-kube-prometheus-prometheus -n prometheus-system --type merge --patch-file $PATCH_FILE


restart(){
    # Restart the Prometheus operator deployment
    kubectl rollout restart deployment/prometheus-kube-prometheus-operator -n prometheus-system
    kubectl rollout restart statefulset/prometheus-prometheus-kube-prometheus-prometheus -n prometheus-system

    # Check rollout status
    kubectl rollout status deployment/prometheus-kube-prometheus-operator -n prometheus-system
    kubectl rollout status statefulset/prometheus-prometheus-kube-prometheus-prometheus -n prometheus-system

}

delete(){
    # Delete the Prometheus (not preferred method of restart!)
    kubectl delete po -n prometheus-system $(kubectl get po -n prometheus-system --no-headers | grep prometheus-kube-prometheus-operator | awk -F' ' '{print $1}')
    kubectl delete po -n prometheus-system $(kubectl get po -n prometheus-system --no-headers | grep prometheus-0 | awk -F' ' '{print $1}')
}

delete;

#Saving current state of Prometheus Operator resource
kubectl get Prometheus -n prometheus-system -oyaml > prometheus-operator-current.yaml 

kubectl get po -n prometheus-system 

set +x 