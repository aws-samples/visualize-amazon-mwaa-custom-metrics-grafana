# Ingestion and Visualization of MWAA Custom Metrics on Grafana using Terraform

## Objective

The objective of this project is to demonstrate the ingestion and visualization of custom metrics from Amazon Managed Workflows for Apache Airflow (MWAA) using Amazon Managed Grafana. The solution leverages AWS services such as Amazon S3, AWS Lambda, Amazon Timestream, and Amazon Managed Grafana to create a comprehensive monitoring and analytics platform for MWAA workflows.

## Project Description

This project showcases the integration between MWAA and Amazon Managed Grafana, enabling the collection, storage, and visualization of custom metrics generated by MWAA Directed Acyclic Graphs (DAGs). The key capabilities demonstrated include:

1. Collecting and storing custom metrics generated by MWAA DAGs in Amazon Timestream.
2. Visualizing the custom metrics, such as the total number of DAGs running within the last hour, the count of passed and failed DAGs each hour, and the average duration of these processes, using Amazon Managed Grafana.
3. Providing deeper insights into the performance and execution of MWAA workflows, allowing users to optimize and monitor their data processing pipelines.

## Set-up steps

### Prerequisites

1. **AWS Account**: Access to an active AWS account with the necessary permissions to create and manage the required AWS services.
2. **AWS CLI and Terraform**: Your environment should have the latest version of the AWS CLI and Terraform installed.
3. **AWS Identity Center**: Set up an identity source in AWS Identity Center for user authentication to the Amazon Managed Grafana workspace.

### Deployment

1. Clone the GitHub repository containing the Terraform configuration files:
   ```
   git clone https://github.com/aws-samples/visualize-amazon-mwaa-custom-metrics-grafana.git
   ```
2. Navigate to the `stacks/infra` directory:
   ```
   cd visualize-amazon-mwaa-custom-metrics-grafana/stacks/infra
   ```
3. Initialize Terraform:
   ```
   terraform init
   ```
4. Review the Terraform plan:
   ```
   terraform plan
   ```
5. Apply the Terraform configuration to provision the resources:
   ```
   terraform apply -auto-approve
   ```

### Validation

1. Verify the MWAA DAGs are running correctly in the MWAA console.
2. Ensure the custom metric data is being written to the S3 bucket.
3. Check the Amazon Managed Grafana workspace and confirm that the Amazon Timestream data source is available and the pre-configured dashboard is displaying the custom metrics.

### Customization

The solution provides a pre-configured Grafana dashboard to visualize the MWAA custom metrics. You can further customize the dashboard by modifying the Grafana JSON model, which is available in the GitHub repository under the `stacks/infra/grafana` directory.

### Cleanup

1. Disable the MWAA DAG runs to pause the data generation.
2. Empty the S3 buckets used to store the custom metric data.
3. Run the Terraform destroy command to delete the provisioned resources:
   ```
   terraform destroy -auto-approve
   ```

## Next Steps

- Explore the integration of MWAA custom metrics with other AWS monitoring and observability services, such as AWS X-Ray and Amazon CloudWatch.
- Investigate the use of Istio or AWS App Mesh for advanced service mesh capabilities in the MWAA environment.

## Security

See the [CONTRIBUTING](https://github.com/aws-samples/visualize-amazon-mwaa-custom-metrics-grafana/blob/main/CONTRIBUTING.md) guide for more information.

## License

This library is licensed under the MIT-0 License. See the [LICENSE](https://github.com/aws-samples/visualize-amazon-mwaa-custom-metrics-grafana/blob/main/LICENSE.md) file.
