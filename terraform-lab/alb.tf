resource "aws_lb" "app" {
  name               = "node-app-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}


resource "aws_lb_target_group" "app" {
  name        = "node-app-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = aws_vpc.main.id
  
  health_check {
  path                = "/api/health"
  healthy_threshold   = 2
  unhealthy_threshold = 2
  timeout             = 5
  interval            = 30
  matcher             = "200-399"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.app.arn
  }
}
