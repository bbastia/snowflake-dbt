from airflow import DAG
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import SnowflakeUserPasswordProfileMapping
from datetime import datetime
from pathlib import Path
import os

# Snowflake connection ID
SNOWFLAKE_CONN_ID = "snowflake_default"

# Path to your dbt project (inside the Docker container)
DBT_PROJECT_PATH = Path("/usr/local/airflow/dbt")

# Default arguments for the DAG
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
}

# Profile configuration for Cosmos
profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=SnowflakeUserPasswordProfileMapping(
        conn_id=SNOWFLAKE_CONN_ID,
        profile_args={
            "database": "SIGMOID_DB",
        },
    ),
)

# Define the DAG
with DAG(
    dag_id="snowflake_copy_and_dbt_workflow",
    default_args=default_args,
    description="Copy data into Snowflake and run dbt transformations",
    schedule_interval="@daily",
    start_date=datetime(2023, 9, 10),
    catchup=False,
) as dag:
    # Step 1: COPY INTO RAW.CUSTOMERS
    copy_customers = SnowflakeOperator(
        task_id="copy_customers",
        sql="""
        COPY INTO RAW.CUSTOMERS
        FROM @RAW_STAGE/customers.csv
        FILE_FORMAT = (FORMAT_NAME = FORMAT.CSV_FORMAT);
        """,
        snowflake_conn_id=SNOWFLAKE_CONN_ID,
    )

    # Step 2: COPY INTO RAW.MENU_ITEMS
    copy_menu_items = SnowflakeOperator(
        task_id="copy_menu_items",
        sql="""
        COPY INTO RAW.MENU_ITEMS
        FROM @RAW_STAGE/menu_items.csv
        FILE_FORMAT = (FORMAT_NAME = FORMAT.CSV_FORMAT);
        """,
        snowflake_conn_id=SNOWFLAKE_CONN_ID,
    )

    # Step 3: COPY INTO RAW.ORDERS
    copy_orders = SnowflakeOperator(
        task_id="copy_orders",
        sql="""
        COPY INTO RAW.ORDERS
        FROM @RAW_STAGE/orders.csv
        FILE_FORMAT = (FORMAT_NAME = FORMAT.CSV_FORMAT);
        """,
        snowflake_conn_id=SNOWFLAKE_CONN_ID,
    )

    # Step 4: Define the dbt Task Group using Cosmos
    dbt_task_group = DbtTaskGroup(
        group_id="dbt_transformations",
        project_config=ProjectConfig(
            DBT_PROJECT_PATH,
        ),
        profile_config=profile_config,
        execution_config=ExecutionConfig(
            dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dbt_venv/bin/dbt",
        ),
        operator_args={
            "install_deps": True,
            "full_refresh": True,
            "env": {
                "PYTHONPATH": f"{os.environ['AIRFLOW_HOME']}/dbt_venv/lib/python3.12/site-packages",
            },
            "vars": {
                "debug": "true"
            } 
        },

    )

    # Set task dependencies
    [copy_customers, copy_menu_items, copy_orders] >> dbt_task_group