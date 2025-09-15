# Predictive Model API on Kubernetes

## Prerequisites

- Docker
- AWS CLI configured with access to your AWS account
- EKS Kubernetes cluster, ECR repository
- External Secrets installed and configured in your EKS cluster
- AWS secrets created in AWS Secrets Manager or AWS Systems Manager Parameter Store for:
  - MLflow tracking server credentials

Check the FastAPI app Dockerfile in the `api-model` folder before continuing.
Preferably before continuing to run the model locally, using Docker and also Kubernetes locally

## Deploying to AWS ECR and Kubernetes

Clone repo and change directory

```bash
git clone https://github.com/gAmadorH/microsoft-azure-predictive-maintenance.git
```

Change to the `api-model` directory where the API model is located

```bash
cd api-model
```

Build Docker image in the `api-model` folder

```bash
docker build --platform linux/amd64 --no-cache -t mlflow-fastapi:latest .
```

Get your AWS account ID and set your AWS region where your ECR repo is located:

```bash
AWSAccountID=$(aws sts get-caller-identity --query Account --output text)
AWSRegion="us-east-1"
```

Login to your AWS ECR

```bash
aws ecr get-login-password --region ${AWSRegion} | docker login --username AWS --password-stdin ${AWSAccountID}.dkr.ecr.${AWSRegion}.amazonaws.com
```

Tag your local image to match your ECR repository

```bash
docker tag mlflow-fastapi:latest ${AWSAccountID}.dkr.ecr.${AWSRegion}.amazonaws.com/mlflow-fastapi:latest
```

Push your image to ECR

```bash
docker push ${AWSAccountID}.dkr.ecr.${AWSRegion}.amazonaws.com/mlflow-fastapi:latest
```

Change your current directory to `kubernetes` folder in the root folder

```bash
cd ../kubernetes/api-model/
```

And then just apply the kubernetes manifest for secrets:

```bash
kubectl apply -f external-secret.yml
```

And then deploy the deployment changing the image in the `deployment.yml` file to your ECR image

```yaml
kustomize edit set image mlflow-fastapi=${AWSAccountID}.dkr.ecr.${AWSRegion}.amazonaws.com/mlflow-fastapi:latest
```

Finally apply the service manifest

```bash
kubectl apply -f service.yml
```

Get the service URL

```bash
kubectl get svc
```

or just save the external IP to a variable

```bash
externalIP=$(kubectl get svc mlflow-inference-lb -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
```

Test the API suing the data in `api-model/testing-data` folder

```bash
curl -X POST http://$externalIP:8000/predict -H "Content-Type: application/json" -d @../../api-model/testing-data/dataset01.json
```
