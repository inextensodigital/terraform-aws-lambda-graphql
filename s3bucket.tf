data "aws_s3_bucket" "deployment_bucket" {
  bucket = var.backend_s3_bucket
}
