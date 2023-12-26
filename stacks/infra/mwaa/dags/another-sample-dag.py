from airflow import DAG
from datetime import datetime
from airflow.utils.dates import days_ago
from airflow.operators.bash import BashOperator
from airflow.models import DagModel

with DAG(
    dag_id='other-sample-dag',
    description='Another sample DAG example',
    schedule_interval="*/10 * * * *",
    start_date=days_ago(0),
    catchup=False,
    is_paused_upon_creation=False
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
