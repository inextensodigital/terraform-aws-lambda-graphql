# COMPUTED VARIABLES DO NOT CHANGE ANY VALUES FROM HERE
locals {

  ## stage == prod: app_name
  ## else: app_name-{staging}
  camel_app_name = replace(title(replace(var.app_name, "/\\W+/", " ")), " ", "")

  # API GATEWAY VARIABLES
  graphql_gateway_name = "${var.stage}-${var.app_name}-graphql"

  # LAMBDA VARIABLES
  graphql_lambda_function_name = "${var.stage}-${var.app_name}-graphql"




  api_graphql_domain = [var.alternate_graphql_domain == null ?
    var.graphql_domain :
    var.alternate_graphql_domain
  ][0]

  graphql_zone = [var.alternate_graphql_domain == null ?
    regex("([^\\.]+)\\.(.+)", var.graphql_domain)[1] :
    null
  ][0]

  graphql_domain_array = [var.alternate_graphql_domain == null ? [var.graphql_domain] : []][0]
}
