resource "aws_launch_template" "jenkins-agents-lt" {
  name = "jenkins-agents-launch-template"

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 30
      delete_on_termination = true
      encrypted             = true
    }
  }
  ebs_optimized = false
  image_id      = var.image_id
  instance_type = var.instance_type
  

  network_interfaces {
    security_groups             = var.security_group_id
    associate_public_ip_address = false
    delete_on_termination       = true
  }

  user_data = filebase64("./asg_userdata.sh")
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "jenkins-agents-lt",
    }
  }
}