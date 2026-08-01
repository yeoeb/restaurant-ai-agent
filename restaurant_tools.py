import json
from datetime import datetime
from typing import Any

from mysql.connector import Error

from database import get_connection


def _json_error(message: str, detail: str | None = None) -> str:
    data: dict[str, Any] = {"error": message}

    if detail:
        data["detail"] = detail

    return json.dumps(data, ensure_ascii=False)


def _status_label(status: str) -> str:
    if status == "current":
        return "待處理"
    
    return "已完成／歷史訂單"


def get_menu_items(max_price: float) -> str:
    """查詢價格不超過指定預算的菜單。

    Args:
        max_price: 使用者能接受的最高價格。

    Returns:
        符合預算的菜單 JSON 字串。
    """

    if max_price < 0:
        return _json_error("預算不能小於 0")

    connection = None
    cursor = None

    try:
        connection = get_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute(
            """
            SELECT id, name, description, price
            FROM menu_items
            WHERE price <= %s
            ORDER BY price ASC, id ASC
            """,
            (max_price,),
        )

        rows = cursor.fetchall()

        items = [
            {
                "id": row["id"],
                "name": row["name"],
                "description": row["description"],
                "price": float(row["price"]),
            }
            for row in rows
        ]

        print(
            f"\n[工具執行] get_menu_items(max_price={max_price})"
        )
        print(f"[資料庫結果] 找到 {len(items)} 個餐點")

        return json.dumps(items, ensure_ascii=False)

    except Error as error:
        print(f"[資料庫錯誤] {error}")
        return _json_error("無法查詢菜單資料", str(error))

    finally:
        if cursor is not None:
            cursor.close()

        if connection is not None and connection.is_connected():
            connection.close()


def get_order_status(order_id: int) -> str:
    """依照訂單 ID 查詢訂單狀態與餐點明細。

    Args:
        order_id: orders 資料表中的訂單 ID。

    Returns:
        訂單內容 JSON 字串。
    """

    if order_id <= 0:
        return _json_error("訂單 ID 必須大於 0")

    connection = None
    cursor = None

    try:
        connection = get_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute(
            """
            SELECT
                o.id,
                o.order_number,
                o.order_date,
                o.order_time,
                o.total_price,
                o.status,
                o.user_id,
                u.name AS customer_name
            FROM orders AS o
            LEFT JOIN users AS u
                ON u.id = o.user_id
            WHERE o.id = %s
            """,
            (order_id,),
        )

        order = cursor.fetchone()

        print(
            f"\n[工具執行] get_order_status(order_id={order_id})"
        )

        if order is None:
            print("[資料庫結果] 找不到訂單")

            return json.dumps(
                {
                    "found": False,
                    "message": f"找不到訂單 ID {order_id}",
                },
                ensure_ascii=False,
            )

        cursor.execute(
            """
            SELECT
                mi.name,
                oi.quantity,
                oi.price
            FROM order_items AS oi
            JOIN menu_items AS mi
                ON mi.id = oi.menu_item_id
            WHERE oi.order_id = %s
            ORDER BY oi.id ASC
            """,
            (order_id,),
        )

        item_rows = cursor.fetchall()

        items = [
            {
                "name": item["name"],
                "quantity": int(item["quantity"]),
                "unit_price": float(item["price"]),
                "subtotal": (
                    int(item["quantity"]) * float(item["price"])
                ),
            }
            for item in item_rows
        ]

        result = {
            "found": True,
            "order_id": order["id"],
            "order_number": order["order_number"],
            "customer_name": order["customer_name"],
            "order_date": str(order["order_date"]),
            "order_time": str(order["order_time"]),
            "total_price": float(order["total_price"]),
            "status": _status_label(order["status"]),
            "raw_status": order["status"],
            "items": items,
        }

        print(
            f"[資料庫結果] 找到訂單，共 {len(items)} 個明細"
        )

        return json.dumps(result, ensure_ascii=False)

    except Error as error:
        print(f"[資料庫錯誤] {error}")
        return _json_error("無法查詢訂單", str(error))

    finally:
        if cursor is not None:
            cursor.close()

        if connection is not None and connection.is_connected():
            connection.close()


def get_daily_sales_summary(order_date: str) -> str:
    """查詢指定日期的訂單數量、營業額與熱銷餐點。

    Args:
        order_date: 日期，格式必須為 YYYY-MM-DD。

    Returns:
        當日營業摘要 JSON 字串。
    """

    try:
        datetime.strptime(order_date, "%Y-%m-%d")
    except ValueError:
        return _json_error(
            "日期格式錯誤，請使用 YYYY-MM-DD"
        )

    connection = None
    cursor = None

    try:
        connection = get_connection()
        cursor = connection.cursor(dictionary=True)

        cursor.execute(
            """
            SELECT
                COUNT(*) AS order_count,
                COALESCE(SUM(total_price), 0) AS total_sales,
                SUM(
                    CASE
                        WHEN status = 'current' THEN 1
                        ELSE 0
                    END
                ) AS current_orders,
                SUM(
                    CASE
                        WHEN status <> 'current' THEN 1
                        ELSE 0
                    END
                ) AS finished_orders
            FROM orders
            WHERE order_date = %s
            """,
            (order_date,),
        )

        summary = cursor.fetchone()

        cursor.execute(
            """
            SELECT
                mi.name,
                SUM(oi.quantity) AS total_quantity,
                SUM(oi.quantity * oi.price) AS item_sales
            FROM orders AS o
            JOIN order_items AS oi
                ON oi.order_id = o.id
            JOIN menu_items AS mi
                ON mi.id = oi.menu_item_id
            WHERE o.order_date = %s
            GROUP BY mi.id, mi.name
            ORDER BY
                total_quantity DESC,
                item_sales DESC
            LIMIT 1
            """,
            (order_date,),
        )

        top_item = cursor.fetchone()

        result = {
            "date": order_date,
            "order_count": int(summary["order_count"] or 0),
            "total_sales": float(summary["total_sales"] or 0),
            "current_orders": int(
                summary["current_orders"] or 0
            ),
            "finished_orders": int(
                summary["finished_orders"] or 0
            ),
            "top_selling_item": None,
        }

        if top_item is not None:
            result["top_selling_item"] = {
                "name": top_item["name"],
                "quantity": int(top_item["total_quantity"]),
                "sales": float(top_item["item_sales"]),
            }

        print(
            "\n[工具執行] "
            f"get_daily_sales_summary(order_date={order_date})"
        )
        print(
            f"[資料庫結果] 共 {result['order_count']} 筆訂單"
        )

        return json.dumps(result, ensure_ascii=False)

    except Error as error:
        print(f"[資料庫錯誤] {error}")
        return _json_error("無法產生營業摘要", str(error))

    finally:
        if cursor is not None:
            cursor.close()

        if connection is not None and connection.is_connected():
            connection.close()