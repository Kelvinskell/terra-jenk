# Use data source to invoke user data
data "template_file" "user_data1" {
  template = file("./jenkins-install.sh")
}

resource "aws_instance" "jenkins-server" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
    user_data = data.template_file.user_data1.rendered

    tags = {
        Name = "Jenkins-Controller"
        Environment = "prod"
    }
}