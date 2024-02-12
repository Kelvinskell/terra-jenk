variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "jenkins_server_sgid" {
  type = list(any)
}

variable "jenkins_server_subnetid" {
  type = string
}