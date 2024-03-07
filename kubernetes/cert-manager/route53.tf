







/* data "kubernetes_ingress" "nginx-ingress" {
  metadata {
    name = "nginx-ingress"
    namespace = "nginx-ingress"
  }
}



# now you can access the zone_id as data.aws_lb.foobar.zone_id

resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
  tags = {
    Environment = "dev"
  }
}

locals {
  instances = {
    namea = "sock-shop.${var.domain_name}"
    nameb = "voting-app.${var.domain_name}"
    named = "grafana.${var.domain_name}"
  }
}
resource "aws_route53_record" "A-record" {
  for_each        = local.instances
  allow_overwrite = true
  zone_id         = aws_route53_zone.hosted_zone.zone_id
  name            = each.value
  type            = "A"

  alias {
    name = data.kubernetes_ingress.nginx-ingress.status.0.load_balancer.0.ingress.0.hostname
    zone_id = data.aws_lb.nginx-ingress.zone_id
   # name                   = aws_lb.Altschool-load-balancer.dns_name
   # zone_id                = aws_lb.Altschool-load-balancer.zone_id
    evaluate_target_health = true
  }

}


# Path: route53.tf
# request public certificates from the amazon certificate manager.
resource "aws_acm_certificate" "acm_certificate" {
  depends_on = [
    aws_route53_record.A-record
  ]
  domain_name               = var.domain_name
  subject_alternative_names = [var.alt_domain_name]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# get details about a route 53 hosted zone
data "aws_route53_zone" "route53_zone" {
  depends_on = [
    aws_acm_certificate.acm_certificate,
  ]
  name         = var.domain_name
  private_zone = false
}

# create a record set in route 53 for domain validatation
resource "aws_route53_record" "route53_record" {
  depends_on = [
    data.aws_route53_zone.route53_zone,
  ]
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_zone.zone_id
}

# validate acm certificates
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_record : record.fqdn]
}

 */

/* 

locals {
  ingress_svc_name      = "ingress-nginx-controller"
  ingress_svc_namespace = "ingress-nginx"
  ingress_load_balancer_tags = {
    "service.k8s.aws/resource" = "LoadBalancer"
    "service.k8s.aws/stack"    = "${local.ingress_svc_namespace}/${local.ingress_svc_name}"
    "elbv2.k8s.aws/cluster"    = var.cluster_id
  }
}

data "aws_lb" "ingress_load_balancer" {
  tags = local.ingress_load_balancer_tags
}

resource "aws_route53_record" "ingress_alias" {
  zone_id = var.hosted_zone_id
  name    = var.ingress_subdomain
  type    = "A"

  alias {
    name                   = "dualstack.${data.aws_lb.ingress_load_balancer.dns_name}"
    zone_id                = data.aws_lb.ingress_load_balancer.zone_id
    evaluate_target_health = true
  }
} */

/* # create a record set in route 53
# terraform aws route 53 record set

locals {
  lb_name_parts = split("-", split(".", kubernetes_ingress.nginx-ingress.load_balancer_ingress.0.hostname).0)
}

data "aws_lb" "nginx-ingress" {
  name = join("-", slice(local.lb_name_parts, 0, length(local.lb_name_parts) - 1))
} */