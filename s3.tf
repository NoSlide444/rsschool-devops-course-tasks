provider "aws" {
  region = "eu-north-1" 
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "rs-terraform-state-bucket-noslide" 
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "Terraform State Bucket"
  }
}

resource "aws_dynamodb_table" "RS_TF_LockID" {
  name         = "RS_TF_LockID"
  billing_mode = "PAY_PER_REQUEST" 

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID" 

  tags = {
    Name = "RS_TF_LockID"
  }
}

terraform {
  backend "s3" {
    bucket         = "rs-terraform-state-bucket-noslide"
    key            = "state/terraform.tfstate"
    region         = "eu-north-1"
    encrypt        = true
    dynamodb_table = "RS_TF_LockID"
  }
}
