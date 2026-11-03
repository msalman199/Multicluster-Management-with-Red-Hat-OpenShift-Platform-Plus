#!/bin/bash

echo "=== Policy Compliance Status ==="
echo

for policy in $(oc get policies -n policy-management -o name); do
    policy_name=$(basename $policy)
    echo "Policy: $policy_name"
    
    # Get compliance status
    compliance=$(oc get $policy -n policy-management -o jsonpath='{.status.compliant}')
    echo "  Overall Compliance: $compliance"
    
    # Get per-cluster compliance
    echo "  Per-cluster status:"
    oc get $policy -n policy-management -o jsonpath='{range .status.status[*]}    {.clustername}: {.compliant}{"\n"}{end}'
    echo
done
