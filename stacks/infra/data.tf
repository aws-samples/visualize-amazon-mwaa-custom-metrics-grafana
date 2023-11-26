
data "aws_caller_identity" "caller_identity" {}

data "aws_iam_session_context" "session_context" {
  arn = data.aws_caller_identity.caller_identity.arn
}

data "aws_partition" "partition" {}

data "aws_region" "region" {}

data "aws_availability_zones" "available" {}

data "aws_iam_policy" "AmazonTimestreamReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonTimestreamReadOnlyAccess"
}
