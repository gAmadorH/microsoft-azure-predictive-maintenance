# Secret con credenciales DB (nombre fijo para compatibilidad)
resource "aws_secretsmanager_secret" "db_secret" {
  name = "postgres-db-credentials"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = var.db_username
    password = local.db_password_effective
  })
}

# Secret opcional con credenciales AWS (deshabilitado por defecto)
resource "aws_secretsmanager_secret" "aws_credentials" {
  count = var.create_aws_credentials_secret ? 1 : 0
  name  = "aws-credentials"
  tags  = var.tags
}

resource "aws_secretsmanager_secret_version" "aws_credentials_version" {
  count      = var.create_aws_credentials_secret ? 1 : 0
  secret_id  = aws_secretsmanager_secret.aws_credentials[0].id
  secret_string = jsonencode({
    access_key_id     = var.aws_access_key_id_for_secret
    secret_access_key = var.aws_secret_access_key_for_secret
  })
}

# Secret (opcional) para MLflow tracking envs
resource "aws_secretsmanager_secret" "mlflow_tracking" {
  count = var.create_mlflow_tracking_secret ? 1 : 0
  name  = "mlflow-tracking"
  tags  = var.tags
}

resource "aws_secretsmanager_secret_version" "mlflow_tracking_version" {
  count     = var.create_mlflow_tracking_secret ? 1 : 0
  secret_id = aws_secretsmanager_secret.mlflow_tracking[0].id
  secret_string = jsonencode({
    MLFLOW_TRACKING_URI      = var.mlflow_tracking_uri
    MLFLOW_TRACKING_USERNAME = var.mlflow_tracking_username
    MLFLOW_TRACKING_PASSWORD = var.mlflow_tracking_password
    MLFLOW_MODEL_URI         = var.mlflow_model_uri
  })
}
