resource "aws_grafana_workspace" "grafana" {
  name                     = local.grafana_workspace_name
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "CUSTOMER_MANAGED"
  data_sources             = ["CLOUDWATCH"]
  description              = "Grafana workspace"
  role_arn                 = aws_iam_role.grafana_workspace_role.arn
  grafana_version          = local.grafana_version
  vpc_configuration {
    security_group_ids = [aws_security_group.grafana_security_group.id]
    subnet_ids         = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  }
  timeouts {
    create = "30m"
  }
}

resource "aws_security_group" "grafana_security_group" {
  description = "Grafana security group for outbound connection"
  name        = "aws-grafana-sg"
  vpc_id      = aws_vpc.blog_vpc.id

  egress {
    description = "Outbound rule for grafana security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "grafana_data_source" "events_timestream_datasource" {
  depends_on = [aws_grafana_workspace.grafana]

  type = "events-timestream-datasource"
  name = "mwaa_events_timestream"
  json_data_encoded = jsonencode({
    defaultRegion = data.aws_region.region.name
    authType      = "default"
    assumeRoleArn = aws_iam_role.grafana_workspace_role.arn
  })
}

resource "grafana_folder" "events_grafana_folder" {
  depends_on = [aws_grafana_workspace.grafana]
  title      = "MWAA events dashboards"
}

resource "grafana_dashboard" "events_grafana_dashboard" {
  depends_on = [aws_grafana_workspace.grafana]
  folder     = grafana_folder.events_grafana_folder.id
  config_json = templatefile("${path.module}/grafana/dashboard.json", {
    timestream_datasource = grafana_data_source.events_timestream_datasource.uid
  })
}

resource "aws_grafana_workspace_api_key" "grafana_admin_api_key" {
  key_name        = "admin-apikey"
  key_role        = "ADMIN"
  seconds_to_live = 2592000 # 30 days
  workspace_id    = aws_grafana_workspace.grafana.id
}
