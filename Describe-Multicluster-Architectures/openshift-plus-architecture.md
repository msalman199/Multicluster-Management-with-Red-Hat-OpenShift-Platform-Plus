# OpenShift Platform Plus Multicluster Architecture

## Core Components

### 1. Red Hat Advanced Cluster Management (RHACM)
- **Hub Cluster**: Central management cluster
- **Managed Clusters**: Target clusters being managed
- **Klusterlet**: Agent running on managed clusters

### 2. Red Hat Advanced Cluster Security (RHACS)
- **Central**: Security management console
- **Sensor**: Security monitoring on each cluster
- **Collector**: Runtime data collection

### 3. Red Hat Quay
- **Container Registry**: Centralized image management
- **Security Scanning**: Vulnerability assessment
- **Image Signing**: Supply chain security

## Key Benefits

### Centralized Management
- Single pane of glass for all clusters
- Unified application lifecycle management
- Centralized policy enforcement

### Enhanced Security
- Continuous security monitoring
- Policy-as-code implementation
- Compliance reporting and remediation

### Improved Scalability
- Automated cluster provisioning
- Resource optimization across clusters
- Workload placement intelligence
