#!/bin/bash

set -e

mkdir -p k8s
cd k8s


if [ $# -eq 0 ]; then
    echo "用法: $0 <service-name>"
    echo "示例: $0 crm-service"
    exit 1
fi

SERVICE_NAME=$1

SERVICE_DIR="k8s/${SERVICE_NAME}"

mkdir -p "${SERVICE_DIR}"

echo "生成 ${SERVICE_NAME} 模板..."

kubectl create deployment ${SERVICE_NAME} \
  --image=${SERVICE_NAME}:latest \
  --dry-run=client \
  -o yaml > ${SERVICE_DIR}/deployment.yaml

kubectl create service nodeport ${SERVICE_NAME} \
  --tcp=8080:8080 \
  --dry-run=client \
  -o yaml > ${SERVICE_DIR}/service.yaml

kubectl create configmap ${SERVICE_NAME}-config \
  --from-literal=APP_NAME=${SERVICE_NAME} \
  --from-literal=APP_PORT=8080 \
  --dry-run=client \
  -o yaml > ${SERVICE_DIR}/configmap.yaml

kubectl create secret generic ${SERVICE_NAME}-secret \
  --from-literal=username=root \
  --from-literal=password=123456 \
  --dry-run=client \
  -o yaml > ${SERVICE_DIR}/secret.yaml

echo "完成: ${SERVICE_DIR}"