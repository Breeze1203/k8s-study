apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP_NAME}
spec:
  replicas: 3
  selector:
    matchLabels:
      app: ${APP_NAME}
  template:
    metadata:
      labels:
        app: ${APP_NAME}
    spec:
      containers:
      - name: ${APP_NAME}
        image: ${APP_NAME}:latest
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: ${APP_PORT}
        envFrom:
        - configMapRef:
            name: ${APP_NAME}-config
        - secretRef:
            name: ${APP_NAME}-secret
