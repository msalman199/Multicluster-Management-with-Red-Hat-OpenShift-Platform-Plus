#!/bin/bash
# Summarize vulnerability scan results across all scanned images
set -euo pipefail

RESULTS_DIR="scan-results"
SUMMARY_FILE="vulnerability-summary.txt"

echo "=== Vulnerability Scan Summary ===" > "${SUMMARY_FILE}"
echo "Generated: $(date)" >> "${SUMMARY_FILE}"
echo "" >> "${SUMMARY_FILE}"

for FILE in "${RESULTS_DIR}"/*.json; do
  IMAGE_NAME=$(jq -r '.result.image.name.fullName // "unknown"' "${FILE}")
  CRITICAL=$(jq '.result.summary.CRITICAL_VULNERABILITY_SEVERITY // 0' "${FILE}")
  IMPORTANT=$(jq '.result.summary.IMPORTANT_VULNERABILITY_SEVERITY // 0' "${FILE}")
  MODERATE=$(jq '.result.summary.MODERATE_VULNERABILITY_SEVERITY // 0' "${FILE}")
  LOW=$(jq '.result.summary.LOW_VULNERABILITY_SEVERITY // 0' "${FILE}")

  echo "Image: ${IMAGE_NAME}" >> "${SUMMARY_FILE}"
  echo "  Critical: ${CRITICAL}  Important: ${IMPORTANT}  Moderate: ${MODERATE}  Low: ${LOW}" >> "${SUMMARY_FILE}"
  echo "" >> "${SUMMARY_FILE}"
done

echo "Summary written to ${SUMMARY_FILE}"
cat "${SUMMARY_FILE}"
