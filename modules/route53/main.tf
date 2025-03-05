# resource "aws_route53_record" "latency-use1" {
#   zone_id         = "mxdrproject.com"
#   name            = "mx-disaster-region-2"
#   type            = "A"
#   set_identifier  = "service-us-east-1"

#   alias {
#     # zone_id                = "${aws_lb.main_us_east_1.zone_id}"
#     # name                   = "${aws_lb.main_us_east_1.dns_name}"
#     zone_id = var.zone_id
#     name = var.zone_name
#     evaluate_target_health = true
#   }

#   latency_routing_policy {
#     region = "us-east-1"
#   }
# }

# resource "aws_route53_record" "latency-euc1" {
#   zone_id         = "${data.aws_route53_zone.my_zone.zone_id}"
#   name            = "my-application"
#   type            = "A"
#   set_identifier  = "service-e-west-1"

#   alias {
#     zone_id                = "${aws_lb.main_eu_central_1.zone_id}"
#     name                   = "${aws_lb.main_eu_central_1.dns_name}"
#     evaluate_target_health = true
#   }

#   latency_routing_policy {
#     region = "eu-west-1"
#   }
# }


########################
### NEW TYPE R53
resource "aws_route53_zone" "main" {
  name = "${var.domain_name}"
  comment = "${var.comment}"
}

resource "aws_route53_record" "primary" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${var.subdomain}"
  type    = "A"
  ttl     = "${var.ttl}"

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "${var.identifier1}"
  records        = ["${var.primaryip1}"]
  health_check_id = "${aws_route53_health_check.primary.id}"
}

resource "aws_route53_record" "secondary" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${var.subdomain}"
  type    = "A"
  ttl     = "${var.ttl}"

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "${var.identifier2}"
  records        = ["${var.secondaryip1}"]
  health_check_id = "${aws_route53_health_check.secondary.id}"
}

resource "aws_route53_health_check" "primary" {
  ip_address        = "${var.primaryip2}"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "2"
  request_interval  = "30"

  tags = {
    Name = "r53-primary-health-check"
  }
}

resource "aws_route53_health_check" "secondary" {
  ip_address        = "${var.secondaryip1}"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "2"
  request_interval  = "30"

  tags = {
    Name = "r53-secondary-health-check"
  }
}

