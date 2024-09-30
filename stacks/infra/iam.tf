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

resource "aws_iam_role" "events_lambda_role" {
  name               = local.events_lambda_role_name
  assume_role_policy = templatefile("${path.module}/templates/events_lambda_assume_policy.json", {})
}

resource "aws_iam_policy" "events_lambda_policy" {
  name = local.events_lambda_policy_name
  policy = templatefile("${path.module}/templates/events_lambda_policy.json", {
    bucket_name          = aws_s3_bucket.mwaa_metrics.id
    timestream_table_arn = aws_timestreamwrite_table.events_store.arn
  })
}

resource "aws_iam_role_policy_attachment" "events_lambda_attachment" {
  role       = aws_iam_role.events_lambda_role.name
  policy_arn = aws_iam_policy.events_lambda_policy.arn
}

resource "aws_iam_role" "grafana_workspace_role" {
  name               = local.grafana_iam_role_name
  assume_role_policy = templatefile("${path.module}/templates/grafana_workspace_assume_policy.json", {})
}

resource "aws_iam_policy" "grafana_workspace_policy" {
  name   = local.grafana_iam_policy_name
  policy = templatefile("${path.module}/templates/grafana_workspace_policy.json", {})
}

resource "aws_iam_role_policy_attachment" "grafana_workspace_role_attachment" {
  role       = aws_iam_role.grafana_workspace_role.name
  policy_arn = aws_iam_policy.grafana_workspace_policy.arn
}

resource "aws_iam_role_policy_attachment" "grafana_timestream_role_attachment" {
  role       = aws_iam_role.grafana_workspace_role.name
  policy_arn = data.aws_iam_policy.AmazonTimestreamReadOnlyAccess.arn
}

resource "aws_iam_role" "mwaa_iam_role" {
  name               = local.mwaa_iam_role_name
  assume_role_policy = templatefile("${path.module}/templates/mwaa_assume_policy.json", {})
}

resource "aws_iam_policy" "mwaa_iam_policy" {
  name = local.mwaa_iam_policy_name
  policy = templatefile("${path.module}/templates/mwaa_policy.json", {
    bucket_name         = aws_s3_bucket.mwaa_events.id
    metrics_bucket_name = aws_s3_bucket.mwaa_metrics.id
    account_id          = data.aws_caller_identity.caller_identity.account_id
  })
}

resource "aws_iam_role_policy_attachment" "mwaa_iam_attachment" {
  role       = aws_iam_role.mwaa_iam_role.name
  policy_arn = aws_iam_policy.mwaa_iam_policy.arn
}
