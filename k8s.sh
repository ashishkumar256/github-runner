apiVersion: v1
kind: Secret
metadata:
  name: github-runner-secrets
type: Opaque
stringData:
  RUNNER_URL: "https://github.com/ashishkumar256/terrateam-demo"
  RUNNER_TOKEN: "<YOUR_TOKEN>"
  RUNNER_NAME: "controlplane"
  RUNNER_GROUP: "Default"
  RUNNER_LABELS: "infra"
  RUNNER_WORKDIR: "_work"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: github-runner
spec:
  replicas: 1
  selector:
    matchLabels:
      app: github-runner
  template:
    metadata:
      labels:
        app: github-runner
    spec:
      containers:
      - name: runner
        image: your-registry/github-runner:latest
        envFrom:
        - secretRef:
            name: github-runner-secrets
        volumeMounts:
        - name: runner-work
          mountPath: /data
      volumes:
      - name: runner-work
        emptyDir: {}
