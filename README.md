# terraform-aws-lambda-graphql

terraform module for deploying a lambda aws (api gateway, lambda, cloudwatch) in a blink

## API Gateway

### endpoint_configuration

- `types` - (Required) A list of endpoint types. This resource currently only supports managing a single value. Valid values: `EDGE`, `REGIONAL` or `PRIVATE`. If unspecified, defaults to `EDGE`. Must be declared as `REGIONAL` in non-Commercial partitions. Refer to the [documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/create-regional-api.html) for more information on the difference between edge-optimized and regional APIs.
- `vpc_endpoint_ids` - (Optional) A list of VPC Endpoint Ids. It is only supported for PRIVATE endpoint type.
