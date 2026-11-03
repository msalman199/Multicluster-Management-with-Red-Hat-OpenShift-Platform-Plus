#!/bin/bash
set -uo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_environment_status() {
    local namespace=$1
    local label=$2

    echo -e "${BLUE}=== ${label} (namespace: ${namespace}) ===${NC}"

    echo -e "${YELLOW}Deployment:${NC}"
    oc get deployment frontend-app -n "${namespace}" 2>/dev/null || echo "  deployment not found"

    echo -e "${YELLOW}HPA:${NC}"
    oc get hpa frontend-hpa -n "${namespace}" 2>/dev/null || echo "  HPA not found"

    echo -e "${YELLOW}Pods:${NC}"
    oc get pods -n "${namespace}" -l app=frontend 2>/dev/null || echo "  no pods found"

    echo -e "${YELLOW}Resource usage:${NC}"
    oc top pods -n "${namespace}" -l app=frontend 2>/dev/null || echo "  metrics not available"

    echo ""
}

generate_report() {
    local report_file="scaling-status-report-$(date +%Y%m%d-%H%M%S).txt"

    {
        echo "Multicluster Scaling Status Report"
        echo "Generated: $(date)"
        echo "===================================="
        echo ""
        print_environment_status "frontend-dev" "Development (spoke-1)"
        print_environment_status "frontend-prod" "Production (spoke-2)"
        echo "Notes:"
        echo "------"
        echo "1. Compare replica counts against HPA minReplicas/maxReplicas bounds."
        echo "2. Investigate any HPA showing <unknown> targets; this usually means"
        echo "   the metrics API or resource requests are missing."
        echo "3. Review ArgoCD sync status with: oc get applications -n openshift-gitops"
    } > "${report_file}"

    echo -e "${GREEN}Report saved to: ${report_file}${NC}"
}

case "${1:-}" in
    status)
        print_environment_status "frontend-dev" "Development (spoke-1)"
        print_environment_status "frontend-prod" "Production (spoke-2)"
        ;;
    report)
        generate_report
        ;;
    watch)
        while true; do
            clear
            echo -e "${GREEN}=== Multicluster Scaling Monitor ($(date)) ===${NC}"
            print_environment_status "frontend-dev" "Development (spoke-1)"
            print_environment_status "frontend-prod" "Production (spoke-2)"
            echo -e "${BLUE}Refreshing in 30 seconds... (Ctrl+C to stop)${NC}"
            sleep 30
        done
        ;;
    *)
        echo "Usage: $0 {status|report|watch}"
        echo ""
        echo "  status  Print a one-time snapshot of both environments"
        echo "  report  Save a timestamped status report to a text file"
        echo "  watch   Continuously refresh the status every 30 seconds"
        exit 1
        ;;
esac
