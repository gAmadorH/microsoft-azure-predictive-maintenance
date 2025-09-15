variable "aws_region" {
  description = "Región AWS"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Perfil AWS CLI"
  type        = string
  default     = "test-user0"
}

variable "tags" {
  description = "Tags comunes"
  type        = map(string)
  default     = { Project = "eks-mlflow", Owner = "you" }
}

# Red
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}
variable "az_count" {
  type        = number
  default     = 2
}

# EKS
variable "cluster_name" {
  type        = string
  default     = "eks-cluster"
}
variable "cluster_version" {
  type        = string
  default     = "1.30"
}
variable "node_instance_types" {
  type        = list(string)
  default     = ["t3.large"]
}
variable "node_desired_size" {
  type    = number
  default = 2
}
variable "node_min_size" {
  type    = number
  default = 1
}
variable "node_max_size" {
  type    = number
  default = 3
}

# RDS Postgres
variable "db_identifier" {
  type    = string
  default = "eks-postgres-db"
}
variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "db_allocated_storage" {
  type    = number
  default = 20
}
variable "db_name" {
  type    = string
  default = "mlflow"
}
variable "db_username" {
  type    = string
  default = "eksdbuser"
}
variable "db_password" {
  description = "Password explícita (opcional). Si se deja vacía, se genera."
  type        = string
  default     = ""
  sensitive   = true
}
variable "db_publicly_accessible" {
  type    = bool
  default = true
}
variable "db_skip_final_snapshot" {
  type    = bool
  default = true
}

# S3
variable "s3_bucket_name" {
  type    = string
  default = "eks-cluster-bucket-a075d761"
}

# ECR
variable "ecr_repo_name" {
  type    = string
  default = "mlflow-fastapi"
}

# Secrets Manager - MLflow (opcional)
variable "create_mlflow_tracking_secret" {
  type    = bool
  default = true
}
variable "mlflow_tracking_uri" {
  type    = string
  default = "http://example-elb.us-east-1.elb.amazonaws.com"
}
variable "mlflow_tracking_username" {
  type    = string
  default = "admin"
}
variable "mlflow_tracking_password" {
  type      = string
  default   = "abcdef123456!"
  sensitive = true
}
variable "mlflow_model_uri" {
  type    = string
  default = "models:/RULPrediction1000/1"
}

# Secrets Manager - AWS credentials (opcional)
variable "create_aws_credentials_secret" {
  type    = bool
  default = false
}
variable "aws_access_key_id_for_secret" {
  type      = string
  default   = ""
  sensitive = true
}
variable "aws_secret_access_key_for_secret" {
  type      = string
  default   = ""
  sensitive = true
}
