#!/bin/bash
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <environment> <replicas>"
    echo "Example: $0 development 4"
    exit 1
fi

ENVIRONMENT=$1
NEW_REPLICAS=$2
PATCH_FILE="applications/frontend/overlays/${ENVIRONMENT}/replica-patch.yaml"

if [ ! -f "${PATCH_FILE}" ]; then
    echo "Error: ${PATCH_FILE} does not exist. Valid environments: development, production"
    exit 1
fi

cat > "${PATCH_FILE}" << EOL
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-app
spec:
  replicas: ${NEW_REPLICAS}
EOL

git add "${PATCH_FILE}"
git commit -m "Scale frontend app in ${ENVIRONMENT} to ${NEW_REPLICAS} replicas"
git push origin main

echo "Scaling request committed for ${ENVIRONMENT}: ${NEW_REPLICAS} replicas."
echo "ArgoCD will reconcile the change automatically within its sync interval (default 3 minutes),"
echo "or trigger an immediate sync with: oc annotate application <app-name> -n openshift-gitops argocd.argoproj.io/refresh=hard --overwrite"

chmod +x scripts/scale-via-git.sh
