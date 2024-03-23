resource "null_resource" "get_nlb_hostname" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name hr-dev-eks-demo --region us-east-1 && kubectl get svc load-nginx  --namespace nginx-ingress -o jsonpath='{.status.loadBalancer.ingress[*].hostname}' > ${path.module}/lb_hostname.txt"
  }
  depends_on = [
    helm_release.ingress_nginx
  ]
}

# Define Route53 zone (modify name if needed)
data "local_file" "lb_hostname" {
  filename = "${path.module}/lb_hostname.txt"
  depends_on = [
    null_resource.get_nlb_hostname
  ]
}

# Define Route53 zone (modify name if needed)
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
  tags = {
    Environment = "dev"
  }
}

# Fetch the hosted zone ID for osikhena.com
data "aws_route53_zone" "selected" {
  name         = var.FQDN
  private_zone = false
}

# Define application instances (modify names if needed)
locals {
  instances = {
    namea = "sock-shop.${var.domain_name}"
    nameb = "grafana.${var.domain_name}"
  }
}

# Create CNAME records for application instances pointing to NLB
resource "aws_route53_record" "C-record" {
  for_each        = local.instances
  allow_overwrite = true
  zone_id         = aws_route53_zone.hosted_zone.zone_id
  name            = each.value
  ttl             = 300
  type            = "CNAME"
  records         = [data.local_file.lb_hostname.content]

  depends_on = [
    data.local_file.lb_hostname
  ]

}

# Generate private key for certificate
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

# Register account with Let's Encrypt
resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "galosikhena@gmail.com"
}

# Obtain certificate using Let's Encrypt with Route53 DNS challenge
resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.registration.account_key_pem
  common_name               = var.domain_name
  subject_alternative_names = [var.alt_domain_name]

  dns_challenge {
    provider = "route53"

    # Without this explicit config, the ACME provider (which uses lego
    # under the covers) will look for environment variables to use. 
    # These environment variable names happen to overlap with the names
    # also required by the native Terraform AWS provider, however is not 
    # guaranteed. You may want to explicitly configure them here if you
    # would like to use different credentials to those used by the main
    # Terraform provider
    # config = {
    #   AWS_ACCESS_KEY_ID     = "${var.acme_challenge_aws_access_key_id}"
    #   AWS_SECRET_ACCESS_KEY = "${var.acme_challenge_aws_secret_access_key}"
    #   AWS_REGION            = "${var.acme_challenge_aws_region}"
    # }
  }
}

# Import obtained certificate into AWS ACM
resource "aws_acm_certificate" "certificate" {
  certificate_body  = acme_certificate.certificate.certificate_pem
  private_key       = acme_certificate.certificate.private_key_pem
  certificate_chain = acme_certificate.certificate.issuer_pem
}
