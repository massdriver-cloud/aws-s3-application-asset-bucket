// TODO Remove this output
output "arn" {
    value = aws_s3_bucket.main.arn
}
resource "massdriver_artifact" "bucket" {
  field                = "bucket"
  provider_resource_id = aws_s3_bucket.main.arn
  name                 = "AWS S3 Bucket: ${aws_s3_bucket.main.arn}"
  artifact = jsonencode(
    {
      data = {
        infrastructure = {
          arn = aws_s3_bucket.main.arn
        }
        # TODO 
        # security = {
        #   iam = {
        #     publish = {
        #       policy_arn = aws_iam_policy.publish.arn
        #     }
        #   }
        # }
      }
      specs = {
        aws = {
          region = var.bucket.region
        }
      }
    }
  )
}
