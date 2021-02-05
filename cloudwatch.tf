resource "aws_cloudwatch_log_group" "log_groups" {
  count = length(var.routes)
  name  = "/aws/lambda/${var.stage}-${var.app_name}-${var.routes[count.index].canonical_name}"
}

data "aws_lambda_function" "logs_to_kibana" {
  function_name = var.lambda_logs_to_kibana_name
}

resource "aws_cloudwatch_log_subscription_filter" "logs_to_kibana" {
  count           = length(var.routes)
  name            = var.logs_to_kibana_subscription_filter_name
  log_group_name  = aws_cloudwatch_log_group.log_groups[count.index].name
  filter_pattern  = ""
  destination_arn = data.aws_lambda_function.logs_to_kibana.arn
}
