# Remaining Useful Life Prediction

This project analyzes equipment sensor data to predict the remaining useful life (RUL) of machines using machine learning techniques.  

## Project Structure

- `nb` folder: Contains Jupyter notebooks for data exploration, preprocessing, and model training.
- `kubernetes` folder: Contains Kubernetes manifests and Helm charts for deploying MLflow and FastAPI services.
- `infra` folder: Contains Terraform scripts for provisioning AWS infrastructure.
- `api-model` folder: Contains the FastAPI application code for serving the ML model.

## Suggested Repo exploration Order:

- `nb` folder: Start with the notebooks to understand the data and model development process.
- `infra` folder: Review the Terraform scripts to see how the AWS infrastructure is set up.
- `kubernetes` folder: Explore the Kubernetes setup.
- `kubernetes/mlflow` folder: Focus on the MLflow deployment specifics to have a working tracking server.
- `api-model` folder Check out the FastAPI application code for model serving and pull our trained model and test it locally using Docker Compose and Kubernetes locally
- `kubernetes/api-model` folder: Finally, look at the Kubernetes manifests for deploying the FastAPI service.
