#!/bin/python
from datetime import timedelta
from airflow import DAG
from airflow.models import Variable
from airflow.utils.dates import days_ago

from airflow.operators.dummy_operator import DummyOperator
from airflow.contrib.operators.ecs_operator import ECSOperator

awsCluster = Variable.get("AWSCluster")
awsRegionName = Variable.get("AWSRegionName")
awsNetworkSubnet = Variable.get("AWSNetworkSubnet")
awsContainerName = Variable.get("AWSContainerName")
awsTaskDefinition = Variable.get("AWSTaskDefinition")

default_args = {
    "owner": "mpenhall",
    "depends_on_past": False,
    "start_date": days_ago(1),
    "email": ["mike@hematite.tech"],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5)
}

ecs_template = {
    "aws_conn_id": "aws_credentials",
    "cluster": awsCluster,
    "region_name": awsRegionName,
    "launch_type": "FARGATE",
    "task_definition": awsTaskDefinition,
    "network_configuration": {
        "awsvpcConfiguration": {
            "assignPublicIp": "ENABLED",
            "subnets": [awsNetworkSubnet]
        }
    },
    "awslogs_group": f"/ecs/{awsTaskDefinition}",
    "awslogs_stream_prefix": f"ecs/{awsContainerName}",
    "overrides": {
        "containerOverrides" : [
            {
                "name": awsContainerName,
                "memoryReservation": 500
            }
        ]
    }
}
with DAG(
    'param_dag',
    default_args=default_args,
    description="a simple paramatized dag example",
    schedule_interval=timedelta(weeks=1),
) as dag:

    record = ECSOperator(
        task_id = "record_show",
        retry_delay = timedelta(seconds = 10),
        retries = 2,
        **ecs_template
    )

    store = DummyOperator(
        task_id = "store"
    )

    transcode = DummyOperator(
        task_id="transcode"
    )

    serve = DummyOperator(
        task_id = "serve"
    )

    tag = DummyOperator(
        task_id = "tag_metadata"
    )

    record >> store >> transcode >> serve

    store.set_downstream(tag)
    tag.set_downstream(serve)