output "public_ip" {
  description = "The public IP address of the Jenkins controller"
  value = aws_instance.jenkins-server.public_ip
}