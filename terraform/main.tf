# Create A VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Environment = "prod"
    Purpose = "Jenkins infrastructure set up"
  }
}


# Create jenkins Controller
module "jenkins-controller" {
  source = "./modules/"

  instance_type = "t2.medium"
  jc-ami = "ami-0c7217cdde317cfec"
  vpc_id = module.vpc.vpc_id
}