resource "aws_ecs_cluster" "main" {
  name = "node-app-cluster"
}


resource "aws_ecs_task_definition" "app" {
  family                   = "node-app-task"

  network_mode             = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  execution_role_arn = data.aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name  = "app"

      image = "${aws_ecr_repository.app.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}


resource "aws_ecs_service" "app" {
  name            = "node-app-service"

  cluster         = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.app.arn

  launch_type = "FARGATE"

  desired_count = 1

  network_configuration {
    subnets = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn

    container_name = "app"

    container_port = 3000
  }

  depends_on = [
    aws_lb_listener.http
  ]
}
