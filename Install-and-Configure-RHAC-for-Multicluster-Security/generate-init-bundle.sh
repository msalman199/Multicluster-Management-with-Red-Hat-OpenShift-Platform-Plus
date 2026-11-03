#!/bin/bash

# Get admin password
ADMIN_PASSWORD=$(oc get secret central-htpasswd -n stackrox -o jsonpath='{.data.password}' | base64 -d)
CENTRAL_ROUTE=$(oc get route central -n stackrox -o jsonpath='{.spec.host}')

# Generate init bundle
curl -k -X POST \
  -u admin:$ADMIN_PASSWORD \
  -H "Content-Type: application/json" \
  -d '{"name": "'"$CLUSTER_NAME"'"}' \
  https://$CENTRAL_ROUTE/v1/cluster-init/init-bundles \
  -o init-bundle-response.json

# Extract the bundle
cat init-bundle-response.json | jq -r '.kubectlBundle' | base64 -d > cluster-init-bundle.yaml

echo "Init bundle generated successfully"
