terraform {
  required_providers {
    aws = "~> 5.21"
    grafana = {
      source  = "grafana/grafana"
      version = "~> 3.6"
    }
  }
  required_version = ">= 1.6.1, < 2.0.0"

}

provider "aws" {
  region = local.aws_region
}


provider "grafana" {
  url  = join("", ["https://", aws_grafana_workspace.grafana.endpoint])
  auth = aws_grafana_workspace_api_key.grafana_admin_api_key.key
}

