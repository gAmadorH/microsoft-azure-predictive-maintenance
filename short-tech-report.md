# Short Tech Report - Remaining Useful Life Prediction

## Results obtained

- Status: ✅ achieved

## Key decisions

- D1: Use FastAPI for model serving — *lightweight, async, easy to deploy with Docker*.
- D2: Dockerize the application — *ensures consistency across environments*.
- D3: MLFLow for experiment tracking — *centralized model management*.
- D4: Use MLFlow in front of s3 for model storage — *Model centralization and versioning*.
- D5: Use existing AWS Secrets Manager secrets for sensitive data in Helm charts — *Avoid hardcoding sensitive data*.

## Trade-offs

- Not use KServe - *FastAPi does not provide out-of-the-box features like model versioning, scaling, and monitoring*.
- helm charts depends on existing AWS Secrets Manager secrets - *Helm charts are simpler to manage but less flexible than other secret management solutions*.
- Use Terraform for infrastructure as code - *Requires learning Terraform syntax and managing state files*.
- Use EKS for Kubernetes - *Managed service reduces operational overhead but adds cost*.

## Lessons learned

- FastAPI is effective for building ML model APIs, but requires careful management of dependencies and environment.
- Docker simplifies deployment but adds complexity in orchestration and scaling.
- Kubernetes (EKS) provides robust orchestration but has a steep learning curve and operational overhead.
- AWS Secrets Manager enhances security but introduces additional complexity.
- MLflow is useful for experiment tracking but can be complex to set up and manage.
- Terraform streamlines infrastructure management but requires careful state management.
- Helm charts simplify Kubernetes deployments but add another layer of abstraction.

## Next steps

- Improve model accuracy with hyperparameter tuning and feature engineering.
- Implement monitoring and alerting for model performance drift.
- LocalStack deployment for cost-effective testing of cloud services.
- KServe integration for scalable model serving.
- CI/CD pipeline setup for automated testing and deployment.
- Terraform state management and modularization.
