data "aws_acm_certificate" "certificate" {
  provider    = aws.n_virginia
  domain      = var.certificate_domain
  statuses    = ["ISSUED"]
  most_recent = true
}
