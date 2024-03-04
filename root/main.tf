module "vpc" {
  source = "../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  project_name = var.project_name
}