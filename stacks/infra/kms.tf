#resource "aws_kms_key" "lambda_kms_key" {
#  description         = "KMS Key for Lambda environment resources"
#  enable_key_rotation = true
#
#  policy = templatefile("${path.module}/templates/lambda_kms_key_policy.json", {
#    account_id   = data.aws_caller_identity.caller_identity.account_id
#    dns_suffix   = data.aws_partition.partition.dns_suffix
#    issuer_arn   = data.aws_iam_session_context.session_context.issuer_arn
#    partition_id = data.aws_partition.partition.id
#    region       = data.aws_region.region.name
#  })
#}
#
#resource "aws_kms_alias" "lambda_kms_key_alias" {
#  target_key_id = aws_kms_key.lambda_kms_key.key_id
#  name          = "alias/lambda_kms_key_alias"
#}
#
#resource "aws_kms_key" "grafana_workspace_key" {
#  description         = "KMS Key for Grafana workspace"
#  enable_key_rotation = true
#
#  policy = templatefile("${path.module}/templates/grafana_kms_key_policy.json", {
#    account_id   = data.aws_caller_identity.caller_identity.account_id
#    dns_suffix   = data.aws_partition.partition.dns_suffix
#    issuer_arn   = data.aws_iam_session_context.session_context.issuer_arn
#    partition_id = data.aws_partition.partition.id
#    region       = data.aws_region.region.name
#  })
#}
#
#resource "aws_kms_alias" "grafana_kms_key_alias" {
#  target_key_id = aws_kms_key.grafana_workspace_key.key_id
#  name          = "alias/grafana_kms_key_alias"
#}
#
#resource "aws_kms_key" "mwaa_events_kms_key" {
#  description         = "KMS Key for S3 bucket"
#  enable_key_rotation = true
#
#  policy = templatefile("${path.module}/templates/s3_kms_key_policy.json", {
#    account_id   = data.aws_caller_identity.caller_identity.account_id
#    dns_suffix   = data.aws_partition.partition.dns_suffix
#    issuer_arn   = data.aws_iam_session_context.session_context.issuer_arn
#    partition_id = data.aws_partition.partition.id
#    region       = data.aws_region.region.name
#  })
#}
#
#resource "aws_kms_alias" "mwaa_events_kms_key_alias" {
#  target_key_id = aws_kms_key.mwaa_events_kms_key.key_id
#  name          = "alias/s3_mwaa_kms_key_alias"
#}
#
#resource "aws_kms_key" "timestream_kms_key" {
#  description         = "KMS Key for Timestream DB"
#  enable_key_rotation = true
#
#  policy = templatefile("${path.module}/templates/timestream_kms_key_policy.json", {
#    account_id   = data.aws_caller_identity.caller_identity.account_id
#    region       = data.aws_region.region.name
#    partition_id = data.aws_partition.partition.id
#  })
#}
#
#resource "aws_kms_alias" "timestream_kms_key_alias" {
#  target_key_id = aws_kms_key.timestream_kms_key.key_id
#  name          = "alias/timestream_kms_key_alias"
#}
