# Create Elastic Filesystem for jenkins agents
resource "aws_efs_file_system" "efs" {
  creation_token = "jenkins-agents"
  encrypted      = true

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name        = "Jenkins-agents-efs",
    Environment = "prod"
  }
}

# Create EFS mount target for az1
resource "aws_efs_mount_target" "mount1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.efs_sg_subnet_a
  security_groups = var.efs_mount_sg
}

# Create EFS mount target for az2
resource "aws_efs_mount_target" "mount2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.efs_sg_subnet_b
  security_groups = var.efs_mount_sg
}

# Create EFS mount target 

resource "aws_efs_mount_target" "mount3" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.efs_sg_subnet_c
  security_groups = var.efs_mount_sg
}

# Create EFS Access Point
resource "aws_efs_access_point" "point" {
  file_system_id = aws_efs_file_system.efs.id
}