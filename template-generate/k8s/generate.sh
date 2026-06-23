#!/bin/bash
set -e

ENV_FILE=$1
OUT_DIR=./output

if [ ! -f "$ENV_FILE" ]; then
  echo "env not found"
  exit 1
fi

mkdir -p $OUT_DIR

export $(grep -v '^#' $ENV_FILE | xargs)

render() {
  envsubst < $1
}

render k8s/configmap.yaml.tpl > $OUT_DIR/configmap.yaml
render k8s/secret.yaml.tpl > $OUT_DIR/secret.yaml
render k8s/deployment.yaml.tpl > $OUT_DIR/deployment.yaml
render k8s/service.yaml.tpl > $OUT_DIR/service.yaml

echo "done"
