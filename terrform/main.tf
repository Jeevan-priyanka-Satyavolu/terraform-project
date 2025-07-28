terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default subnet (first one found)
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnet" "default" {
  id = tolist(data.aws_subnet_ids.default.ids)[0]
}

# Get default security group
data "aws_security_group" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }

  vpc_id = data.aws_vpc.default.id
}

# EC2 Instance
resource "aws_instance" "my_ec2" {
  ami                         = "ami-0f58b397bc5c1f2e8" # Amazon Linux 2 AMI (ap-south-1), update for your region
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [data.aws_security_group.default.id]
  key_name                    = "mykeyname" # Replace with your actual key pair name
  associate_public_ip_address = true
  

  tags = {
    Name = "Terraform-EC2"
  }
}
