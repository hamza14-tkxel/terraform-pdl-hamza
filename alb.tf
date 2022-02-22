############################################################## LOAD BALANCER paragon-ui ###########################################################################

resource "aws_lb" "paragon-ui" {
  depends_on         = [aws_vpc.vpc]
  name               = "${var.env}-paragon-ui"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public-1.id, aws_subnet.public-2.id]
  security_groups    = [aws_security_group.vpc_sg.id]

}

#for non prod
resource "aws_lb_listener" "paragon-ui-redirect-non-prod" {
  count             = var.env != "prod" ? 1 : 0
  load_balancer_arn = aws_lb.paragon-ui.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#for prod
resource "aws_lb_listener" "paragon-ui-redirect-prod" {
  count             = var.env == "prod" ? 1 : 0
  load_balancer_arn = aws_lb.paragon-ui.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}





#For non prod
resource "aws_lb_listener" "paragon-ui-forward" {
  count             = var.env != "prod" ? 1 : 0
  depends_on        = [aws_lb_target_group.paragon-ui-target, aws_acm_certificate.non_prod_acm]
  load_balancer_arn = aws_lb.paragon-ui.arn
  protocol          = "HTTPS"
  port              = "443"
  certificate_arn   = aws_acm_certificate.non_prod_acm[0].arn
  default_action {
    type = "forward"
    forward {

      target_group {
        arn    = aws_lb_target_group.paragon-ui-target.arn
        weight = 1
      }
      stickiness {
        duration = 1
        enabled  = false
      }

    }
  }

}

resource "aws_lb_listener_rule" "host_based_weighted_routing1" {
  count        = var.env != "prod" ? 1 : 0
  listener_arn = aws_lb_listener.paragon-ui-forward[0].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.paragon-disclosures-api-target.arn
  }


  condition {
    host_header {
      values = ["disclosures-api.*-cat.*.paragondatalabs.com", "www.disclosures-api.*-cat.*.paragondatalabs.com"]
    }
  }
}
resource "aws_lb_listener_rule" "host_based_weighted_routing2" {
  count        = var.env != "prod" ? 1 : 0
  listener_arn = aws_lb_listener.paragon-ui-forward[0].arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.paragon-user-api-target.arn

  }

  condition {
    host_header {
      values = ["user-api.*-cat.*.paragondatalabs.com", "www.user-api.*-cat.*.paragondatalabs.com"]
    }
  }
}




#For prod
resource "aws_lb_listener" "paragon-ui-forward-prod" {
  count             = var.env == "prod" ? 1 : 0
  depends_on        = [aws_lb_target_group.paragon-ui-target, aws_acm_certificate.prod_only_acm]
  load_balancer_arn = aws_lb.paragon-ui.arn
  protocol          = "HTTPS"
  port              = "443"
  certificate_arn   = aws_acm_certificate.prod_only_acm[0].arn
  default_action {
    type = "forward"
    forward {

      target_group {
        arn    = aws_lb_target_group.paragon-ui-target.arn
        weight = 1
      }
      stickiness {
        duration = 1
        enabled  = false
      }

    }
  }

}

resource "aws_lb_listener_rule" "host_based_weighted_routing1-prod" {
  count        = var.env == "prod" ? 1 : 0
  listener_arn = aws_lb_listener.paragon-ui-forward-prod[0].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.paragon-disclosures-api-target.arn
  }


  condition {
    host_header {
      values = ["disclosures-api.*-cat.*.paragondatalabs.com", "www.disclosures-api.*-cat.*.paragondatalabs.com"]
    }
  }
}
resource "aws_lb_listener_rule" "host_based_weighted_routing2-prod" {
  count        = var.env == "prod" ? 1 : 0
  listener_arn = aws_lb_listener.paragon-ui-forward-prod[0].arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.paragon-user-api-target.arn

  }

  condition {
    host_header {
      values = ["user-api.*-cat.*.paragondatalabs.com", "www.user-api.*-cat.*.paragondatalabs.com"]
    }
  }
}
