#!/usr/bin/env bash
set -euo pipefail

# Script để triển khai hoặc nâng cấp hệ thống monitoring bằng Helm

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VALUES_FILE="$ROOT_DIR/infra/monitoring/values.yaml"
RELEASE_NAME="prometheus"
NAMESPACE="autoops"
CHART_NAME="prometheus-community/kube-prometheus-stack"

# Thêm Helm repo nếu chưa có
if ! helm repo list | grep -q "prometheus-community"; then
  echo "Adding prometheus-community Helm repo..."
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update
else
  echo "Prometheus-community repo already exists."
fi

echo "Deploying/Upgrading Monitoring Stack..."

# Lệnh helm upgrade --install sẽ cài đặt nếu chưa có, hoặc nâng cấp nếu đã tồn tại
helm upgrade --install "$RELEASE_NAME" "$CHART_NAME" \
  --namespace "$NAMESPACE" \
  --create-namespace \
  -f "$VALUES_FILE"

echo "✅ Monitoring stack deployment initiated."
echo "Grafana Ingress: http://grafana.autoops.local"
echo "Prometheus Ingress: http://prometheus.autoops.local"
echo "Check status with: helm status $RELEASE_NAME -n $NAMESPACE"