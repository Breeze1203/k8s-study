apiVersion: v1
kind: ConfigMap
metadata:
  name: ${APP_NAME}-config
data:
  APP_NAME: ${APP_NAME}
  APP_PORT: "${APP_PORT}"
  DB_HOST: ${DB_HOST}
  DB_PORT: "${DB_PORT}"
  LOG_LEVEL: ${LOG_LEVEL}
