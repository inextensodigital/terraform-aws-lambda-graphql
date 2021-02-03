# terraform-aws-lambda-graphql

terraform module for deploying a lambda aws (api gateway, lambda, cloudwatch) in a blink

## API Gateway

### endpoint_configuration

- `types` - (Required) A list of endpoint types. This resource currently only supports managing a single value. Valid values: `EDGE`, `REGIONAL` or `PRIVATE`. If unspecified, defaults to `EDGE`. Must be declared as `REGIONAL` in non-Commercial partitions. Refer to the [documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/create-regional-api.html) for more information on the difference between edge-optimized and regional APIs.
- `vpc_endpoint_ids` - (Optional) A list of VPC Endpoint Ids. It is only supported for PRIVATE endpoint type.


### Example

```terraform
module "ied-lambda-graphql" {
  source  = "app.terraform.io/ied/lambda-graphql/aws"
  version = "~>3.0.0"


  gateway_type    = "PRIVATE"
  gateway_vpc_ids = local.vpc["vpc_ids"]

  aws_api_gateway_policy_document = data.aws_iam_policy_document.api_gateway_datahub.json

  providers = {
    aws            = "aws"
    aws.n_virginia = "aws.n_virginia"
  }

  common_tags = local.common_tags
  stage       = var.stage
  app_id      = local.app_id

  app_name   = var.app_name
  aws_region = var.aws_region


  certificate_domain = local.certificate_domain

  backend_s3_bucket = var.backend_s3_bucket
  backend_s3_key    = var.backend_s3_key

  security_account_arn = local.security_account_arn
  default_account_arn  = local.default_account_arn

  graphql_domain           = local.graphql_domain
  alternate_graphql_domain = local.alternate_graphql_domain

  backend_lambda_filename = "../../back-end/lambda.zip"

  lambda_logs_to_kibana_name              = local.logs_kibana
  logs_to_kibana_subscription_filter_name = local.logs_filter

  vpc = local.vpc

  secret_managers = local.secrets
  environment = {
    STAGE                     = var.stage
    DATAHUB_PROCESS_TOPIC_ARN = aws_sns_topic.datahub_process.arn
  }

  lambda_runtime     = "nodejs12.x"

  routes = [{
    "route" = "graphql"
    "canonical_name" = "graphql"
    "description" = "Private GraphQL API Handler"
    "handler" = "functions/graphql/index.handler"
    "timeout" = null
    "memory_size" = null
    "reserved_concurrent_executions" = null
  }, 
  {
    "route"= "external-graphql"
    "canonical_name" = "external-graphql"
    "description" = "Public GraphQL API Handler"
    "handler" ="functions/external/index.handler"
    "timeout" = null
    "memory_size" = null
    "reserved_concurrent_executions" = null
  }]
}
```