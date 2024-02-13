output "public_ip" {
  description = "The public IP address of the Jenkins controller"
  value       = aws_instance.jenkins-server.public_ip
}
output "instance_profile" {
description = "Instance profle to be used by jenkins-agents"
value = aws_iam_instance_profile.server_profile.name
}