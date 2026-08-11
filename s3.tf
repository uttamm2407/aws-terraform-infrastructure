resource "aws_s3_bucket" "project" {
  bucket_prefix = "terraform-devops-project-"

  tags = {
    Name    = "terraform-devops-bucket"
    Project = "aws-terraform-project"
  }
}