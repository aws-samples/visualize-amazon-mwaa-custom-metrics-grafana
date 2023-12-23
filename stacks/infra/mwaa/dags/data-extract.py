from airflow.decorators import dag, task
from airflow import settings
import os
import boto3
from airflow.utils.dates import days_ago
from airflow.models import DagRun, TaskFail, TaskInstance
import csv, re
from airflow.operators.python_operator import PythonOperator
from io import StringIO

DAG_ID = os.path.basename(__file__).replace(".py", "")

MAX_AGE_IN_DAYS = 1
# S3_BUCKET = "${METRICS_BUCKET_NAME}"
S3_KEY = 'files/export/{0}.csv'

# You can add other objects to export from the metadatabase,
OBJECTS_TO_EXPORT = [
    [DagRun, DagRun.execution_date],
    # [TaskFail,TaskFail.dag_id],
    # [TaskInstance, TaskInstance.execution_date],
]

# @task
# def get_bucket_name(**kwargs):
#   S3_BUCKET_NAME = kwargs['conf'].get(section='custom', key='bucket_name')
#   print("S3_BUCKET_NAME : ", S3_BUCKET_NAME)
#   return S3_BUCKET_NAME

@task()
def export_db_task(**kwargs):
    # s3_bucuket_name = PythonOperator(
    #     task_id="get_buckt_nam",
    #     python_callable=get_bucket_name,
    #     provide_context = True
    # )
    s3_bucket_name = kwargs['conf'].get(section='custom', key='bucket_name')
    print("s3_bucket_name: ", s3_bucket_name)
    session = settings.Session()
    print("session: ", str(session))

    oldest_date = days_ago(MAX_AGE_IN_DAYS)
    print("oldest_date: ", oldest_date)

    s3 = boto3.client('s3')

    for x in OBJECTS_TO_EXPORT:
        query = session.query(x[0]).filter(x[1] >= days_ago(MAX_AGE_IN_DAYS))
        print("type", type(query))
        allrows = query.all()
        name = re.sub("[<>']", "", str(x[0]))
        print(name, ": ", str(allrows))

        if len(allrows) > 0:
            outfileStr = ""
            f = StringIO(outfileStr)
            w = csv.DictWriter(f, vars(allrows[0]).keys())
            w.writeheader()
            for y in allrows:
                w.writerow(vars(y))
            outkey = S3_KEY.format(name[6:])
            s3.put_object(Bucket=s3_bucket_name, Key=outkey, Body=f.getvalue())


@dag(
    dag_id=DAG_ID,
    schedule_interval='@hourly',
    start_date=days_ago(1),
)
def export_db():
    t = export_db_task()


metadb_to_s3_test = export_db()
