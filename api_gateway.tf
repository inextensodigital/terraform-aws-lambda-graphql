resource "aws_api_gateway_rest_api" "gateway" {
  description = "graphql api gateway"
  name        = "${local.gateway_name}"

  policy = var.gateway_type == "PRIVATE" ? var.aws_api_gateway_policy_document : null

  endpoint_configuration {
    types            = [var.gateway_type]
    vpc_endpoint_ids = var.gateway_type == "PRIVATE" ? var.gateway_vpc_ids : null
  }

  binary_media_types = var.graphql_binary_media_types
}

resource "aws_api_gateway_resource" "routes" {
  count       = length(var.routes)
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  parent_id   = aws_api_gateway_rest_api.gateway.root_resource_id
  path_part   = var.routes[count.index].route
}

resource "aws_api_gateway_method" "routes" {
  count         = length(var.routes)
  rest_api_id   = aws_api_gateway_rest_api.gateway.id
  resource_id   = aws_api_gateway_resource.routes[count.index].id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integrations" {
  count                   = length(var.routes)
  rest_api_id             = aws_api_gateway_rest_api.gateway.id
  resource_id             = aws_api_gateway_resource.routes[count.index].id
  http_method             = aws_api_gateway_method.routes[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.functions[count.index].invoke_arn
}

resource "aws_api_gateway_deployment" "gateway" {
  depends_on  = [aws_api_gateway_method.routes, aws_api_gateway_integration.lambda_integrations]
  description = "Deployment by stage to access the endpoint"

  rest_api_id = aws_api_gateway_rest_api.gateway.id

  stage_name = var.stage
}

## REGISTER DOMAINS FOR API GATEWAY
resource "aws_api_gateway_domain_name" "gateway" {
  domain_name     = local.api_graphql_domain
  certificate_arn = data.aws_acm_certificate.certificate.arn
}

resource "aws_api_gateway_base_path_mapping" "gateway" {
  api_id      = aws_api_gateway_rest_api.gateway.id
  stage_name  = aws_api_gateway_deployment.gateway.stage_name
  domain_name = aws_api_gateway_domain_name.gateway.domain_name
}
