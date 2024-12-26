from airflow import DAG
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator
from cosmos.providers.dbt.task_group import DbtTaskGroup
from airflow.utils.dates import days_ago

SNOWFLAKE_CONN_ID = "snowflake_default"
DBT_PROJECT_DIR = "/path/to/dbt"  # Path to your DBT project
DBT_PROFILES_DIR = "/path/to/profiles"  # Path to DBT profiles

default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email_on_failure": False,
    "email_on_retry": False,
}

with DAG(
    dag_id="snowflake_dbt_workflow",
    default_args=default_args,
    description="Run COPY INTO commands and DBT tasks",
    schedule_interval=None,
    start_date=days_ago(1),
    catchup=False,
) as dag:

    # Step 1: COPY INTO RAW.CUSTOMERS
    copy_customers = SnowflakeOperator(
        task_id="copy_customers",
        sql="""
        COPY INTO RAW.CUSTOMERS
        FROM @RAW_STAGE/customers.csv
        FILE_FORMAT = (FORMAT_NAME = FORMAT.CSV_FORMAT)
        SKIP_HEADER = 1;
        """,
        snowflake_conn_id=SNOWFLAKE_CONN_ID,
    )

    # Step 2: COPY INTO RAW.MENU_ITEMS
    copy_menu_items = SnowflakeOperator(
        task_id="copy_menu_items",
        sql="""
        COPY INTO RAW.MENU_ITEMS
        FROM @RAW_STAGE/menu_items.csv
        FILE_FORMAT = (FORMAT_NAME = FORMAT.CSV_FORMAT)
        SKIP_HEADER = 1;
        """,
        snowflake_conn_id=SNOWFLAKE_CONN_ID,
    )

    # Step 3: COPY INTO RAW.ORDERS
    copy_orders = SnowflakeOperator(
        task_id="copy_orders",
        sql="""
        COPY INTO RAW.ORDERS
        FROM @RAW_STAGE/orders.csv
        FILE_FORMAT = (FORMAT_NAME = FORMAT.CSV_FORMAT)
        SKIP_HEADER = 1;
        """,
        snowflake_conn_id=SNOWFLAKE_CONN_ID,
    )

    # Step 4: Run DBT using Cosmos Task Group
    dbt_task_group = DbtTaskGroup(
        group_id="dbt_tasks",
        dbt_project_dir=DBT_PROJECT_DIR,
        dbt_profiles_dir=DBT_PROFILES_DIR,
        dbt_args={
            "type": "postgres",
            "run": {},
            "test": {},
        },
    )

    # Define task dependencies
    [copy_customers, copy_menu_items, copy_orders] >> dbt_task_group