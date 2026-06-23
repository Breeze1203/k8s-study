apiVersion: v1
kind: Secret
metadata:
  name: ${APP_NAME}-secret
type: Opaque
stringData:
  DB_USER: ${DB_USER}
  DB_PASSWORD: ${DB_PASSWORD}
