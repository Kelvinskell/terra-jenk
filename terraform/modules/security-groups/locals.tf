# Define local variables
locals {
  ingress = [
    {
      description = "Allow SSH"
      port        = 22
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    },
    {
      description = "Allow SSH"
      port        = 8080
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    }
  ]
}