#!/bin/bash

echo "=== Multi-Cluster Resource Usage Report ==="
echo "Generated at: $(date)"
echo ""

for cluster in dev-cluster staging-cluster prod-cluster; do
    echo "=== $cluster ==="
    kubectl config use-context kind-$cluster
    
    echo "Nodes:"
    kubectl get nodes -o custom-columns=NAME:.metadata.name,STATUS:.status.conditions[-1].type,ROLES:.metadata.labels.node-role\.kubernetes\.io/control-plane,AGE:.metadata.creationTimestamp
    
    echo ""
    echo "Resource Usage:"
    kubectl top nodes 2>/dev/null || echo "Metrics server not available"
    
    echo ""
    echo "Pods by Namespace:"
    kubectl get pods --all-namespaces --no-headers | awk '{print $1}' | sort | uniq -c | sort -nr
    
    echo ""
    echo "Services:"
    kubectl get services --all-namespaces --no-headers | wc -l
    echo "Total Services: $(kubectl get services --all-namespaces --no-headers | wc -l)"
    
    echo ""
    echo "Deployments:"
    kubectl get deployments --all-namespaces --no-headers | wc -l
    echo "Total Deployments: $(kubectl get deployments --all-namespaces --no-headers | wc -l)"
    
    echo ""
    echo "----------------------------------------"
    echo ""
done
