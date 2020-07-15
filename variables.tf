# GLOBAL VARIABLES
variable "common_tags" {
  type        = "map"
  description = "a list of tags set on the different resources"
  default     = {}
}

variable "stage" {
  type        = "string"
  description = "The deploy environment in [prod, dev, preprod]"
}

variable "app_id" {
  type        = "string"
  description = "The id of the application"
}

variable "app_name" {
  type        = "string"
  description = "The name of the application"
}

# PROVIDER VARIABLES
variable "aws_region" {
  type        = "string"
  description = "The aws region where the infrastructure is hosted"
  default     = "eu-central-1"
}

variable "backend_s3_bucket" {
  type        = "string"
  description = "The bucket where the lambda is deployed on."
}

variable "backend_s3_key" {
  type        = "string"
  description = "The key pointing to the lambda on the backend_s3_bucket"
}

variable "security_account_arn" {
  type        = "string"
  description = "The security account arn"
}

variable "default_account_arn" {
  type        = "string"
  description = "The security account arn"
}

variable "certificate_domain" {
  type        = "string"
  description = "the domain certificate for cloudfront"
}

variable "graphql_domain" {
  type        = "string"
  description = "the graphql api gateway"
}

variable "graphql_binary_media_types" {
  type = array(string)
  description: "binary media types given to "
}

variable "alternate_graphql_domain" {
  type        = "string"
  description = "the graphql api gateway domain not managed by terraform"
}

variable "backend_lambda_filename" {
  type        = "string"
  description = "the path to the lambda.zip file"
}

variable "lambda_logs_to_kibana_name" {
  type        = "string"
  description = "name of the lambda to log in kibana"
}

variable "logs_to_kibana_subscription_filter_name" {
  type        = "string"
  description = "the kibana subscription filter name"
}

variable "vpc" {
  type        = "map"
  description = "expected subnet_ids => [] and security_group_ids => []"
}

variable "secret_managers" {
  type        = "list"
  description = "list of the secret manager the lambda can read"
  default     = []
}

variable "environment" {
  type        = "map"
  description = "key value map of environment variables to give to the lambda"
}

variable "lambda_handler" {
  type        = string
  description = "the lambda handler"
  default     = "index.handler"
}

variable "lambda_runtime" {
  type        = string
  description = "the lambda runtime"
  default     = "nodejs10.x"
}

variable "lambda_timeout" {
  type        = number
  description = "the lambda timeout"
  default     = 6
}

variable "lambda_memory_size" {
  type        = number
  description = "the lambda memory_size"
  default     = 1024
}
