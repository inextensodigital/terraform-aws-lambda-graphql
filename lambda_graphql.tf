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

resource "aws_iam_role" "graphql_lambda_role" {
  name               = "${local.camel_app_name}Graphql${title(var.stage)}"
  assume_role_policy = data.aws_iam_policy_document.graphql_group_policy.json
}

# Allow access to VPC
resource "aws_iam_role_policy_attachment" "graphql_lambda_execution" {
  role       = aws_iam_role.graphql_lambda_role.name
  policy_arn = data.aws_iam_policy.aws_lambda_vpc_access.arn
}

resource "aws_iam_role_policy_attachment" "graphql_logging" {
  depends_on = ["aws_iam_policy.lambda_logging"]
  role       = aws_iam_role.graphql_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_lambda_permission" "graphql" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.graphql.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${replace(aws_api_gateway_deployment.graphql.execution_arn, "/${var.stage}", "/*/*")}"
}

resource "aws_lambda_function" "graphql" {
  description = "Processes graphql queries"
  depends_on = [
    aws_iam_role.graphql_lambda_role,
    aws_cloudwatch_log_group.graphql,
  ]

  function_name    = "${local.graphql_lambda_function_name}"
  source_code_hash = filebase64sha256(var.backend_lambda_filename)

  s3_bucket = data.aws_s3_bucket.deployment_bucket.id
  s3_key    = var.backend_s3_key

  handler = "index.handler"
  runtime = "nodejs10.x"

  publish = true

  timeout = 6

  memory_size = 1024

  tags = "${var.common_tags}"

  vpc_config {
    subnet_ids         = var.vpc["subnet_ids"]
    security_group_ids = var.vpc["security_group_ids"]
  }

  environment {
    variables = {
      stage = var.stage
    }
  }

  role = aws_iam_role.graphql_lambda_role.arn
}
