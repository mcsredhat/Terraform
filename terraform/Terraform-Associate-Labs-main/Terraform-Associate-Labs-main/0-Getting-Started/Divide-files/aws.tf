#define aws.tf file 
# Define an AWS EC2 instance resource named "my_server".
resource "aws_instance" "my_server" {
  # Specify the Amazon Machine Image (AMI) ID for the instance. This ID refers to the base OS or software image.
  ami           = "ami-087c17d1fe0178315"
  
  # Set the instance type (e.g., t2.micro, t3.medium) using a variable. This determines the hardware configuration of the instance.
  instance_type = var.instance_type

  # Add tags to the instance for identification and organization. 
  tags = {
    # Assign a name to the instance, dynamically appending the project name from a local variable.
    Name = "MyServer-${local.project_name}"
  }
}

# The following block is commented out (not executed in Terraform). 
# It defines a module configuration for creating a Virtual Private Cloud (VPC).

/*
module "vpc" {
  # Source of the module, which is an official Terraform AWS VPC module from the Terraform Registry.
  source = "terraform-aws-modules/vpc/aws"
  
  # Specify providers to use with the module. Here, it uses a specific AWS provider named `aws.eu`.
  providers = {
    aws = aws.eu
  }

  # Set the name for the VPC to help identify it in the AWS environment.
  name = "my-vpc"

  # Define the CIDR block for the VPC. This is the range of IP addresses that can be used within the VPC.
  cidr = "10.0.0.0/16"

  # Specify the availability zones (AZs) to use for subnets. This ensures resources are distributed across regions for high availability.
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  # Define private subnets within the VPC. These subnets are not directly accessible from the internet.
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  # Define public subnets within the VPC. These subnets are accessible from the internet.
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # Enable NAT Gateway to allow private subnets to access the internet for outbound traffic.
  enable_nat_gateway = true

  # Enable VPN Gateway for connecting the VPC to an external network via a VPN connection.
  enable_vpn_gateway = true

  # Add tags for the VPC, which help with resource organization and identification.
  tags = {
    Terraform    = "true" # Tag to indicate the resource is managed by Terraform.
    Environment  = "dev"  # Tag to indicate the environment (e.g., development).
  }
}
*/
