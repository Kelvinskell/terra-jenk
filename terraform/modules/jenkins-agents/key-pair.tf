# Use AWS KMS to decrypt database credentials
data "aws_kms_secrets" "jenkins_pub" {
  secret {
    name    = "jenkins_public_key"
    payload = filebase64("./id_rsa.pub.encrypted")
  }
}

# Use locals to grab the decrypted KMS key
locals {
    jenkins_pub = yamldecode(data.aws_kms_secrets.jenkins_pub.plaintext["jenkins_public_key"])
}

# Create an EC2 key-pair
resource "aws_key_pair" "security_key" {
  key_name   = "jenkins-agents-key-pair"
  public_key = local.jenkins_pub
}