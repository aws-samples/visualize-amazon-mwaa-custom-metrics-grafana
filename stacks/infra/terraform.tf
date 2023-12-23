terraform {
  required_providers {
    aws = "~> 5.21.0"
    grafana = {
      source  = "grafana/grafana"
      version = "2.6.1"
    }
  }
  required_version = "~> 1.6.1"
}

provider "aws" {
  region = local.aws_region
}


provider "grafana" {
  url  = join("", ["https://", aws_grafana_workspace.grafana.endpoint])
  auth = aws_grafana_workspace_api_key.grafana_admin_api_key.key
}

#provider "grafana" {
#  url  = "https://g-827fa67a09.grafana-workspace.us-east-1.amazonaws.com"
#  auth = "eyJrIjoiSEY5a01WeEZUSUlocWVvYmVvdVZ2MUkwcEVsdWcxTE8iLCJuIjoiYWRtaW4iLCJpZCI6MX0="
#}