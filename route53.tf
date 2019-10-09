data "aws_route53_zone" "graphql" {
  count = length(local.graphql_domain_array)
  name  = "${local.graphql_zone}."
}

resource "aws_route53_record" "graphql" {
  count = length(local.graphql_domain_array)

  name    = aws_api_gateway_domain_name.graphql.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.graphql[count.index].zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_api_gateway_domain_name.graphql.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.graphql.cloudfront_zone_id
  }
}
