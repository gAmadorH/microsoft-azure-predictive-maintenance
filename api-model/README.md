# Predictive Model API

## requirements

- Docker and Docker compose
- MLFlow instance secrets:
  - MLFLOW_TRACKING_URI
  - MLFLOW_TRACKING_USERNAME
  - MLFLOW_TRACKING_PASSWORD
  - MLFLOW_MODEL_URI
- Minicube or any local kubernetes cluster (optional but recommended, just to run the inference API in kubernetes locally)

## Local Deployment with Docker Compose

Clone github repo

```bash
git clone https://github.com/gAmadorH/microsoft-azure-predictive-maintenance.git
```

Change directory to this folder:

```bash
cd microsoft-azure-predictive-maintenance/api-model
```

Create .env file with MLFlow secrets and edit values with the ones from your MLFlow instance
or just copy the example env file with my default values to connect to my MLFlow instance and there is an already a model registered there

```bash
cp .env.example .env
```

Build your Docker image

```bash
docker compose build --no-cache
 ```

Run the inference API using docker compose

```bash
docker compose up -d
```

Test health endpoint

```bash
curl http://0.0.0.0:8000/health 
```

Now test the predict API endpoint using the data in `testing-data` folder

```bash
curl -X POST http://0.0.0.0:8000/predict -H "Content-Type: application/json" -d @testing-data/dataset01.json
```

You should get a response like this:

```json
{
  "predictions": [[5348.92822265625],[2154.111328125],[5607.7734375]]
}
```

That's it! You have your predictive model API running locally using Docker Compose.

If you want to see the API logs in real-time, run:

```bash
docker compose logs inference-api -f
```

```bash
inference-api-1  | INFO:     Started server process [1]
inference-api-1  | INFO:     Waiting for application startup.
inference-api-1  | INFO:     Application startup complete.
inference-api-1  | INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
inference-api-1  | INFO:     192.168.65.1:41546 - "GET /health HTTP/1.1" 200 OK
inference-api-1  | INFO:     192.168.65.1:52856 - "GET /health HTTP/1.1" 200 OK
1/1 ━━━━━━━━━━━━━━━━━━━━ 0s 49ms/step
inference-api-1  | INFO:     192.168.65.1:63771 - "POST /predict HTTP/1.1" 200 OK
inference-api-1  | INFO:     Shutting down
inference-api-1  | INFO:     Waiting for application shutdown.
inference-api-1  | INFO:     Application shutdown complete.
inference-api-1  | INFO:     Finished server process [1]
inference-api-1  | INFO:     Started server process [1]
inference-api-1  | INFO:     Waiting for application startup.
inference-api-1  | INFO:     Application startup complete.
inference-api-1  | INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
1/1 ━━━━━━━━━━━━━━━━━━━━ 0s 54ms/step
inference-api-1  | INFO:     192.168.65.1:59949 - "POST /predict HTTP/1.1" 200 OK
1/1 ━━━━━━━━━━━━━━━━━━━━ 0s 23ms/step
inference-api-1  | INFO:     192.168.65.1:34149 - "POST /predict HTTP/1.1" 200 OK
1/1 ━━━━━━━━━━━━━━━━━━━━ 0s 38ms/step
inference-api-1  | INFO:     192.168.65.1:48616 - "POST /predict HTTP/1.1" 200 OK
```

To stop the docker compose services, run:

```bash
docker compose down
```

## Local Deployment with Kubernetes

Build your Docker image in the same `api-model` folder

```bash
docker build -t mlflow-fastapi:v1 .
```

check your image was created

```bash
docker images | grep mlflow-fastapi
```

Set your context to your local kubernetes cluster

```bash
kubectl config use-context docker-desktop
```

Verify your context

```bash
kubectl config current-context
```

Create the kubernetes secrets using the `.env` file to connect to your MLFlow instance

```bash
kubectl create secret generic mlflow-tracking --from-env-file=.env -n default

```

Verify the secrets were created

```bash
kubectl describe secret mlflow-tracking
```

Change your current directory to `kubernetes` folder in the root folder

```bash
cd ../kubernetes/api-model/
```

And then just apply the kubernetes manifests for:

- deployment
- service

```bash
kubectl apply -f deployment.yml 
kubectl apply -f service.yml
```

Test the API suing the data in `api-model/testing-data` folder

```bash
curl -X POST http://0.0.0.0:8000/predict -H "Content-Type: application/json" -d @../../api-model/testing-data/dataset01.json
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

To delete the deployment and service, run:

```bash
kubectl delete -f deployment.yml 
kubectl delete -f service.yml```

And remove the secrets

```bash
kubectl delete secret mlflow-tracking -n default
```
