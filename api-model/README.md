# Predictive Model API

## requirements

- Docker and Docker compose
- MLFlow instance secrets:
  - MLFLOW_TRACKING_URI
  - MLFLOW_TRACKING_USERNAME
  - MLFLOW_TRACKING_PASSWORD
  - MLFLOW_MODEL_URI
-  Minicube or any local kubernetes cluster (optional, just to run api in kubernetes locally)

## Local Deployment with Docker Compose

Clone github repo

```bash
git clone
```

Change directory

```bash
cd microsoft-azure-predictive-maintenance/api-model
```

Create .env file with MLFlow secrets and edit values with the ones from your MLFlow instance
or just copy the example env file with my default values to connect to my MLFlow instance and there is an already a model registered there

```bash
cp .env.example .env
```

Run API using docker compose

```bash
docker compose up
```

Open another terminal and test the API suing the data in `api-model/testing-data` folder

```bash
curl -X POST http://0.0.0.0:8000/predict -H "Content-Type: application/json" -d @api-model/testing-data/dataset01.json
```

You should get a response like this:

```json
{
  "predictions": [[5348.92822265625],[2154.111328125],[5607.7734375]]
}
```

Thant's it! You have your predictive model API running locally using Docker Compose.

## Local Deployment with Kubernetes

Change your current directory

```bash
cd kubernetes/api-model
```

Build your Docker image

```bash
docker build -t mlflow-fastapi .
```

Set your context to your local kubernetes cluster

```bash
kubectl config use-context minikube
```

Create the kubernetes secrets using the `.env` file to connect to your MLFlow instance

```bash
kubectl create secret generic mlflow-tracking --from-env-file=.env -n default

```

And then just apply the kubernetes manifests

```bash
kubectl apply -f kubernetes/main.yml
```

Open another terminal and test the API suing the data in `api-model/testing-data` folder

```bash
curl -X POST http://0.0.0.0:8000/predict -H "Content-Type: application/json" -d @api-model/testing-data/dataset01.json
```

You should get a response like this:

```json
{
  "predictions": [[5348.92822265625],[2154.111328125],[5607.7734375]]
}
```

If you want to see the deployment logs, run:

```bash
kubectl logs deployment/mlflow-inference -f  
```

You will see something like this:

```bash
INFO:     Started server process [1]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     10.1.0.1:63746 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:63756 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:64766 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:57042 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:57058 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:63012 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:62818 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:62826 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:58784 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:63728 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:63744 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:64288 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:63190 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:63192 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:64338 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:57012 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:57026 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:61754 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:60136 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:60142 - "GET /health HTTP/1.1" 200 OK
1/1 ━━━━━━━━━━━━━━━━━━━━ 0s 116ms/step
INFO:     192.168.65.3:57734 - "POST /predict HTTP/1.1" 200 OK
INFO:     10.1.0.1:60628 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:57954 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:57962 - "GET /health HTTP/1.1" 200 OK
INFO:     10.1.0.1:57432 - "GET /health HTTP/1.1" 200 OK
```
