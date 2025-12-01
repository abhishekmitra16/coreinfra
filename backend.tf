terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-abhishek-2025"
    region = "us-east-1"
    profile = "default"
    key = "projects/serverless-full-stack/terraform.tfstate"
    use_lockfile = true
    
  }
}