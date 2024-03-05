'''
Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
SPDX-License-Identifier: MIT-0
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
'''

import boto3
from urllib.parse import unquote
import time
import os
import pandas as pd
from io import BytesIO


def load_dag_csv(event):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        file_key = unquote(record['s3']['object']['key'])

        print('bucket name : %s' % (bucket))
        print('file_key : %s' % (file_key))

        s3_client = boto3.client('s3')
        resp = s3_client.get_object(Bucket=bucket, Key=file_key)

        data = pd.read_csv(resp['Body'], sep=',')
        print(f"data read from S3.")
        dag_df = pd.DataFrame(data, columns=["dag_id", "start_date", "end_date", "_state"])
        return dag_df


def get_dags_hourly_stats(event, context):
    DB_NAME = os.environ["DB_NAME"]
    TABLE_NAME = os.environ["TABLE_NAME"]
    REGION = os.environ["REGION_NAME"]
    try:
        # creating boto3 client for timestream db
        client = boto3.client("timestream-write")

        # loading csv from S3 and creating pandas dataframe
        dag_df = load_dag_csv(event)

        print(f"total dags found : {dag_df.shape[0]}")
        total_running_dags = dag_df[dag_df['_state'] == "running"]
        total_paused_dags = dag_df[dag_df['_state'] == "paused"]

        # removing running and paused dags to calculate failed/passed dags in this hour.
        dag_df = dag_df.drop(dag_df[dag_df["_state"] == 'running'].index)
        dag_df = dag_df.drop(dag_df[dag_df["_state"] == 'paused'].index)
        print(f"total dags count after removing stopped/paused dags : {dag_df.shape[0]}")

        # making timstamp to get dags from last hour (between start and end)
        end_date = pd.Timestamp.now().replace(minute=0, second=0, microsecond=0)
        end_timestamp = pd.Timestamp(end_date).timestamp()
        print(f"end_timestamp : {end_date} , end_timestamp epoch : {end_timestamp}")
        start_timestamp = end_timestamp - 3600
        print(f"start_timestamp epoch : {start_timestamp}")

        date_pattern = '%Y-%m-%d %H:%M:%S.%f%z'
        dag_df['epoch_end_date'] = dag_df["end_date"].apply(
            lambda row: int(time.mktime(time.strptime(row, date_pattern))))
        dag_df['epoch_start_date'] = dag_df["start_date"].apply(
            lambda row: int(time.mktime(time.strptime(row, date_pattern))))
        print(dag_df.shape[0])

        # remove all rows oldr than 1 hr
        dag_df = dag_df.drop(dag_df[dag_df["epoch_end_date"] < start_timestamp].index)
        total_dags = dag_df.shape[0] + len(total_running_dags) + len(total_paused_dags)
        print(f"total dags in last 1 hr : {total_dags}")

        total_failed_dags = dag_df[dag_df['_state'] == "failed"]
        total_success_dags = dag_df[dag_df['_state'] == "success"]
        print(f"success dags in last 1 hr : {len(total_success_dags)}")
        print(f"total failed dags in last 1 hr : {len(total_failed_dags)}")

        dag_df['duration'] = (dag_df['epoch_end_date'] - dag_df['epoch_start_date'])
        total_success_dags['duration'] = (total_success_dags['epoch_end_date'] - total_success_dags['epoch_start_date'])
        total_failed_dags['duration'] = (total_failed_dags['epoch_end_date'] - total_failed_dags['epoch_start_date'])

        average_duration = dag_df['duration'].mean()
        average_duration_failed = total_failed_dags['duration'].mean()
        average_duration_success = total_success_dags['duration'].mean()

        if pd.isna(average_duration):
            average_duration = 0.0
        if pd.isna(average_duration_failed):
            average_duration_failed = 0.0
        if pd.isna(average_duration_success):
            average_duration_success = 0.0

        # adding in timstream db.
        current_time = str(int(time.time() * 1000))
        dimension = [{'Name': 'total_dags', 'Value': str(total_dags)},
                     {'Name': 'success_dags', 'Value': str(len(total_success_dags))},
                     {'Name': 'failed_dags', 'Value': str(len(total_failed_dags))},
                     {'Name': 'running_dags', 'Value': str(len(total_running_dags))},
                     {'Name': 'average_duration', 'Value': str(average_duration)},
                     {'Name': 'average_duration_failed', 'Value': str(average_duration_failed)},
                     {'Name': 'average_duration_success', 'Value': str(average_duration_success)}
                     ]
        record = {'Time': current_time, 'MeasureName': 'dags_count', 'MeasureValue': str(total_dags),
                  'MeasureValueType': "VARCHAR", 'Dimensions': dimension}
        print(f"record : {record}")
        client = boto3.client("timestream-write", region_name=REGION)
        response = client.write_records(DatabaseName=DB_NAME, TableName=TABLE_NAME, Records=[record])
        print(response)
    except client.exceptions.RejectedRecordsException as err:
        print("RejectedRecords: ", err)
        for rr in err.response["RejectedRecords"]:
            print("Rejected Index " + str(rr["RecordIndex"]) + ": " + rr["Reason"])
        print("Other records were written successfully. ")
    except Exception as err:
        print("Error:", err)


def lambda_handler(event, context):
    print(event)
    get_dags_hourly_stats(event, context)
