from airflow import DAG
from datetime import datetime
from airflow.utils.dates import days_ago
from airflow.operators.bash import BashOperator

with DAG(
    dag_id='run-example-dag',
    description='A simple DAG example',
    schedule_interval="*/7 * * * *",
    start_date=days_ago(20),
    catchup=False
) as dag:

    t1 = BashOperator(
        task_id='print_date',
        bash_command='date',
    )

    t2 = BashOperator(
        task_id='sleep',
        depends_on_past=False,
        bash_command='sleep 2'
    )

    t1 >> t2
