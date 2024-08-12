# resource "aws_autoscaling_group" "ecs-autoscaling-group" {
#   name                        = "ecs-autoscaling-group"
#   max_size                    = "${var.max_instance_size}"
#   min_size                    = "${var.min_instance_size}"
#   desired_capacity            = "${var.desired_capacity}"
#   vpc_zone_identifier         = ["subnet-09d29193405f30494", "subnet-0198172c6260d4892"] // lab-architect-public-a, lab-architect-public-b
#   launch_configuration        = "${aws_launch_configuration.ecs-launch-configuration.name}"
#   health_check_type           = "ELB"
# }

###################
# Ruby Autoscaling
###################
resource "aws_autoscaling_group" "iac_standard_ruby_autoscale_group" {
  name                 = "${var.project}-ruby-autoscale-group-${var.env}"
  launch_configuration = aws_launch_configuration.ecs_launch_configuration.name
  vpc_zone_identifier  = var.iac_standard_subnet_private_id

  target_group_arns         = [aws_alb_target_group.alb_target_grp_blue.arn]
  health_check_grace_period = 300
  health_check_type         = "EC2"

  desired_capacity     = var.asg_desired_capacity
  min_size             = var.asg_min_instance_size
  max_size             = var.asg_max_instance_size
  termination_policies = ["NewestInstance"]
  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances",
  "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  tags = [
    {
      key                 = "Name"
      value               = "${var.project}-autoscale-group-${var.env}"
      propagate_at_launch = true
    },
    {
      key                 = "Stage"
      value               = var.env
      propagate_at_launch = true
    }
  ]
}