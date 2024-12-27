{{ config(materialized='table') }}

SELECT DISTINCT
    ID AS CUSTOMER_ID,
    NAME AS CUSTOMER_NAME,
    EMAIL,
    PHONE,
    CREATED_AT
FROM {{ ref('stg_customers') }}