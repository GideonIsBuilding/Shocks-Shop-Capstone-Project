resource "null_resource" "get_nlb_hostname" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name hr-dev-eks-demo --region us-east-1 && kubectl get svc load-nginx  --namespace nginx-ingress -o jsonpath='{.status.loadBalancer.ingress[*].hostname}' > ${path.module}/lb_hostname.txt"
  }
  depends_on = [
    helm_release.ingress_nginx
  ]
}

data "local_file" "lb_hostname" {
  filename = "${path.module}/lb_hostname.txt"
  depends_on = [
    null_resource.get_nlb_hostname
  ]
}

resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
  tags = {
    Environment = "dev"
  }
}

locals {
  instances = {
    namea = "sock-shop.${var.domain_name}"
    nameb = "grafana.${var.domain_name}"
  }
}

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

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}


resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "galosikhena@gmail.com"
}


resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.registration.account_key_pem
  common_name               = var.domain_name
  subject_alternative_names = [var.alt_domain_name]

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = data.aws_route53_zone.hosted_zone.zone_id
    }
  }
}


resource "aws_acm_certificate" "certificate" {
  certificate_body  = acme_certificate.certificate.certificate_pem
  private_key       = acme_certificate.certificate.private_key_pem
  certificate_chain = acme_certificate.certificate.issuer_pem
}
