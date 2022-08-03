resource "aws_iam_policy" "read" {
  name        = "${var.md_metadata.name_prefix}-read-objects"
  description = "S3 read policy: ${var.md_metadata.name_prefix}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3: ListBucket"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.main.arn}/*"
      }
      // TODO add KMS policy
    ]
  })
}

resource "aws_iam_policy" "write" {
  name        = "${var.md_metadata.name_prefix}-write-objects"
  description = "S3 read policy: ${var.md_metadata.name_prefix}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*Object", "s3:ListBucket"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.main.arn}/*"
      }
      // TODO add KMS policy
    ]
  })
}