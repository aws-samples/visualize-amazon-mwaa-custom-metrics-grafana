resource "aws_iam_role" "events_lambda_role" {
  name               = local.events_lambda_role_name
  assume_role_policy = templatefile("${path.module}/templates/events_lambda_assume_policy.json", {})
}

resource "aws_iam_policy" "events_lambda_policy" {
  name = local.events_lambda_policy_name
  policy = templatefile("${path.module}/templates/events_lambda_policy.json", {
    bucket_name          = aws_s3_bucket.mwaa_metrics.id
#    kms_arn              = aws_kms_key.lambda_kms_key.arn
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
    bucket_name = aws_s3_bucket.mwaa_events.id
    metrics_bucket_name = aws_s3_bucket.mwaa_metrics.id
    account_id = data.aws_caller_identity.caller_identity.account_id
#    kms_arn     = aws_kms_key.mwaa_events_kms_key.arn
  })
}

resource "aws_iam_role_policy_attachment" "mwaa_iam_attachment" {
  role       = aws_iam_role.mwaa_iam_role.name
  policy_arn = aws_iam_policy.mwaa_iam_policy.arn
}
