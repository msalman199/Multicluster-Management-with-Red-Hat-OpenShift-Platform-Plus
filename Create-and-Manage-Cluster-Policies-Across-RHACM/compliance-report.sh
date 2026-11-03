#!/bin/bash

echo "=== RHACM Policy Compliance Report ==="
echo "Generated on: $(date)"
echo

# Get cluster information
echo "Managed Clusters:"
oc get managedclusters -o custom-columns="NAME:.metadata.name,STATUS:.status.conditions[?(@.type=='ManagedClusterConditionAvailable')].status,VERSION:.status.version.kubernetes"
echo

# Policy compliance overview
echo "Policy Compliance Overview:"
echo "=========================="

total_policies=$(oc get policies -n policy-management --no-headers | wc -l)
compliant_policies=$(oc get policies -n policy-management -o jsonpath='{.items[?(@.status.compliant=="Compliant")].metadata.name}' | wc -w)
non_compliant_policies=$(oc get policies -n policy-management -o jsonpath='{.items[?(@.status.compliant=="NonCompliant")].metadata.name}' | wc -w)

echo "Total Policies: $total_policies"
echo "Compliant Policies: $compliant_policies"
echo "Non-Compliant Policies: $non_compliant_policies"
echo

# Detailed policy status
echo "Detailed Policy Status:"
echo "======================"
oc get policies -n policy-management -o custom-columns="POLICY:.metadata.name,REMEDIATION:.spec.remediationAction,COMPLIANT:.status.compliant,CLUSTERS:.status.placement[*].placementRule"
echo

# Policy set status
echo "Policy Set Status:"
echo "=================="
oc get policysets -n policy-management -o custom-columns="NAME:.metadata.name,POLICIES:.spec.policies[*]"
