# Acceso a Secrets Manager para nodos EKS (db_secret + opcional aws_credentials)
locals {
  secrets_arns = compact([
    aws_secretsmanager_secret.db_secret.arn,
    try(aws_secretsmanager_secret.aws_credentials[0].arn, null)
  ])
}

resource "aws_iam_policy" "eks_secrets_access" {
  name        = "eksSecretsManagerAccess"
  description = "Allow EKS nodes to read secrets from Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["secretsmanager:GetSecretValue","secretsmanager:DescribeSecret"],
      Resource = local.secrets_arns
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_node_secrets_access" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = aws_iam_policy.eks_secrets_access.arn
}

# Permisos S3 para nodos
resource "aws_iam_policy" "eks_s3_access" {
  name        = "eksS3AccessPolicy"
  description = "Allow EKS nodes to access S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:ListBucket"],
        Resource = [aws_s3_bucket.eks_bucket.arn]
      },
      {
        Effect = "Allow",
        Action = ["s3:GetObject","s3:PutObject","s3:DeleteObject"],
        Resource = ["${aws_s3_bucket.eks_bucket.arn}/*"]
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_node_s3_access" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = aws_iam_policy.eks_s3_access.arn
}

# Rol para SA (external-secrets) con IRSA
resource "aws_iam_role" "external_secrets_sa_role" {
  name = "external-secrets-sa-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.eks_oidc.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:default:external-secrets"
        }
      }
    }]
  })
  tags = var.tags
}

resource "aws_iam_policy" "external_secrets_sa_policy" {
  name        = "ExternalSecretsSAPolicy"
  description = "Allow access to Secrets Manager & basic S3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets",
          "secretsmanager:ListSecretVersionIds"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = ["s3:ListBucket","s3:GetObject","s3:PutObject","s3:DeleteObject"],
        Resource = "*"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "external_secrets_sa_attach" {
  role       = aws_iam_role.external_secrets_sa_role.name
  policy_arn = aws_iam_policy.external_secrets_sa_policy.arn
}
