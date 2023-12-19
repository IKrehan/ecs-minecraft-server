resource "aws_security_group" "minecraft_server" {
  name   = "minecraft_server"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "minecraft_server"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_ecs_task_definition" "minecraft_server" {
  cpu                      = "2048"
  memory                   = "4096"
  family                   = "minecraft-server"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
  container_definitions = jsonencode([
    {
      name       = "minecraft-server"
      image      = aws_ecr_repository.minecraft.repository_url
      essential  = true
      tty        = true
      stdin_open = true
      restart    = "unless-stopped"
      portMappings = [
        {
          containerPort = 25565
          hostPort      = 25565
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "EULA"
          value = "TRUE"
        },
        {
          "name" : "VERSION",
          "value" : "1.20.1"
        }
      ]
      mountPoints = [
        {
          containerPath = "/data"
          sourceVolume  = "minecraft-data"
        }
      ]
    }
  ])
  volume {
    name = "minecraft-data"
  }
}

resource "aws_ecs_cluster" "minecraft_server" {
  name = "minecraft_server"
}

resource "aws_ecs_service" "minecraft_server" {
  name            = "minecraft_server"
  cluster         = aws_ecs_cluster.minecraft_server.id
  task_definition = aws_ecs_task_definition.minecraft_server.arn
  desired_count   = 1
  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.minecraft_server.id]
    assign_public_ip = true
  }
  launch_type = "FARGATE"
}
