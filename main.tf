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
  name     = "STAGING"
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