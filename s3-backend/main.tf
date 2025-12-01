provider "aws" {
  profile                 = var.profile
  region                  = var.region
}

resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name

    tags = {
        Name = "S3 Remote Terraform State Store"
    }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access" {
    bucket = aws_s3_bucket.bucket.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
    bucket = aws_s3_bucket.bucket.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
    }


resource "aws_s3_bucket_versioning" "versioning" {
    bucket = aws_s3_bucket.bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}


# resource "aws_dynamodb_table" "table" {
#     name         = var.dynamodb_table_name
#     billing_mode = "PAY_PER_REQUEST"
#     hash_key     = "LockID"

#     attribute {
#         name = "LockID"
#         type = "S"
#     }

#     tags = {
#         Name = "DynamoDB Table for Terraform State Locking"
#     }
# }