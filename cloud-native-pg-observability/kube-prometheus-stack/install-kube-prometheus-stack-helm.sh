#!/bin/bash

# Add Prometheus Helm repo
echo "Adding Prometheus community helm repo..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Update the Helm repo
echo "Updating helm repo..."
helm repo update

# Install Prometheus with specific parameters
echo "Installing Prometheus using kube-prometheus-stack..."
helm install prometheus prometheus-community/kube-prometheus-stack -n prometheus-system --create-namespace -f curr-prometheus-stack-values-no-scraped-metrics.yaml \
    --set kubeStateMetrics.enabled=false \
    --set nodeExporter.enabled=false \
    --set kubelet.enabled=false \
    --set kubeApiServer.enabled=false \
    --set kubeControllerManager.enabled=false \
    --set coreDns.enabled=false \
    --set kubeDns.enabled=false \
    --set kubeEtcd.enabled=false \
    --set kubeScheduler.enabled=false \
    --set kubeProxy.enabled=false \
    --set sidecar.datasources.label=grafana_datasource \
    --set sidecar.datasources.labelValue="1" \
    --set sidecar.dashboards.enabled=true

echo "Prometheus installation complete."

