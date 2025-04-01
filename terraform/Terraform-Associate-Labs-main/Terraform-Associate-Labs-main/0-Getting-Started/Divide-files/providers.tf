#variables.tf
# Configure the default AWS provider for the us-east-1 region.
provider "aws" {
  # Optionally specify the AWS credentials profile to use (commented out here).
  # If not specified, the default profile or environment credentials are used.
  # profile = "default"

  # Set the AWS region for this provider. Resources using this provider will
  # be created in the "us-east-1" region.
  region  = "us-east-1"
}

# Configure a second AWS provider for the eu-west-1 region, using an alias.
provider "aws" {
  # Optionally specify the AWS credentials profile to use (commented out here).
  # profile = "default"

  # Set the AWS region for this provider. Resources using this provider will
  # be created in the "eu-west-1" region.
  region  = "eu-west-1"

  # Assign an alias to this provider configuration. Resources that need to
  # use this provider must reference it explicitly via this alias.
  alias   = "eu"
}
