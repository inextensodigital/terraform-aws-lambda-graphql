resource "aws_cloudwatch_log_group" "graphql" {
  name = "/aws/lambda/${var.stage}-${var.app_name}-graphql"
}

data "aws_lambda_function" "logs_to_kibana" {
  function_name = var.lambda_logs_to_kibana_name
}

resource "aws_cloudwatch_log_subscription_filter" "graphql_logs_to_kibana" {
  name            = var.logs_to_kibana_subscription_filter_name
  log_group_name  = aws_cloudwatch_log_group.graphql.name
  filter_pattern  = ""
  destination_arn = data.aws_lambda_function.logs_to_kibana.arn
}
