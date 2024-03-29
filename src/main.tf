resource "aws_s3_bucket" "main" {
  bucket        = var.md_metadata.name_prefix
  force_destroy = lookup(var.bucket, "force_destroy", false)
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    # this setting disables ACLs
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


// Access Logging
resource "aws_s3_bucket" "access_logs" {
  count  = var.monitoring.access_logging ? 1 : 0
  bucket = "${var.md_metadata.name_prefix}-logging"
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "access_logs" {
  count  = var.monitoring.access_logging ? 1 : 0
  bucket = aws_s3_bucket.access_logs.0.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "access_logs" {
  count      = var.monitoring.access_logging ? 1 : 0
  bucket     = aws_s3_bucket.access_logs.0.id
  acl        = "log-delivery-write"
  depends_on = [aws_s3_bucket_ownership_controls.access_logs]
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  count  = var.monitoring.access_logging ? 1 : 0
  bucket = aws_s3_bucket.access_logs.0.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_logging" "main" {
  count  = var.monitoring.access_logging ? 1 : 0
  bucket = aws_s3_bucket.main.id

  target_bucket = aws_s3_bucket.access_logs.0.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  count  = var.monitoring.access_logging ? 1 : 0
  bucket = aws_s3_bucket.access_logs.0.id

  rule {
    id = "lifecycle"

    status = "Enabled"

    transition {
      days          = 7
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}