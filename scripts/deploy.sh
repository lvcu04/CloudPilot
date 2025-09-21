#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
kubectl apply -f "$ROOT_DIR/infra/k8s/namespace.yaml"
kubectl apply -f "$ROOT_DIR/infra/k8s/postgres-secret.yaml"
kubectl apply -f "$ROOT_DIR/infra/k8s/postgres-pvc.yaml"
kubectl apply -f "$ROOT_DIR/infra/k8s/postgres-deployment.yaml"
kubectl apply -f "$ROOT_DIR/infra/k8s/restic-credentials.yaml"
kubectl apply -f "$ROOT_DIR/infra/k8s/sample-api-deployment.yaml"
kubectl apply -f "$ROOT_DIR/infra/k8s/sample-api-service.yaml"
kubectl apply -f "$ROOT_DIR/infra/k8s/restic-backup-cronjob.yaml"
echo "Applied manifests. Check status with: kubectl -n autoops get all"
