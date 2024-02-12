# Provider Configurations
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.20.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}


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

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id = module.vpc.vpc_id
}

# Create jenkins Controller
module "jenkins-controller" {
  source = "./modules/jenkins-controller"

  instance_type = "t2.medium"
  ami = "ami-0c7217cdde317cfec"
}

# Create Jenkins-agents
module "jenkins-agents" {
source = "./modules/jenkins-agents"

efs_sg_subnet_a = module.vpc.private_subnets[0]
efs_sg_subnet_b = module.vpc.private_subnets[1]
efs_sg_subnet_c = module.vpc.private_subnets[2]
efs_mount_sg = module.security_groups.jenkins-sg_id
image_id = "ami-0c7217cdde317cfec"
instance_type = "t2.micro"
vpc_zone_identifier = flatten([module.vpc.public_subnets[*]])
security_group_id = module.security_groups.Allow_NFS_id
}