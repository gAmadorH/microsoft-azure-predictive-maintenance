# Prepare Kubernetes Cluster

EKS cluster was deployed to deploy 2 applications:

- MLflow inference service, in `kubernetes/mlflow` folder
- Inference API service, in `kubernetes/api-model` folder

Both application depends on secrets (database connection strings, mlflow credentials, etc), so first of all so we need to install External Secrets in our cluster, then create the secrets and finally deploy both applications.
We will use External Secrets to manage sensitive information like database connection strings and MLflow credentials.

External secrets allows us to use AWS Secrets Manager or AWS Systems Manager Parameter Store to securely inject secrets into Kubernetes pods so infra project in this repo must be explored before deploying the applications.

## Install External Secrets

```bash
helm repo add external-secrets https://charts.external-secrets.io
helm repo update
helm install external-secrets external-secrets/external-secrets \
  -n external-secrets \
  --create-namespace \
  --version 0.16.1 \
  --set installCRDs=true
```

Verify installation:

```bash
kubectl get crd secretstores.external-secrets.io
```
