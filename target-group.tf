resource "aws_lb_target_group" "paragon-ui-target" {
  depends_on       = [aws_instance.ec2-instance, aws_vpc.vpc]
  protocol_version = "HTTP1"
  name             = "${var.env}-paragon-ui-target"
  vpc_id           = aws_vpc.vpc.id
  port             = 4200
  protocol         = "HTTP"
  tags = {
    env = var.env
    app = "paragon-ui-target-group"
  }
  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "paragon-ui-target-attached-alb" {
  target_group_arn = aws_lb_target_group.paragon-ui-target.arn
  target_id        = aws_instance.ec2-instance.id
  port             = 4200
}

resource "aws_lb_target_group" "paragon-disclosures-api-target" {
  depends_on       = [aws_instance.ec2-instance]
  protocol_version = "HTTP1"
  name             = "${var.env}-paragon-disclosures-target"
  vpc_id           = aws_vpc.vpc.id
  port             = 9000
  protocol         = "HTTP"
  tags = {
    env = var.env
    app = "disclosures-ui-target-group"
  }

  health_check {
    path = "/pdl/public/util/UP_AND_RUNNING"
  }
}

resource "aws_lb_target_group_attachment" "paragon-disclosures-api-target-attached-alb" {
  target_group_arn = aws_lb_target_group.paragon-disclosures-api-target.arn
  target_id        = aws_instance.ec2-instance.id
  port             = 9000
}

resource "aws_lb_target_group" "paragon-user-api-target" {
  depends_on       = [aws_instance.ec2-instance]
  protocol_version = "HTTP1"
  name             = "${var.env}-paragon-user-api-target"
  vpc_id           = aws_vpc.vpc.id
  port             = 8080
  protocol         = "HTTP"
  tags = {
    env = var.env
    app = "user-ui-target-group"
  }
  health_check {
    path = "/api/public/health"
  }
}

resource "aws_lb_target_group_attachment" "paragon-user-api-target-attached-alb" {
  target_group_arn = aws_lb_target_group.paragon-user-api-target.arn
  target_id        = aws_instance.ec2-instance.id
  port             = 8080
}
