resource "aws_security_group" "mwaa_security_group" {
  description = "MWAA security group for outbound connection"
  vpc_id      = aws_vpc.blog_vpc.id

  egress {
    description = "Outbound rule for MWAA security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Inbound rule for self security group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }
  tags = {
    Name = "mwaa-sg"
  }
}

# resource "aws_mwaa_environment" "job_env" {
#   name                 = local.job_env_mwaa_name
#   dag_s3_path          = "dags/"
#   execution_role_arn   = aws_iam_role.mwaa_iam_role.arn
#   source_bucket_arn    = aws_s3_bucket.mwaa_events.arn
#   requirements_s3_path = "requirements.txt"
#   #kms_key               = aws_kms_key.mwaa_events_kms_key.arn
#   webserver_access_mode = "PUBLIC_ONLY"
#   environment_class     = local.mwaa_env_class
#   max_workers           = local.max_mwaa_workers

#   network_configuration {
#     security_group_ids = [aws_security_group.mwaa_security_group.id]
#     subnet_ids         = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
#   }

#   airflow_configuration_options = {
#     "core.default_task_retries" = 10
#     "core.parallelism"          = 1
#     "core.lazy_load_plugins"    = false
#   }

#   logging_configuration {
#     dag_processing_logs {
#       enabled   = true
#       log_level = "WARNING"
#     }

#     scheduler_logs {
#       enabled   = true
#       log_level = "WARNING"
#     }

#     task_logs {
#       enabled   = true
#       log_level = "WARNING"
#     }

#     webserver_logs {
#       enabled   = true
#       log_level = "WARNING"
#     }

#     worker_logs {
#       enabled   = true
#       log_level = "WARNING"
#     }
#   }


#   depends_on = [aws_s3_object.mwaa_reqs]
# }
