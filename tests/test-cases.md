# Test Cases

| Test | Input | Expected Tool | Expected Result |
|---|---|---|---|
| Menu query | 8 元內有什麼餐點？ | get_menu_items | Return items priced at or below 8 |
| Order lookup | 查詢訂單 ID 1 | get_order_status | Return order status and details |
| Missing order | 查詢訂單 ID 99999 | get_order_status | Explain that the order was not found |
| Daily summary | 整理 2024-06-12 的營業摘要 | get_daily_sales_summary | Return order count, sales and top item |
| Missing date | 幫我整理每日營業摘要 | None | Ask the user to provide a date |