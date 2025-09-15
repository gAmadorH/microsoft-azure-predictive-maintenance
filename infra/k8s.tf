# ServiceAccount con IRSA para External Secrets (namespace default)
resource "kubernetes_service_account" "external_secrets" {
  metadata {
    name      = "external-secrets"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_secrets_sa_role.arn
    }
    labels = { app = "external-secrets" }
  }
}
