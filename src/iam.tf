data "aws_iam_policy_document" "bucket_read" {
  statement {
    sid    = "ListAccess"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.main.id}"
    ]
    actions = [
      "s3:ListBucket",
      "s3:HeadBucket"
    ]
  }
  statement {
    sid    = "ReadAccess"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.main.id}/*"
    ]
    actions = [
      "s3:GetObject*"
    ]
  }
  statement {
    sid    = "DecryptAccess"
    effect = "Allow"
    resources = [
        module.kms.key_arn
    ]
    actions = [
      "kms:Decrypt"
    ]
  }
}

data "aws_iam_policy_document" "bucket_write" {
  statement {
    sid    = "ListAccess"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.main.id}"
    ]
    actions = [
      "s3:ListBucket",
      "s3:HeadBucket"
    ]
  }
  statement {
    sid    = "WriteAccess"
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.main.id}/*",
    ]
    actions = [
      "s3:DeleteObject*",
      "s3:PutObject*",
      "s3:RestoreObject"
    ]
  }
  statement {
    sid    = "EncryptAccess"
    effect = "Allow"
    resources = [
      module.kms.key_arn
    ]
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]
  }
}

resource "aws_iam_policy" "read" {
  name        = "${aws_s3_bucket.main.id}-read-objects"
  description = "S3 read policy: ${aws_s3_bucket.main.id}"

  policy = data.aws_iam_policy_document.bucket_read.json
}

resource "aws_iam_policy" "write" {
  name        = "${aws_s3_bucket.main.id}-write-objects"
  description = "S3 write policy: ${aws_s3_bucket.main.id}"

  policy = data.aws_iam_policy_document.bucket_write.json
}