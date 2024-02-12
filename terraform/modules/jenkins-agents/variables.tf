variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_group_id" {
  type = list
}

variable "vpc_zone_identifier" {
  type = list
}

variable "efs_mount_sg" {
    type = list
}

variable "efs_sg_subnet_a" {
  type = string
}
variable "efs_sg_subnet_b" {
  type = string
}
variable "efs_sg_subnet_c" {
  type = string
}