terraform {
  backend "s3" {
    bucket = "remote-s3-tf-state"
    key    = "tribaxy/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terra-lock"
  }
}
