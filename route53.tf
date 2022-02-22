
data "aws_route53_zone" "zone" {
  name         = "${var.client_domain}.paragondatalabs.com"
  private_zone = false
}
