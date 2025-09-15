output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}

output "aws_credentials_secret_arn" {
  value       = try(aws_secretsmanager_secret.aws_credentials[0].arn, null)
  description = "Puede ser null si no se creó"
}

output "db_endpoint" {
  value = aws_db_instance.eks_postgres.endpoint
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_private_key_pem" {
  value     = tls_private_key.eks_key.private_key_pem
  sensitive = true
}

output "eks_s3_bucket_name" {
  value = aws_s3_bucket.eks_bucket.bucket
}

output "ecr_repo_url" {
  value = aws_ecr_repository.repo.repository_url
}
