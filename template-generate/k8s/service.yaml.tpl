apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}
spec:
  type: NodePort
  selector:
    app: ${APP_NAME}
  ports:
  - port: ${APP_PORT}
    targetPort: ${APP_PORT}
    nodePort: 30080
