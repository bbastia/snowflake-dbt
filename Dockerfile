FROM quay.io/astronomer/astro-runtime:12.6.0

# Switch to root user to install packages
USER root

# install dbt into a virtual environment
RUN python -m venv dbt_venv && source dbt_venv/bin/activate && pip install --no-cache-dir dbt-snowflake && pip install --no-cache-dir dbt-postgres && deactivate

# Copy the dbt project into the Docker image
COPY dbt /usr/local/airflow/dbt

# Install git
RUN apt-get update && apt-get install -y git

# Switch back to the default airflow user (recommended)
USER astro