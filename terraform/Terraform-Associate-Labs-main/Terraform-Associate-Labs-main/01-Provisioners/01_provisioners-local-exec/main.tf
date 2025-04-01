In Terraform, a provisioner is used to execute specific actions on a resource after it has been created or modified. Provisioners are often used to perform tasks like configuring a server or uploading files, which can’t be directly handled by Terraform itself, but are needed to fully set up a resource. They help automate the setup and configuration of infrastructure once it is provisioned.
1:provisioners local-exec 
Purpose:
The local-exec provisioner allows you to perform additional configuration or logging tasks locally after the resource is created or updated.
It is typically used for tasks like logging information, invoking scripts, or interacting with other systems that are accessible from the local machine.
### Scenario:

You are tasked with deploying a secure web server in AWS using Terraform. The requirements are as follows:

1. **Networking Configuration**:
   - The server must be placed inside an existing VPC with ID `vpc-xxxxx`.
   - The server should allow HTTP traffic from anywhere.
   - SSH access must be restricted to a specific IP address (`xxxxx`).

2. **Security Configuration**:
   - The instance should only allow outbound traffic to any destination.

3. **Access Management**:
   - Create a key pair named `deployer-key` using a provided SSH public key for secure access.

4. **Instance Configuration**:
   - Use the `ami-087c17d1fe0178315` Amazon Machine Image.
   - Deploy a `t2.micro` instance.
   - Use a user data script (`userdata.yaml`) for initialization.
   - Attach the above-defined security group to the instance.

5. **Provisioning**:
   - After deployment, log the instance's private IP to a file named `private_ips.txt` on the local machine.

6. **Output**:
   - Display the public IP address of the deployed instance after Terraform completes.

---

**Question**:  
How would you write a Terraform configuration to fulfill the above requirements while adhering to security and networking best practices? 

Write a Terraform code block to solve this scenario.
########################################
# Define the Terraform configuration block
terraform  {
  # Specify the required provider and its version
  required_providers {
    aws = {
      source = "hashicorp/aws"  # AWS provider source
      version = "5.78.0"  # AWS provider version to use
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1"  # Define the AWS region where resources will be created (US East - N. Virginia)
}

# Fetch details about an existing VPC by ID
data "aws_vpc" "main" {
  id = "vpc-bd9bdcc7"  # Specify the VPC ID to query its metadata
}

# Define a security group resource
resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"  # Name of the security group
  description = "MyServer Security Group"  # Description of the security group
  vpc_id      = data.aws_vpc.main.id  # Associate the security group with the VPC fetched above

  # Ingress (inbound) rules to allow specific traffic
  ingress = [
    {
      description      = "HTTP"  # Allow HTTP traffic
      from_port        = 80  # Starting port
      to_port          = 80  # Ending port (single port 80)
      protocol         = "tcp"  # Protocol is TCP
      cidr_blocks      = ["0.0.0.0/0"]  # Allow traffic from any IPv4 address
      ipv6_cidr_blocks = []  # No IPv6 traffic allowed
      prefix_list_ids  = []  # No prefix lists specified
      security_groups  = []  # No associated security groups
      self = false  # Disallow traffic from other resources within the same security group
    },
    {
      description      = "SSH"  # Allow SSH traffic
      from_port        = 22  # Starting port (SSH)
      to_port          = 22  # Ending port (SSH)
      protocol         = "tcp"  # Protocol is TCP
      cidr_blocks      = ["104.194.51.113/32"]  # Restrict SSH access to a specific IPv4 address
      ipv6_cidr_blocks = []  # No IPv6 traffic allowed
      prefix_list_ids  = []  # No prefix lists specified
      security_groups  = []  # No associated security groups
      self = false  # Disallow traffic from other resources within the same security group
    }
  ]

  # Egress (outbound) rules to allow all outgoing traffic
  egress = [
    {
      description      = "outgoing traffic"  # Allow all outbound traffic
      from_port        = 0  # Starting port (all ports)
      to_port          = 0  # Ending port (all ports)
      protocol         = "-1"  # Allow all protocols
      cidr_blocks      = ["0.0.0.0/0"]  # Allow traffic to any IPv4 address
      ipv6_cidr_blocks = ["::/0"]  # Allow traffic to any IPv6 address
      prefix_list_ids  = []  # No prefix lists specified
      security_groups  = []  # No associated security groups
      self = false  # Disallow traffic from other resources within the same security group
    }
  ]
}

# Create an AWS Key Pair resource
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"  # Set the key pair's name
  public_key = "YOUR_SSH_KEY"  # Specify the public SSH key for secure access
}

# Use a template file for user data
data "template_file" "user_data" {
  template = file("./userdata.yaml")  # Load the user data script from an external YAML file
}

# Define an EC2 instance resource
resource "aws_instance" "my_server" {
  ami           = "ami-087c17d1fe0178315"  # Specify the Amazon Machine Image (AMI) ID
  instance_type = "t2.micro"  # Use a t2.micro instance type (small, cost-effective)
  key_name      = aws_key_pair.deployer.key_name  # Associate the instance with the SSH key pair
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]  # Attach the security group to the instance
  user_data     = data.template_file.user_data.rendered  # Initialize the instance using the user data script

  # Local execution provisioner to save the private IP address locally
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"  # Save the private IP to a file
  }

  tags = {
    Name = "MyServer"  # Assign a tag to identify the instance
  }
}

# Output the public IP of the EC2 instance
output "public_ip" {
  value = aws_instance.my_server.public_ip  # Provide the instance's public IP address as an output
}
