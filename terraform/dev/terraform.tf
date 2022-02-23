terraform {
  backend "s3" {
    bucket = "cf-devops-trainig"
    key    = "trainig/cluster.tfstate"
    region = "eu-west-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}
