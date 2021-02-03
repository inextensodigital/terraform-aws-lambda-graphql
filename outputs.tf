output "lambda_versions" {
  value       = aws_lambda_function.functions.*.version
  description = "the lambda versions"
}

output "lambda_role_names" {
  value       = aws_iam_role.lambda_roles.*.name
  description = "the lambda roles"
}

output "lambda_arns" {
  value       = aws_lambda_function.functions.*.arn
  description = "the lambda arn"
}

output "lambda_function_names" {
  value       = aws_lambda_function.functions.*.function_name
  description = "the lambda function name"
}
