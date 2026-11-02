#!/bin/bash

echo "Testing cross-cluster connectivity challenges..."

# Get cluster information
echo "=== Development Cluster ==="
kubectl config use-context kind-dev-cluster
kubectl cluster-info
kubectl get nodes -o wide

echo "=== Staging Cluster ==="
kubectl config use-context kind-staging-cluster
kubectl cluster-info
kubectl get nodes -o wide

echo "=== Production Cluster ==="
kubectl config use-context kind-prod-cluster
kubectl cluster-info
kubectl get nodes -o wide

echo "=== Challenge: Clusters are isolated ==="
echo "Services in one cluster cannot directly communicate with services in another cluster"
echo "This requires additional networking solutions like service mesh or VPN"
