data "aws_secretsmanager_secret" "secret_manager" {
  count = length(var.secret_managers)
  name  = var.secret_managers[count.index]
}

data "aws_iam_policy_document" "secrets_manager_get_secret" {
  statement {
    sid = "Access${local.camel_app_name}Secrets"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    effect    = "Allow"
    resources = data.aws_secretsmanager_secret.secret_manager.*.arn
  }
}

resource "aws_iam_policy" "secrets_manager_get_secret" {
  name   = "${local.camel_app_name}SecretManager${title(var.stage)}-secretmanager-access"
  policy = data.aws_iam_policy_document.secrets_manager_get_secret.json
}

resource "aws_iam_role_policy_attachment" "secrets_manager_get_secret" {
  count      = length(var.routes)
  depends_on = [aws_iam_policy.secrets_manager_get_secret]

  role       = aws_iam_role.lambda_roles[count.index].name
  policy_arn = aws_iam_policy.secrets_manager_get_secret.arn
}
