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
