resource "aws_s3_bucket" "main" {
  bucket        = var.md_metadata.name_prefix
  force_destroy = false
}

resource "aws_s3_bucket_acl" "private" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "main" {
  count  = var.bucket.intelligent_tiering.enabled ? 1 : 0
  bucket = aws_s3_bucket.main.id
  name   = "${var.md_metadata.name_prefix}-intelligent-tiering"
  status = var.bucket.intelligent_tiering.enabled ? "Enabled" : "Disabled"

  filter {
    prefix = var.bucket.intelligent_tiering.filter.prefix
    tags   = var.bucket.intelligent_tiering.filter.tags
  }

  dynamic "tiering" {
    for_each = var.bucket.intelligetn_tiering.tiering
    content {
      days        = tiering.value["days"]
      access_tier = tiering.value["access_tier"]
    }
  }
}