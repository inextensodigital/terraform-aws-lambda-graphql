resource "aws_api_gateway_rest_api" "graphql" {
  description = "graphql api gateway"
  name        = "${local.graphql_gateway_name}"
  
  endpoint_configuration {
    types = [var.gateway_type ]
    vpc_endpoint_ids = var.gateway_type == "PRIVATE" ? var.gateway_vpc_ids : null
  }

  binary_media_types = var.graphql_binary_media_types
}

resource "aws_api_gateway_resource" "graphql" {
  rest_api_id = aws_api_gateway_rest_api.graphql.id
  parent_id   = aws_api_gateway_rest_api.graphql.root_resource_id
  path_part   = "graphql"
}

resource "aws_api_gateway_method" "graphql" {
  rest_api_id   = aws_api_gateway_rest_api.graphql.id
  resource_id   = aws_api_gateway_resource.graphql.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "graphql_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.graphql.id
  resource_id             = aws_api_gateway_resource.graphql.id
  http_method             = aws_api_gateway_method.graphql.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.graphql.invoke_arn
}

resource "aws_api_gateway_deployment" "graphql" {
  depends_on  = [aws_api_gateway_method.graphql, aws_api_gateway_integration.graphql_lambda_integration]
  description = "Deployment by stage to access the endpoint"

  rest_api_id = aws_api_gateway_rest_api.graphql.id

  stage_name = var.stage
}

## REGISTER DOMAINS FOR API GATEWAY
resource "aws_api_gateway_domain_name" "graphql" {
  domain_name     = local.api_graphql_domain
  certificate_arn = data.aws_acm_certificate.certificate.arn
}

resource "aws_api_gateway_base_path_mapping" "graphql" {
  api_id      = aws_api_gateway_rest_api.graphql.id
  stage_name  = aws_api_gateway_deployment.graphql.stage_name
  domain_name = aws_api_gateway_domain_name.graphql.domain_name
}
