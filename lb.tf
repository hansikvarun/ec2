resource "aws_lb" "application_elb" {
  name               = var.application_elb_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.application_elb_security_groups
  subnets            = var.application_elb_subnets

  enable_deletion_protection = false
  #  access_logs {
  #    bucket  = aws_s3_bucket.lb_logs.bucket
  #    prefix  = "test-lb"
  #    enabled = true
  #  }
}

resource "aws_lb_target_group" "target_group" {
  name     = var.target_group_name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "attach_instance" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.vm.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.application_elb.arn
  port              = var.port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance.arn
  }
}