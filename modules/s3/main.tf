resource "aws_s3_bucket" "react_frontend_bucket" {
  bucket = "${var.project_name}-frontend"

  tags = {
    Name = "${var.project_name}-frontend"
  }
}


resource "aws_s3_bucket_ownership_controls" "react_bucket_owner" {
  bucket = aws_s3_bucket.react_frontend_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "react_bucket_public_access" {
  bucket = aws_s3_bucket.react_frontend_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${var.project_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


resource "aws_s3_bucket_policy" "react_frontend_bucket_policy" {
  bucket = aws_s3_bucket.react_frontend_bucket.id

  policy = data.aws_iam_policy_document.react_frontend_bucket_policy.json
}


data "aws_iam_policy_document" "react_frontend_bucket_policy" {
  statement {

    sid    = "AllowCloudFrontServicePrincipalReadOnly"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.react_frontend_bucket.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        var.cloudfront_distribution_arn
      ]
    }

  }
}


