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

locals {
  // hack to get around for_each not accepting array of object we make some unique but meaningful keys
  // the hcl is so complex here because we need to ensure key uniqueness whether a filter is passed or not.
 intelligent_tiering_map = {for it in var.bucket.intelligent_tiering : join("-", concat([try(replace(it.filter.prefix, "/[^a-zA-Z0-9_.-]/", "_"), "nullprefix"), try(join("-", [for k,v in it.filter.tags : "${k}-${v}"]), "<nulltags>")], [for t in tolist(it.tiering) : join("-", [tostring(t.days), t.access_tier])])) => it}
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "main" {
  for_each = local.intelligent_tiering_map
  bucket = aws_s3_bucket.main.id
  name   = "${each.key}"
  status = "Enabled"

  dynamic "filter" {
    // only declare a filter block if the filter variable is non-null and non-empty
    for_each = [for x in [1] : each.value.filter if try(each.value.filter, {}) != {}]
    content {
      prefix = try(filter.value.prefix, null)
      tags   = try(filter.value.tags, null)
    }
  }

  dynamic "tiering" {
    for_each = each.value["tiering"]
    content {
      days        = tiering.value["days"]
      access_tier = tiering.value["access_tier"]
    }
  }
}