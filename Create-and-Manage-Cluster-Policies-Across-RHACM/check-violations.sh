#!/bin/bash

echo "=== Policy Violation Report ==="
echo

# Switch back to hub cluster
oc config use-context hub-cluster

# Check for policy violations
for policy in $(oc get policies -n policy-management -o name); do
    policy_name=$(basename $policy)
    echo "Checking policy: $policy_name"
    
    # Get violation details
    violations=$(oc get $policy -n policy-management -o jsonpath='{.status.status[?(@.compliant=="NonCompliant")]}')
    
    if [ ! -z "$violations" ]; then
        echo "  VIOLATIONS FOUND:"
        oc get $policy -n policy-management -o jsonpath='{range .status.status[?(@.compliant=="NonCompliant")]}    Cluster: {.clustername} - {.compliant}{"\n"}{end}'
    else
        echo "  No violations found"
    fi
    echo
done

# Check overall compliance summary
echo "=== Compliance Summary ==="
oc get policies -n policy-management -o custom-columns="NAME:.metadata.name,COMPLIANT:.status.compliant"
