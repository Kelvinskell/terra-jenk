# Use data source to invoke user data
data "template_file" "user_data1" {
  template = file("./userdata.sh")
}

resource "aws_instance" "jenkins-server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.jenkins_server_subnetid
  vpc_security_group_ids = var.jenkins_server_sgid
  associate_public_ip_address = true
  user_data              = data.template_file.user_data1.rendered

  tags = {
    Name        = "Jenkins-Controller"
    Environment = "prod"
  }
}