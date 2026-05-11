terraform {
  backend "s3" {
    bucket = "duc-test-bucket-123456789"
    key    = "myapp/dev.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
