terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.92.0"
    }
  }

  
  backend "s3" {
    bucket           = "java-buck-25"
    key              = var.key_name
    region           = var.region
    dynamodb_table   = "java-db-25"
  }
}


provider "aws" {
  # Configuration options
  region = var.region
}