# COMPUTED VARIABLES DO NOT CHANGE ANY VALUES FROM HERE
locals {

  ## stage == prod: app_name
  ## else: app_name-{staging}
  camel_app_name = replace(title(replace(var.app_name, "/\\W+/", " ")), " ", "")

  # API GATEWAY VARIABLES
  gateway_name = "${var.stage}-${var.app_name}-graphql"

  # LAMBDA VARIABLES
  lambda_function_names = [for route in var.routes : "${var.stage}-${var.app_name}-${route.canonical_name}"]


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
