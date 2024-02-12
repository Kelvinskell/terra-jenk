# Create a security group
resource "aws_security_group" "jenkins-sg" {
  name        = "Jenkins server traffic rules"
  description = "Traffic rules suitable for a Jenkins server"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}