terraform {
  required_providers {
    snowflake = {
      source  = "chanzuckerberg/snowflake"
      version = "0.25.17"
    }
  }

  backend "remote" {
    organization = "JIBSigmoid"

    workspaces {
      name = "JIBWorkspace"
    }
  }
}

provider "snowflake" {
}

resource "snowflake_database" "demo_db" {
  name    = "SIGMOID_DB"
  comment = "Database for Snowflake Terraform demo"
}

resource "snowflake_schema" "raw_schema" {
  database = snowflake_database.demo_db.name
  name     = "RAW"
  comment  = "Schema for raw data in SIGMOID_DB"
}

resource "snowflake_schema" "staging_schema" {
  database = snowflake_database.demo_db.name
  name     = "STAGGING"
  comment  = "Schema for staging data in SIGMOID_DB"
}

resource "snowflake_schema" "dim_schema" {
  database = snowflake_database.demo_db.name
  name     = "DIM"
  comment  = "Schema for dimension data in SIGMOID_DB"
}

resource "snowflake_schema" "fact_schema" {
  database = snowflake_database.demo_db.name
  name     = "FACT"
  comment  = "Schema for fact data in SIGMOID_DB"
}

resource "snowflake_schema" "aggr_schema" {
  database = snowflake_database.demo_db.name
  name     = "AGGR"
  comment  = "Schema for aggregated data in SIGMOID_DB"
}

resource "snowflake_schema" "file_format_schema" {
  database = snowflake_database.demo_db.name
  name     = "FORMAT"
  comment  = "Schema for file formats in SIGMOID_DB"
}

resource "snowflake_storage_integration" "s3_integration" {
  name                     = "S3_INTEGRATION"
  storage_provider         = "S3"
  storage_aws_role_arn     = "arn:aws:iam::750578200203:role/SnowflakeAccessRole"
  enabled                  = true
  storage_allowed_locations = ["s3://b-snowflake-architect-cert/LANDING/"]
}

resource "snowflake_stage" "s3_stage" {
  name               = "RAW_STAGE"
  database           = "SIGMOID_DB"
  schema             = "RAW"
  storage_integration = snowflake_storage_integration.s3_integration.name
  url                = "s3://b-snowflake-architect-cert/LANDING/"
}
