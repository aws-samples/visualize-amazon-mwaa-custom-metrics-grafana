data "archive_file" "events_lambda_code_zip" {
  type        = "zip"
  source_file = "${path.module}/src/metrics_parser.py"
  output_path = "metrics_parser-lambda.zip"
}

## Lambda Functions

resource "aws_lambda_function" "events_lambda" {
  #checkov:skip=CKV_AWS_117:Lambda function doesn't need to connect to resources in a VPC
  #checkov:skip=CKV_AWS_116:Dead letter queue functionality not required
  #checkov:skip=CKV_AWS_272:Custom code, code-signing not implemented
  filename                       = data.archive_file.events_lambda_code_zip.output_path
  source_code_hash               = data.archive_file.events_lambda_code_zip.output_base64sha256
  handler                        = "metrics_parser.lambda_handler"
#  kms_key_arn                    = aws_kms_key.lambda_kms_key.arn
  runtime                        = "python3.10"
  reserved_concurrent_executions = local.reserved_concurrent_executions
  function_name                  = local.events_lambda_function_name
  role                           = aws_iam_role.events_lambda_role.arn
  timeout                        = 60
  memory_size                    = 512
  ephemeral_storage {
    size = 1024
  }
  environment {
    variables = {
      TABLE_NAME = var.timestream_table_name
      DB_NAME  = var.timestream_db_name
      REGION_NAME   = data.aws_region.region.name
      METRICS_BUCKET_NAME = aws_s3_bucket.mwaa_events.bucket
    }
  }
  layers = ["arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python310:7"]

  # vpc_config {
  #   subnet_ids         = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  #   security_group_ids = [aws_security_group.events_lambda_sg.id]
  # }
  tracing_config {
    mode = "Active"
  }
}

resource "aws_lambda_permission" "s3_metrics_trigger" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.events_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.mwaa_metrics.arn
}

# resource "aws_security_group" "events_lambda_sg" {
#   description = "Events Lambda security group"
#   vpc_id      = aws_vpc.blog_vpc.id

#   egress {
#     description = "Outbound traffic rule"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     description = "Inbound rule for self security group"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     self        = true
#   }
#   tags = {
#     Name = "events-lambda-sg"
#   }
# }
#
#resource "aws_lambda_layer_version" "pandas_lambda_layer" {
#  filename   = "${path.module}/src/pandas.zip"
#  layer_name = "pandas"
#  compatible_runtimes = ["python3.10"]
#  source_code_hash = data.archive_file.events_lambda_code_zip.output_base64sha256
#}
