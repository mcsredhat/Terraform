#Explanation of the Combined File:
#Terraform Block:
#Configures Terraform Cloud for state management and specifies the required AWS provider.
#Providers:
#Defines two AWS providers:
#Default provider for the us-east-1 region.
#Aliased provider for the eu-west-1 region.
#Variables:
#Declares a variable instance_type to define the type of EC2 instance dynamically.
#Accepts user input or pulls default values from a separate .tfvars file if used.
#Local Variables:
#Includes a local variable project_name for dynamic resource naming.
#Resource Configuration:
#Creates an EC2 instance using the specified AMI and instance type.
#Tags the instance with a dynamic name.
#Output:
#Outputs the public IP of the created EC2 instance after the Terraform apply command.


# Define the Terraform configuration block
terraform {
  # Use Terraform Cloud for state management
  cloud {
    hostname     = "app.terraform.io"     # Terraform Cloud hostname
    organization = "ExamPro"              # Terraform Cloud organization name

    workspaces {
      name = "getting-started"            # Workspace name for this project
    }
  }

  # Specify required providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"           # AWS provider source
      version = "5.78.0"                  # Compatible with AWS provider version 5.x
    }
  }
}

# Define AWS provider configurations
provider "aws" {
  region = "us-east-1"                    # Default AWS region for resources
}

provider "aws" {
  region = "eu-west-1"                    # AWS region for resources in Europe
  alias  = "eu"                           # Alias to differentiate this provider
}

# Declare input variables
variable "instance_type" {
  type        = string                    # The input must be a string
  description = "The type of EC2 instance to create, e.g., t2.micro, t3.medium"
}

# Define local variables
locals {
  project_name = "Andrew"                 # A reusable variable for project name
}

# Define an AWS EC2 instance resource
resource "aws_instance" "my_server" {
  ami           = "ami-087c17d1fe0178315" # Amazon Machine Image (AMI) ID
  instance_type = var.instance_type       # Use the instance_type variable

  # Add tags to the EC2 instance for better resource organization
  tags = {
    Name = "MyServer-${local.project_name}" # Tag with dynamic project name
  }
}

# Output the public IP address of the EC2 instance
output "public_ip" {
  value = aws_instance.my_server.public_ip # Retrieve the instance's public IP
  description = "The public IP address of the EC2 instance" # Helpful documentation
}
