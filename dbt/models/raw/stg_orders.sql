{{ config(materialized='table') }}
    
SELECT
    ID,
    CUSTOMER_ID,
    MENU_ITEM_ID,
    QUANTITY,
    TOTAL_AMOUNT,
    ORDER_DATE,
    CREATED_AT
FROM {{ source('RAW', 'ORDERS') }}