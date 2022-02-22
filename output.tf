output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.ec2-instance.public_ip
}

resource "local_file" "private_key" {
  content         = tls_private_key.tls_key.private_key_pem
  filename        = "${var.client_code}-${var.env}-testing.pem"
  file_permission = "0400"
}


output "acm_certificate_arn_non_prod" {
  description = "arn of app acm certificate"
  value       = var.env != "prod" ? aws_acm_certificate.non_prod_acm[0].arn : null
}

output "acm_certificate_arn_prod_only" {
  description = "arn of acm certificate"
  value       = var.env == "prod" ? aws_acm_certificate.prod_only_acm[0].arn : null
}

