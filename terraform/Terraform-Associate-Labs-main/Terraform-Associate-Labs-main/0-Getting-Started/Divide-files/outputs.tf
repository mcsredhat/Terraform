#outputs.tf file
# Define an output variable named "public_ip".
output "public_ip" {
  # Specify the value to be outputted after the Terraform apply phase.
  # This value retrieves the public IP address of the EC2 instance 
  # defined in the "aws_instance.my_server" resource.
  value = aws_instance.my_server.public_ip
}
