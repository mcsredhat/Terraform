#variables.tf file
# Declare a variable named "instance_type" to define the type of EC2 instance.
variable "instance_type" {
  type = string  # Specifies that this variable must be a string.
  
  # Optional: Add a description for documentation purposes.
  description = "The type of EC2 instance to create, e.g., t2.micro, t3.medium"
  
  # Optional: Define a default value if no value is provided in tfvars or CLI.
  # default = "t3.micro"
}
