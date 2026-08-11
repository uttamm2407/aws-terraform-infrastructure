resource "aws_s3_bucket" "project" {
  bucket_prefix = "terraform-devops-project-"

  tags = {
    Name    = "terraform-devops-bucket"
    Project = "aws-terraform-project"
  }
}
# Dedicated Terraform State Bucket

resource "aws_s3_bucket" "terraform_state" {
  bucket_prefix = "terraform-state-"

  tags = {
    Name    = "terraform-state"
    Project = var.project_name
  }
}
