provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Se inicializa después de crear el cluster EKS
data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.eks.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}
