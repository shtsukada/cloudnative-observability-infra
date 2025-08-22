data "aws_caller_identity" "current" {}

locals {
  bucket_name = lower(format("%s-%s-tfstate-%s-%s",
    var.project, var.env, data.aws_caller_identity.current.account_id,var.aws_region
  ))
  table_name = "${var.project}-tf-locks"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "${var.project}-tf-${var.env}-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
}

resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "pab" {
  bucket = aws_s3_bucket.tf_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "tls_only" {
  bucket = aws_s3_bucket.tf_state.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid = "DenyInsecureTransport",Effect = "Deny", Principal = "*",
      Action = "s3:*"
      Resource = [aws_s3_bucket.tf_state.arn, "${aws_s3_bucket.tf_state.arn}/*"],
      Condition = { Bool ={ "aws:SecureTransport" = "false" } }
    }]
  })
}

resource "aws_dynamodb_table" "tf_locks" {
  name = local.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.tf_state.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.tf_locks.name
}
