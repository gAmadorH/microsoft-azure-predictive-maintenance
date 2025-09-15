resource "aws_s3_bucket" "eks_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
  tags          = var.tags
}
