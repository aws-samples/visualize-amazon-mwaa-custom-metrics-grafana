/*
Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
SPDX-License-Identifier: MIT-0
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE. */

resource "aws_s3_bucket" "mwaa_metrics" {
  bucket        = local.mwaa_metrics_bucket_name
  force_destroy = local.s3_buckets_force_destroy
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
  bucket                  = aws_s3_bucket.mwaa_metrics.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "logs_bucket_notification" {
  bucket = aws_s3_bucket.mwaa_metrics.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.events_lambda.arn
    events              = ["s3:ObjectCreated:Put"]
  }

  depends_on = [aws_lambda_permission.s3_metrics_trigger]
}

resource "aws_s3_bucket" "mwaa_events" {
  bucket = local.mwaa_events_bucket_name
}

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
