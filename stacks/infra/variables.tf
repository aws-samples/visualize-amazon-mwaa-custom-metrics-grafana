variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  default = "dev"
}

variable "events_lambda_function_name" {
  default = "events-lambda"
}

variable "reserved_concurrent_executions" {
  type    = number
  default = "-1"
}

variable "blog_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "grafana_version" {
  type    = string
  default = "9.4"
}

variable "public_subnet_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "mwaa_events_bucket_name" {
  type    = string
  default = "mwaa-events-bucket"
}

variable "mwaa_events_logs_retention" {
  type    = number
  default = 90
}

variable "mwaa_metrics_bucket_name" {
  type    = string
  default = "mwaa-metrics-bucket"
}

variable "mwaa_metrics_logs_retention" {
  type    = number
  default = 90
}

variable "grafana_iam_role_name" {
  type    = string
  default = "grafana-role"
}

variable "grafana_iam_policy_name" {
  type    = string
  default = "grafana-policy"
}

variable "grafana_workspace_name" {
  type    = string
  default = "grafana-ws"
}

variable "job_env_mwaa_name" {
  type    = string
  default = "mwaa-compute"
}

variable "mwaa_env_class" {
  type    = string
  default = "mw1.small"
}

variable "max_mwaa_workers" {
  type    = number
  default = 5
}

variable "mwaa_iam_role_name" {
  type    = string
  default = "mwaa-role"
}

variable "mwaa_iam_policy_name" {
  type    = string
  default = "mwaa-policy"
}

variable "timestream_db_name" {
  type    = string
  default = "mwaa_metrics"
}

variable "timestream_table_name" {
  type    = string
  default = "dags_stats"
}
