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


resource "aws_grafana_workspace" "grafana" {
  name                     = local.grafana_workspace_name
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  data_sources             = ["CLOUDWATCH", "TIMESTREAM"]
  description              = "Grafana workspace"
  role_arn                 = aws_iam_role.grafana_workspace_role.arn
  grafana_version          = local.grafana_version
  configuration = jsonencode({
    unifiedAlerting = {
      enabled = true
    }
  })
  vpc_configuration {
    security_group_ids = [aws_security_group.grafana_security_group.id]
    subnet_ids         = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  }
  notification_destinations = ["SNS"]
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

resource "aws_grafana_workspace_api_key" "grafana_admin_api_key" {
  depends_on      = [aws_grafana_workspace.grafana]
  key_name        = "admin-apikey"
  key_role        = "ADMIN"
  seconds_to_live = 2592000 # 30 days
  workspace_id    = aws_grafana_workspace.grafana.id
}


resource "null_resource" "plugin_mgmt" {
  depends_on = [aws_grafana_workspace.grafana, aws_grafana_workspace_api_key.grafana_admin_api_key]
  provisioner "local-exec" {
    command = "aws grafana update-workspace-configuration --region ${data.aws_region.region.name} --workspace-id ${aws_grafana_workspace.grafana.id} --configuration '{\"plugins\": {\"pluginAdminEnabled\": true}}'"
  }
}

resource "grafana_data_source" "events_timestream_datasource" {
  depends_on = [aws_grafana_workspace.grafana, null_resource.plugin_mgmt]

  type = "grafana-timestream-datasource"
  name = "mwaa_events_timestream"
  json_data_encoded = jsonencode({
    defaultRegion = data.aws_region.region.name
    authType      = "default"
  })
}

resource "grafana_folder" "events_grafana_folder" {
  depends_on = [aws_grafana_workspace.grafana, null_resource.plugin_mgmt]
  title      = "MWAA events dashboards"
}

resource "grafana_dashboard" "events_grafana_dashboard" {
  depends_on = [aws_grafana_workspace.grafana, null_resource.plugin_mgmt]
  folder     = grafana_folder.events_grafana_folder.id
  config_json = templatefile("${path.module}/grafana/dashboard.json", {
    timestream_datasource = grafana_data_source.events_timestream_datasource.uid
  })
}

