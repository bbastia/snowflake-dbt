{{ config(materialized='table') }}
    
SELECT
    ID,
    NAME,
    CATEGORY,
    PRICE,
    CREATED_AT
FROM {{ source('RAW', 'MENU_ITEMS') }}