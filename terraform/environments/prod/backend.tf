terraform {
  backend "s3" {
    bucket         = "kalana-terraform-state-bucket-2026"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}