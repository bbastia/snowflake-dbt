SELECT
    o.ID AS ORDER_ID,
    o.ORDER_DATE,
    o.CUSTOMER_ID,
    c.CUSTOMER_NAME,
    o.MENU_ITEM_ID,
    m.MENU_ITEM_NAME,
    m.CATEGORY,
    o.QUANTITY,
    o.TOTAL_AMOUNT
FROM {{ ref('stg_orders') }} o
JOIN {{ ref('dim_customers') }} c ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN {{ ref('dim_menu_items') }} m ON o.MENU_ITEM_ID = m.MENU_ITEM_ID;