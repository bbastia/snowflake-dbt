{{ config(materialized='table') }}

SELECT DISTINCT
    ID AS MENU_ITEM_ID,
    NAME AS MENU_ITEM_NAME,
    CATEGORY,
    PRICE,
    CREATED_AT
FROM {{ ref('stg_menu_items') }}