<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.21.0 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | 2.6.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.21.0 |
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | 2.6.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.natgw_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_grafana_workspace.grafana](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace) | resource |
| [aws_grafana_workspace_api_key.grafana_admin_apikey](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/grafana_workspace_api_key) | resource |
| [aws_iam_policy.events_lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.grafana_workspace_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.mwaa_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.events_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.grafana_workspace_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.mwaa_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.events_lambda_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.grafana_timestream_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.grafana_workspace_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.mwaa_iam_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_kms_alias.grafana_kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.lambda_kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.mwaa_events_kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.timestream_kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.grafana_workspace_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.lambda_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.mwaa_events_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key.timestream_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_function.events_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_layer_version.pandas_lambda_layer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [aws_lambda_permission.s3_metrics_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_nat_gateway.natgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private_subnet_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_subnet_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_subnet1_rt_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_subnet2_rt_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet1_rt_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_subnet2_rt_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.mwaa_events](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.mwaa_metrics](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.mwaa_events_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.mwaa_metrics_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_notification.logs_bucket_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_ownership_controls.mwaa_events_access_logs_controls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.mwaa_events_access_logs_bucket_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_public_access_block.mwaa_metrics_access_logs_bucket_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_object.mwaa_reqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_security_group.grafana_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.mwaa_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.private_subnet1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_subnet2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_timestreamwrite_database.events_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/timestreamwrite_database) | resource |
| [aws_timestreamwrite_table.events_store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/timestreamwrite_table) | resource |
| [aws_vpc.blog_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [grafana_dashboard.events_grafana_dashboard](https://registry.terraform.io/providers/grafana/grafana/2.6.1/docs/resources/dashboard) | resource |
| [grafana_data_source.events_timestream_datasource](https://registry.terraform.io/providers/grafana/grafana/2.6.1/docs/resources/data_source) | resource |
| [grafana_folder.events_grafana_folder](https://registry.terraform.io/providers/grafana/grafana/2.6.1/docs/resources/folder) | resource |
| [archive_file.events_lambda_code_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.AmazonTimestreamReadOnlyAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_session_context.session_context](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_session_context) | data source |
| [aws_partition.partition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_blog_vpc_cidr"></a> [blog\_vpc\_cidr](#input\_blog\_vpc\_cidr) | n/a | `string` | `"10.0.0.0/16"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"dev"` | no |
| <a name="input_events_lambda_function_name"></a> [events\_lambda\_function\_name](#input\_events\_lambda\_function\_name) | n/a | `string` | `"events-lambda"` | no |
| <a name="input_grafana_iam_policy_name"></a> [grafana\_iam\_policy\_name](#input\_grafana\_iam\_policy\_name) | n/a | `string` | `"grafana-policy"` | no |
| <a name="input_grafana_iam_role_name"></a> [grafana\_iam\_role\_name](#input\_grafana\_iam\_role\_name) | n/a | `string` | `"grafana-role"` | no |
| <a name="input_grafana_version"></a> [grafana\_version](#input\_grafana\_version) | n/a | `string` | `"9.4"` | no |
| <a name="input_grafana_workspace_name"></a> [grafana\_workspace\_name](#input\_grafana\_workspace\_name) | n/a | `string` | `"grafana-ws"` | no |
| <a name="input_job_env_mwaa_name"></a> [job\_env\_mwaa\_name](#input\_job\_env\_mwaa\_name) | n/a | `string` | `"mwaa-compute"` | no |
| <a name="input_max_mwaa_workers"></a> [max\_mwaa\_workers](#input\_max\_mwaa\_workers) | n/a | `number` | `5` | no |
| <a name="input_mwaa_env_class"></a> [mwaa\_env\_class](#input\_mwaa\_env\_class) | n/a | `string` | `"mw1.small"` | no |
| <a name="input_mwaa_events_bucket_name"></a> [mwaa\_events\_bucket\_name](#input\_mwaa\_events\_bucket\_name) | n/a | `string` | `"mwaa-events-bucket"` | no |
| <a name="input_mwaa_events_logs_retention"></a> [mwaa\_events\_logs\_retention](#input\_mwaa\_events\_logs\_retention) | n/a | `number` | `90` | no |
| <a name="input_mwaa_iam_policy_name"></a> [mwaa\_iam\_policy\_name](#input\_mwaa\_iam\_policy\_name) | n/a | `string` | `"mwaa-policy"` | no |
| <a name="input_mwaa_iam_role_name"></a> [mwaa\_iam\_role\_name](#input\_mwaa\_iam\_role\_name) | n/a | `string` | `"mwaa-role"` | no |
| <a name="input_mwaa_metrics_bucket_name"></a> [mwaa\_metrics\_bucket\_name](#input\_mwaa\_metrics\_bucket\_name) | n/a | `string` | `"mwaa-logs-bucket"` | no |
| <a name="input_mwaa_metrics_logs_retention"></a> [mwaa\_metrics\_logs\_retention](#input\_mwaa\_metrics\_logs\_retention) | n/a | `number` | `90` | no |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | n/a | `list(string)` | <pre>[<br>  "10.0.3.0/24",<br>  "10.0.4.0/24"<br>]</pre> | no |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | n/a | `list(string)` | <pre>[<br>  "10.0.1.0/24",<br>  "10.0.2.0/24"<br>]</pre> | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | n/a | `number` | `"-1"` | no |
| <a name="input_timestream_db_name"></a> [timestream\_db\_name](#input\_timestream\_db\_name) | n/a | `string` | `"mwaa-metrics"` | no |
| <a name="input_timestream_table_name"></a> [timestream\_table\_name](#input\_timestream\_table\_name) | n/a | `string` | `"dags-stats"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
