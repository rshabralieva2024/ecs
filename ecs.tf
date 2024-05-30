resource "aws_ecs_cluster" "foo" {
  name = "rahat"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "rshabralieva2024/ubuntu"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    },
  
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-2a, us-east-2b]"
  }
}

resource "aws_s3_bucket" "rahat-ecs-bucket" {
  bucket = "rahat-ecs-bucket"

  tags = {
    Name        = "rahat-ecs"
    Environment = "Dev"
  }
}