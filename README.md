# snowflake-dbt

debug dbt:
 astro dev bash --scheduler
 cd /usr/local/airflow/dbt
 source /usr/local/airflow/dbt_venv/bin/activate
 dbt debug
 dbt deps
 dbt run --full-refresh


 SNOWFLAKE_ACCOUNT = sw57738.ap-south-1.aws
 SNOWFLAKE_DATABASE = SIGMOID_DB
 SNOWFLAKE_PASSWORD =
 SNOWFLAKE_ROLE = DEMO_ROLE
 SNOWFLAKE_SCHEMA = RAW
 SNOWFLAKE_USER = DEMO_USER
 SNOWFLAKE_WAREHOUSE = DEMO_WH


 snowflake_default connection
 {
  "account": "sw57738",
  "warehouse": "DEMO_WH",
  "database": "SIGMOID_DB",
  "region": "ap-south-1.aws",
  "role": "DEMO_ROLE",
  "insecure_mode": false
}