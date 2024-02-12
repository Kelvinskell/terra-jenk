# Use data source to invoke user data
data "template_file" "user_data1" {
  template = file("./jenkins-install.sh")
}

resource "aws_instance" "jenkins-server" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = var.jenkins_server_sgid
    user_data = data.template_file.user_data1.rendered

    tags = {
        Name = "Jenkins-Controller"
        Environment = "prod"
    }
}