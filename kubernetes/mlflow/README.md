# Deploying MLflow on Kubernetes using Helm

## live Demo

And MLFLow instance is running at: http://a86fe38cbd0214348a9553cebf3cbb64-1653838400.us-east-1.elb.amazonaws.com
credentials are:

- username: admin
- password: abcdef123456!

Feel free to login and explore the instance.

## Setting Up MLflow on Kubernetes

### Requirements

- EKS cluster
- Helm installed and configured to use your EKS cluster
- kubectl installed and configured to use your EKS cluster
- External Secrets installed and configured in your EKS cluster
- AWS secrets created in AWS Secrets Manager or AWS Systems Manager Parameter Store for:
  - PostgreSQL database credentials
  - AWS credentials with access to S3 bucket
  - MLflow tracking server credentials

### Deploy MLflow

Clone this repository and navigate to the `kubernetes/mlflow` directory:

```bash
git clone https://github.com/gAmadorH/microsoft-azure-predictive-maintenance.git
cd microsoft-azure-predictive-maintenance/kubernetes/mlflow
```

Simply add mlflow chart repository and install the chart with the following commands:

```bash
helm repo add community-charts https://community-charts.github.io/helm-charts
helm repo update
helm install mlflow community-charts/mlflow -f mlflow-values.yaml
```

And That's it! MLflow should now be deployed on your Kubernetes cluster. 

You can verify the deployment by checking the mlflow deployment:

```bash
kubectl get deploy mlflow
```

and check the external IP of the load balancer service:

```bash
kubectl get svc kubectl get svc mlflow
```

Verify mlflow values:

```bash
helm get values mlflow
```

To update the mlflow deployment with new values, you can use the following command:

```bash
helm upgrade mlflow community-charts/mlflow -f mlflow-values.yml
```

### Check secrets

In case you need to check the secrets created in your cluster, you can use the following commands:

For AWS credentials:

```bash
kubectl get secrets aws-credentials -o jsonpath='{.data.access_key_id}' | base64 --decode
kubectl get secrets aws-credentials -o jsonpath='{.data.secret_access_key}' | base64 --decode
```

For PostgreSQL credentials:

```bash
kubectl get secrets postgres-db-credentials -o jsonpath='{.data.username}' | base64 --decode
kubectl get secrets postgres-db-credentials -o jsonpath='{.data.password}' | base64 --decode
```

 For MLflow tracking server credentials:

```bash
kubectl get secrets mlflow-tracking -o jsonpath='{.data.MLFLOW_TRACKING_USERNAME}' | base64 --decode
kubectl get secrets mlflow-tracking -o jsonpath='{.data.MLFLOW_TRACKING_PASSWORD}' | base64 --decode
```

Just to make sure everything is working fine, and credential were synced correctly from AWS Secrets Manager or AWS Systems Manager to Kubernetes secrets.
