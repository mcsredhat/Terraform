terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.78.0"
    }
  }
}
# decalre the region for aws
provider "aws" {
  region = "us-east-1"

}

# declare the input parameters of instance type
variable "instance_type" {
  type        = string
  description = "the instance type of EC2 cloud compute "
  default     = "t2.micro"

}
# declare the output parameters of instance type
resource "aws_instance" "basic_instance" {
  ami           = ami-instance
  instance_type = var.instance_type

  tags = {
    Name = "basic_instance"
  }
}
# declare the output parameters of instance type
output "public_ip" {
  value = aws_instance.basic_instance.public_ip

}

# declare the output parameters of instance type
output "private_ip" {
  value = aws_instance.basic_instance.private_ip

}

######################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.78.0"
    }
  }
}

# declare the region of the instance type
provider "aws" {
  region = "us-east-1"

}

# decalre the senode region of instance ue-west-1
provider "aws" {
  region = "eu-west-1"
  alias  = "eu"
}
# declare the local project name
locals {
  project_name = " intermediate_prjoect"
}

# decalre the input parameters of instance type
variable "instance_type" {
  type        = string
  description = "the instance type of EC2 cloud compute "
  default     = "t2.micro"

}
# create ec2 instance in the region of us-east-1
resource "aws_instance" "us_instance" {
  ami           = ami
  instance_type = var.instance_type

  tags = {
    name = "USInstnace-${local.project_name}"
  }
}

# create ec2 instance in the region of eu-west-1
resource "aws_instance" "eu_instance" {
  ami           = ami
  instance_type = var.instance_type
  provider      = aws.eu

  tags = {
    name = "EUInstnace-${local.project_name}"
  }
}

# decalare the output parameters of instance type
output "us_public_ip" {
  value = aws_instance.us_instance.public_ip
}

# decalre the output parameter of instnace type in eu-west-1
output "eu_public_ip" {
  value = aws_instance.eu_instance.public_ip

}

######################################################################
terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "Exampro"
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.78.0"
    }
  }
}

# declare the region of the instance type
provider "aws" {
  region = "us-east-1"

}

# decalre the input variable for instance type 
variable "instance_type" {
  type        = string
  description = "the type of EC2 instance "
  default     = "t2.micro"

}

# decalre the input variables for project name 
variable "project_name" {
  type        = string
  description = "the name of the project "
  default     = "terraform_project"

}

# create the VPC using terraform module 
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.78"

  name               = var.project_name
  cidr               = "10.0.0.0/16"
  azs                = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Environment = "dev"
    Project     = var.project_name
    terraform   = "true"
  }
}

# create the EC2 instance in the VPC using terraform module
resource "aws_instance" "public_instance" {
  ami           = "ami"
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnets[0]

  tags = {
    Name = "${var.project_name}-public_instance"
  }
}


# dispaly the Ouput of EC2
output "public_ip" {
  value = aws_instance.public_instance.public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}



