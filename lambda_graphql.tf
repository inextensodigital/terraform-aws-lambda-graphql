# Policies definition
data "aws_iam_policy_document" "graphql_group_policy" {
  statement {
    sid = "LambdaAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    principals {
      type = "AWS"
      identifiers = [
        var.default_account_arn,
        var.security_account_arn,
      ]
    }
  }
}

resource "aws_iam_role" "lambda_roles" {
  count              = length(var.routes)
  name               = "${local.camel_app_name}${title(var.routes[count.index].canonical_name)}LambdaRole${title(var.stage)}"
  assume_role_policy = data.aws_iam_policy_document.graphql_group_policy.json
}

# Allow access to VPC
resource "aws_iam_role_policy_attachment" "lambda_executions" {
  count      = length(var.routes)
  role       = aws_iam_role.lambda_roles[count.index].name
  policy_arn = data.aws_iam_policy.aws_lambda_vpc_access.arn
}

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  depends_on = ["aws_iam_policy.lambda_loggings"]
  count      = length(var.routes)
  role       = aws_iam_role.lambda_roles[count.index].name
  policy_arn = aws_iam_policy.lambda_loggings[count.index].arn
}

resource "aws_lambda_permission" "lambda_invoke_permission" {
  count         = length(var.routes)
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.functions[count.index].arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${replace(aws_api_gateway_deployment.gateway.execution_arn, "/${var.stage}", "/*/*")}"
}

resource "aws_lambda_function" "functions" {
  count       = length(var.routes)
  description = var.routes[count.index].description
  depends_on = [
    aws_iam_role.lambda_roles,
    aws_cloudwatch_log_group.log_groups,
  ]

  function_name    = "${local.lambda_function_names[count.index]}"
  source_code_hash = filebase64sha256(var.backend_lambda_filename)

  s3_bucket = data.aws_s3_bucket.deployment_bucket.id
  s3_key    = var.backend_s3_key

  handler = var.routes[count.index].handler
  runtime = var.lambda_runtime

  publish = var.lambda_publish

  timeout     = var.routes[count.index].timeout == null ? var.routes[count.index].timeout : 30
  memory_size = var.routes[count.index].memory_size == null ? var.routes[count.index].memory_size : 1024

  reserved_concurrent_executions = var.lambda_reserved_concurrent_executions

  tags = "${var.common_tags}"

  vpc_config {
    subnet_ids         = var.vpc["subnet_ids"]
    security_group_ids = var.vpc["security_group_ids"]
  }

  environment {
    variables = var.environment
  }

  role = aws_iam_role.lambda_roles[count.index].arn
}
