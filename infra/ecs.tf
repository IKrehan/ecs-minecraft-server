resource "aws_security_group" "minecraft" {
  name   = "minecraft"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "minecraft"
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

resource "aws_ecs_task_definition" "mc_server" {
  cpu                      = "2048"
  memory                   = "4096"
  family                   = "minecraft"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
  container_definitions = jsonencode([
    {
      name       = "mc-server"
      image      = "itzg/minecraft-server:java17-alpine" 
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
          "value" : "LATEST"
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

resource "aws_ecs_cluster" "minecraft" {
  name = "minecraft"
}

resource "aws_ecs_service" "mc_server" {
  name            = "mc_server"
  cluster         = aws_ecs_cluster.minecraft.id
  task_definition = aws_ecs_task_definition.mc_server.arn
  desired_count   = 1
  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.minecraft.id]
    assign_public_ip = true
  }
  launch_type = "FARGATE"
}
