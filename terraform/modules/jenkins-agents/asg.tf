# Create scaling policy
resource "aws_autoscaling_policy" "asg-policy" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  name                   = "jenkins-agents-asg-policy"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }

  depends_on = [
    aws_autoscaling_group.asg
  ]
}

# Create an AutoScaling Group
resource "aws_autoscaling_group" "asg" {
  name                      = "jenkins-agents-asg"
  max_size                  = 6
  min_size                  = 2
  desired_capacity          = 4
  health_check_grace_period = 480
  health_check_type         = "ELB"
  force_delete              = false
  termination_policies      = ["ClosestToNextInstanceHour", "Default"]
  launch_template {
    id      = aws_launch_template.jenkins-agents-lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.vpc_zone_identifier
  # Refresh instances if ASG is updated
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "Name"
    value               = "jenkins-agent"
    propagate_at_launch = true
  }

  lifecycle {
    replace_triggered_by = [aws_launch_template.jenkins-agents-lt]
  }
}