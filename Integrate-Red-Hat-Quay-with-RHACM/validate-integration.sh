#!/bin/bash

echo "=== Validating Quay-RHACM Integration ==="

# Check Quay connectivity
echo "1. Testing Quay registry connectivity..."
curl -k -s https://quay-registry.apps.cluster.local/health/instance | grep -q "healthy" && echo "✓ Quay registry is healthy" || echo "✗ Quay registry issue"

# Check RHACM policies
echo "2. Checking RHACM policies..."
POLICY_COUNT=$(oc get policies -n rhacm-image-management --no-headers | wc -l)
echo "✓ Found $POLICY_COUNT image management policies"

# Check image pull secrets
echo "3. Validating image pull secrets..."
oc get secret quay-registry-secret -n quay-integration >/dev/null 2>&1 && echo "✓ Image pull secret exists" || echo "✗ Image pull secret missing"

# Check sample application
echo "4. Checking sample application deployment..."
READY_PODS=$(oc get pods -n quay-integration -l app=quay-sample-app --no-headers | grep Running | wc -l)
echo "✓ $READY_PODS sample application pods running"

# Check policy compliance
echo "5. Verifying policy compliance..."
COMPLIANT_POLICIES=$(oc get policies -n rhacm-image-management --no-headers | grep -c "Compliant")
echo "✓ $COMPLIANT_POLICIES policies are compliant"

echo "=== Integration validation complete ==="
