data "aws_iam_policy" "aws_lambda_vpc_access" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy_document" "lambda_logging" {

  statement {
    sid = "${local.camel_app_name}LambdaLogging${title(var.stage)}"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:/aws/lambda/${var.stage}-${var.app_name}-*",
    ]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "lambda_logging" {
  description = "Policy to allow the lambda to create and publish logs in cloudwatch"
  name        = "${var.stage}-${var.app_name}-lambda-logs"
  policy      = data.aws_iam_policy_document.lambda_logging.json
}
