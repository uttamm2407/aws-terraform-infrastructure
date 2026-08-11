terraform {
  backend "s3" {
    bucket = "terraform-state-b0378263dbf092c13d2a970bdf"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
