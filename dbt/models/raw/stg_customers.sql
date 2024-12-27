{{ config(materialized='table') }}
    
SELECT
    ID,
    NAME,
    EMAIL,
    PHONE,
    CREATED_AT
FROM {{ source('RAW', 'CUSTOMERS') }}