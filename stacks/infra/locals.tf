locals {
  events_lambda_function_name = join("-", [
    var.events_lambda_function_name,
    var.environment
  ])
  environment = var.environment
  aws_region  = var.aws_region
  events_lambda_role_name = join("-", [
    var.events_lambda_function_name,
    "role",
    var.environment
  ])
  events_lambda_policy_name = join("-", [
    var.events_lambda_function_name,
    "policy",
    var.environment
  ])
  reserved_concurrent_executions = var.reserved_concurrent_executions
  grafana_iam_policy_name = join("-", [
    var.grafana_iam_policy_name,
    var.environment
  ])
  grafana_iam_role_name = join("-", [
    var.grafana_iam_role_name,
    var.environment
  ])
  grafana_workspace_name = join("-", [
    var.grafana_workspace_name,
    var.environment
  ])
  blog_vpc_cidr       = var.blog_vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  grafana_version     = var.grafana_version
  mwaa_events_bucket_name = join("-", [
    var.mwaa_events_bucket_name,
    data.aws_caller_identity.caller_identity.account_id,
    var.environment
  ])
  mwaa_events_logs_retention = var.mwaa_events_logs_retention
  mwaa_metrics_bucket_name = join("-", [
    var.mwaa_metrics_bucket_name,
    data.aws_caller_identity.caller_identity.account_id,
    var.environment
  ])
  mwaa_metrics_logs_retention = var.mwaa_metrics_logs_retention
  job_env_mwaa_name = join("-", [
    var.job_env_mwaa_name,
    var.environment
  ])
  mwaa_env_class   = var.mwaa_env_class
  max_mwaa_workers = var.max_mwaa_workers
  mwaa_iam_role_name = join("-", [
    var.mwaa_iam_role_name,
    var.environment
  ])
  mwaa_iam_policy_name = join("-", [
    var.mwaa_iam_policy_name,
    var.environment
  ])
#  timestream_db_name = var.timestream_db_name
#  timestream_table_name = var.timestream_table_name
}
