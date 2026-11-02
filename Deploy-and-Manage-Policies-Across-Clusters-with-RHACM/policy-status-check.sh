#!/bin/bash

echo "=== RHACM Policy Management Status Check ==="
echo "Timestamp: $(date)"
echo ""

# Check hub cluster connection
echo "1. Hub Cluster Connection:"
oc whoami --show-server
echo ""

# List all policies
echo "2. Deployed Policies:"
oc get policies -n policies -o custom-columns=NAME:.metadata.name,STATUS:.status.compliant,REMEDIATION:.spec.remediationAction
echo ""

# Check managed clusters
echo "3. Managed Clusters:"
oc get managedclusters -o custom-columns=NAME:.metadata.name,STATUS:.status.conditions[0].type,AVAILABLE:.status.conditions[0].status
echo ""

# Policy compliance summary
echo "4. Policy Compliance Summary:"
total_policies=$(oc get policies -n policies --no-headers | wc -l)
compliant_policies=$(oc get policies -n policies -o jsonpath='{.items[?(@.status.compliant=="Compliant")].metadata.name}' | wc -w)
non_compliant_policies=$((total_policies - compliant_policies))

echo "  Total Policies: $total_policies"
echo "  Compliant: $compliant_policies"
echo "  Non-Compliant: $non_compliant_policies"
echo ""

# Detailed policy status
echo "5. Detailed Policy Status:"
for policy in $(oc get policies -n policies -o jsonpath='{.items[*].metadata.name}'); do
  echo "  Policy: $policy"
  status=$(oc get policy $policy -n policies -o jsonpath='{.status.compliant}')
  remediation=$(oc get policy $policy -n policies -o jsonpath='{.spec.remediationAction}')
  echo "    Status: $status"
  echo "    Remediation: $remediation"
  echo ""
done
