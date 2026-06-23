#!/bin/bash
set -e

# generate deployment template
kubectl create deployment nginx \
  --image=nginx:latest \
  --dry-run=client \
  -o yaml > deployment.yaml

# generate service template
kubectl create service nodeport nginx \
  --tcp=80:80 \
  --dry-run=client \
  -o yaml > service.yaml

# generate configmap template
kubectl create configmap crm-config \
  --from-literal=DB_HOST=mysql \
  --from-literal=DB_PORT=3306 \
  --dry-run=client \
  -o yaml > configmap.yaml

# generate secret template
kubectl create secret generic mysql-secret \
  --from-literal=username=root \
  --from-literal=password=123456 \
  --dry-run=client \
  -o yaml > secret.yaml

echo "模板已生成："
ls -l *.yaml