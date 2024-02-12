output "jenkins-sg_id" {
  description = "The id of the jenkins security group"
  value       = aws_security_group.jenkins-sg.id
}

output "Allow_NFS_id" {
  description = "The id of the NFS security group"
  value       = aws_security_group.Allow_NFS.id
}