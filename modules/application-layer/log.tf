resource "aws_cloudwatch_log_group" "egg_group" {
  name = "egg_group"

  tags = {
    Environment = var.env
    Application = var.project
  }
}