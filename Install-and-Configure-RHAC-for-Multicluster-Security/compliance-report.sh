#!/bin/bash

ADMIN_PASSWORD=$(oc get secret central-htpasswd -n stackrox -o jsonpath='{.data.password}' | base64 -d)
CENTRAL_ROUTE=$(oc get route central -n stackrox -o jsonpath='{.spec.host}')

# Generate compliance report
curl -k -X GET \
  -u admin:$ADMIN_PASSWORD \
  -H "Accept: application/json" \
  "https://$CENTRAL_ROUTE/v1/compliance/results" \
  -o compliance-report.json

# Generate vulnerability report
curl -k -X GET \
  -u admin:$ADMIN_PASSWORD \
  -H "Accept: application/json" \
  "https://$CENTRAL_ROUTE/v1/images" \
  -o vulnerability-report.json

echo "Reports generated:"
echo "- compliance-report.json"
echo "- vulnerability-report.json"

# Display summary
echo "=== Compliance Summary ==="
cat compliance-report.json | jq '.results[] | {standard: .evidence.standard, status: .evidence.state}'

echo "=== Vulnerability Summary ==="
cat vulnerability-report.json | jq '.images[] | {name: .name.fullName, cves: (.scan.components[] | length)}'
