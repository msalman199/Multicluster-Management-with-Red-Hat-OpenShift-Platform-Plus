#!/bin/bash
# Generate a readable compliance summary from RHACS aggregation results
set -euo pipefail

INPUT_FILE="cis-compliance-results.json"
REPORT_FILE="cis-compliance-report.txt"

echo "=== CIS Kubernetes Benchmark Compliance Report ===" > "${REPORT_FILE}"
echo "Generated: $(date)" >> "${REPORT_FILE}"
echo "" >> "${REPORT_FILE}"

TOTAL_PASS=$(jq '[.[] | .numPassing] | add // 0' "${INPUT_FILE}")
TOTAL_FAIL=$(jq '[.[] | .numFailing] | add // 0' "${INPUT_FILE}")
TOTAL=$((TOTAL_PASS + TOTAL_FAIL))

echo "Total controls evaluated: ${TOTAL}" >> "${REPORT_FILE}"
echo "Passing: ${TOTAL_PASS}" >> "${REPORT_FILE}"
echo "Failing: ${TOTAL_FAIL}" >> "${REPORT_FILE}"

if [ "${TOTAL}" -gt 0 ]; then
  SCORE=$(( (TOTAL_PASS * 100) / TOTAL ))
  echo "Compliance score: ${SCORE}%" >> "${REPORT_FILE}"
fi

echo "" >> "${REPORT_FILE}"
echo "Per-category breakdown:" >> "${REPORT_FILE}"
jq -r '.[] | "  Category: \(.aggregationKeys | join(" / "))  Pass: \(.numPassing)  Fail: \(.numFailing)"' \
  "${INPUT_FILE}" >> "${REPORT_FILE}"

echo "Report written to ${REPORT_FILE}"
cat "${REPORT_FILE}"
