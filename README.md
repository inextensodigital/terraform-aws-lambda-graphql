# terraform-aws-lambda-graphql

terraform module for deploying a lambda aws (api gateway, lambda, cloudwatch) in a blink

## example

```hcl

module "ied-lambda-graphql" {
  source  = "app.terraform.io/ied/lambda-graphql/aws"
  version = "~>1.2.1"

  providers = {
    aws            = "aws"
    aws.n_virginia = "aws.n_virginia"
  }

  common_tags = var.common_tags
  stage       = var.stage
  app_id      = var.app_id

  app_name   = var.app_name
  aws_region = var.aws_region

  certificate_domain = var.certificate_domain

  backend_s3_bucket = var.backend_s3_bucket
  backend_s3_key    = var.backend_s3_key

  security_account_arn = var.security_account_arn
  default_account_arn  = var.default_account_arn

  graphql_domain           = var.graphql_domain
  alternate_graphql_domain = var.alternate_graphql_domain

  backend_lambda_filename = var.backend_lambda_filename

  lambda_logs_to_kibana_name              = var.lambda_logs_to_kibana_name
  logs_to_kibana_subscription_filter_name = var.logs_to_kibana_subscription_filter_name

  vpc = var.vpc

  secret_managers = var.graphql_secret_managers
  environment     = var.graphql_environment

  lambda_runtime     = var.graphql_runtime
  lambda_handler     = var.graphql_handler
  lambda_timeout     = var.graphql_timeout
  lambda_memory_size = var.graphql_memory_size
}


```
