# main.tf file
terraform {
  # Define backend settings for storing Terraform state files remotely.
  # The `backend` block is commented out, so these settings are not in use.
  # This block would configure Terraform to use Terraform Cloud as the backend.
  # backend "remote" {
  #   hostname = "app.terraform.io"  # The Terraform Cloud hostname.
  #   organization = "ExamPro"       # The Terraform Cloud organization name.

  #   workspaces {
  #     name = "getting-started"     # The workspace name for this project.
  #   }
  # }

  # Define Terraform Cloud settings for state storage and management.
  cloud {
    hostname = "app.terraform.io"      # Specify the Terraform Cloud hostname.
    organization = "ExamPro"           # The Terraform Cloud organization name.

    workspaces {
      name = "getting-started"         # The workspace name used in Terraform Cloud.
    }
  }

  # Specify the required providers for the Terraform configuration.
  required_providers {
    aws = {
      source  = "hashicorp/aws"        # Indicate the AWS provider source.
      version = "~> 5.0"               # Use AWS provider versions compatible with 5.x.
    }
  }
}

# Define local variables for reuse in the configuration.
locals {
  project_name = "Andrew"              # A local variable storing the project name.
}
