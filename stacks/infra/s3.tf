resource "aws_s3_bucket" "mwaa_metrics" {
  bucket = local.mwaa_metrics_bucket_name

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_s3_bucket_lifecycle_configuration" "mwaa_metrics_lifecycle" {
  bucket = aws_s3_bucket.mwaa_metrics.bucket

  rule {
    id     = "expiration"
    status = "Enabled"

    expiration {
      days = local.mwaa_metrics_logs_retention
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

}

resource "aws_s3_bucket_public_access_block" "mwaa_metrics_access_logs_bucket_access_block" {
  bucket = aws_s3_bucket.mwaa_metrics.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "logs_bucket_notification" {
  bucket = aws_s3_bucket.mwaa_metrics.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.events_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"
  }

  depends_on = [aws_lambda_permission.s3_metrics_trigger]
}

resource "aws_s3_bucket" "mwaa_events" {
  bucket = local.mwaa_events_bucket_name

  # lifecycle {
  #   prevent_destroy = false
  # }
}

# resource "aws_s3_bucket_versioning" "mwaa_events_versioning" {
#   bucket = aws_s3_bucket.mwaa_events.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "mwaa_events_sse" {
#   bucket = aws_s3_bucket.mwaa_events.bucket

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.mwaa_events_kms_key.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }

resource "aws_s3_bucket_ownership_controls" "mwaa_events_access_logs_controls" {
  bucket = aws_s3_bucket.mwaa_events.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "mwaa_events_lifecycle" {
  bucket = aws_s3_bucket.mwaa_events.bucket

  rule {
    id     = "expiration"
    status = "Enabled"

    expiration {
      days = local.mwaa_events_logs_retention
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

}

resource "aws_s3_bucket_public_access_block" "mwaa_events_access_logs_bucket_access_block" {
  bucket = aws_s3_bucket.mwaa_events.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "mwaa_reqs" {
  for_each = fileset("./mwaa/", "**")
  bucket   = aws_s3_bucket.mwaa_events.id
  key      = each.value
  source   = "./mwaa/${each.value}"
  etag     = filemd5("./mwaa/${each.value}")
}
