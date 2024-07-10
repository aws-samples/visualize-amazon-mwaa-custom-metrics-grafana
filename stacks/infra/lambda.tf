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

data "archive_file" "events_lambda_code_zip" {
  type        = "zip"
  source_file = "${path.module}/src/metrics_parser.py"
  output_path = "metrics-parser-lambda.zip"
}

resource "aws_lambda_function" "events_lambda" {
  #checkov:skip=CKV_AWS_117:Lambda function doesn't need to connect to resources in a VPC
  #checkov:skip=CKV_AWS_116:Dead letter queue functionality not required
  #checkov:skip=CKV_AWS_272:Custom code, code-signing not implemented
  filename                       = data.archive_file.events_lambda_code_zip.output_path
  source_code_hash               = data.archive_file.events_lambda_code_zip.output_base64sha256
  handler                        = "metrics_parser.lambda_handler"
  runtime                        = "python3.10"
  reserved_concurrent_executions = local.reserved_concurrent_executions
  function_name                  = local.events_lambda_function_name
  role                           = aws_iam_role.events_lambda_role.arn
  timeout                        = 60
  memory_size                    = 512
  ephemeral_storage {
    size = 1024
  }
  environment {
    variables = {
      TABLE_NAME = var.timestream_table_name
      DB_NAME  = var.timestream_db_name
      REGION_NAME   = data.aws_region.region.name
      METRICS_BUCKET_NAME = aws_s3_bucket.mwaa_events.bucket
    }
  }
  layers = ["arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python310:7"]

  tracing_config {
    mode = "Active"
  }
}

resource "aws_lambda_permission" "s3_metrics_trigger" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.events_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.mwaa_metrics.arn
}
