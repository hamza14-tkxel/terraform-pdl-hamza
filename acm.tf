####### ACM certificates #########
resource "aws_acm_certificate" "non_prod_acm" {
  count       = var.env != "prod" ? 1 : 0
  domain_name = "${var.env}-cat.${var.client_domain}.paragondatalabs.com"
  subject_alternative_names = ["*.${var.env}-cat.${var.client_domain}.paragondatalabs.com", "user-api.${var.env}-cat.${var.client_domain}.paragondatalabs.com",
    "disclosures-api.${var.env}-cat.${var.client_domain}.paragondatalabs.com", "*.user-api.${var.env}-cat.${var.client_domain}.paragondatalabs.com",
  "*.disclosures-api.${var.env}-cat.${var.client_domain}.paragondatalabs.com"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "non_prod_acm_cert_validation" {
  count           = var.env != "prod" ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.non_prod_acm[0].domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.non_prod_acm[0].domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.non_prod_acm[0].domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.zone.id
  ttl             = 60
}

resource "aws_route53_record" "non_prod_acm_cert_disclosures_validation" {
  count           = var.env != "prod" ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.non_prod_acm[0].domain_validation_options)[1].resource_record_name
  records         = [tolist(aws_acm_certificate.non_prod_acm[0].domain_validation_options)[1].resource_record_value]
  type            = tolist(aws_acm_certificate.non_prod_acm[0].domain_validation_options)[1].resource_record_type
  zone_id         = data.aws_route53_zone.zone.id
  ttl             = 60
}

resource "aws_route53_record" "non_prod_acm_cert_users_validation" {
  count           = var.env != "prod" ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.non_prod_acm[0].domain_validation_options)[2].resource_record_name
  records         = [tolist(aws_acm_certificate.non_prod_acm[0].domain_validation_options)[2].resource_record_value]
  type            = tolist(aws_acm_certificate.non_prod_acm[0].domain_validation_options)[2].resource_record_type
  zone_id         = data.aws_route53_zone.zone.id
  ttl             = 60
}

# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "non_prod_acm_cert" {
  count           = var.env != "prod" ? 1 : 0
  certificate_arn = aws_acm_certificate.non_prod_acm[0].arn
  validation_record_fqdns = [aws_route53_record.non_prod_acm_cert_validation[0].fqdn,
    aws_route53_record.non_prod_acm_cert_disclosures_validation[0].fqdn,
  aws_route53_record.non_prod_acm_cert_users_validation[0].fqdn]
}







# PROD only certificates
resource "aws_acm_certificate" "prod_only_acm" {
  count       = var.env == "prod" ? 1 : 0
  domain_name = "${var.client_domain}.paragondatalabs.com"
  subject_alternative_names = ["*.${var.client_domain}.paragondatalabs.com", "user-api.${var.client_domain}.paragondatalabs.com",
    "disclosures-api.${var.client_domain}.paragondatalabs.com", "*.user-api.${var.client_domain}.paragondatalabs.com",
  "*.disclosures-api.${var.client_domain}.paragondatalabs.com"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "prod_acm_cert_validation" {
  count           = var.env == "prod" ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.prod_only_acm[0].domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.prod_only_acm[0].domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.prod_only_acm[0].domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.zone.id
  ttl             = 60
}

resource "aws_route53_record" "prod_acm_cert_disclosures_validation" {
  count           = var.env == "prod" ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.prod_only_acm[0].domain_validation_options)[1].resource_record_name
  records         = [tolist(aws_acm_certificate.prod_only_acm[0].domain_validation_options)[1].resource_record_value]
  type            = tolist(aws_acm_certificate.prod_only_acm[0].domain_validation_options)[1].resource_record_type
  zone_id         = data.aws_route53_zone.zone.id
  ttl             = 60
}

resource "aws_route53_record" "prod_acm_cert_users_validation" {
  count           = var.env == "prod" ? 1 : 0
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.prod_only_acm[0].domain_validation_options)[2].resource_record_name
  records         = [tolist(aws_acm_certificate.prod_only_acm[0].domain_validation_options)[2].resource_record_value]
  type            = tolist(aws_acm_certificate.prod_only_acm[0].domain_validation_options)[2].resource_record_type
  zone_id         = data.aws_route53_zone.zone.id
  ttl             = 60
}

# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "prod_acm_cert" {
  count           = var.env == "prod" ? 1 : 0
  certificate_arn = aws_acm_certificate.prod_only_acm[0].arn
  validation_record_fqdns = [aws_route53_record.prod_acm_cert_validation[0].fqdn,
    aws_route53_record.prod_acm_cert_disclosures_validation[0].fqdn,
  aws_route53_record.prod_acm_cert_users_validation[0].fqdn]
}
