import json
from typing import Any

from ollama import ChatResponse, ResponseError, chat

from mysql.connector import Error

from database import get_connection

MODEL_NAME = "qwen3:4b"

MENU_ITEMS = [
    {"id": 1, "name": "滷肉飯", "price": 55},
    {"id": 2, "name": "雞肉飯", "price": 70},
    {"id": 3, "name": "水餃", "price": 80},
    {"id": 4, "name": "牛肉麵", "price": 120},
    {"id": 5, "name": "雞排飯", "price": 130},
]


def get_menu_items(max_price: float) -> str:
    """查詢價格不超過指定預算的真實菜單。

    Args:
        max_price: 使用者能接受的最高價格。

    Returns:
        符合預算的菜單 JSON 字串。
    """

    if max_price < 0:
        return json.dumps(
            {"error": "預算不能小於 0"},
            ensure_ascii=False,
        )

    connection = None
    cursor = None

    try:
        connection = get_connection()

        cursor = connection.cursor(dictionary=True)

        sql = """
            SELECT id, name, description, price
            FROM menu_items
            WHERE price <= %s
            ORDER BY price ASC, id ASC
        """

        cursor.execute(sql, (max_price,))
        rows = cursor.fetchall()

        # MySQL DECIMAL 無法直接轉成 JSON，先轉為 float
        menu_items = [
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
        print(
            f"[資料庫結果] 找到 {len(menu_items)} 個餐點"
        )

        return json.dumps(
            menu_items,
            ensure_ascii=False,
        )

    except Error as error:
        print(f"[資料庫錯誤] {error}")

        return json.dumps(
            {
                "error": "無法查詢菜單資料",
                "detail": str(error),
            },
            ensure_ascii=False,
        )

    finally:
        if cursor is not None:
            cursor.close()

        if connection is not None and connection.is_connected():
            connection.close()


AVAILABLE_FUNCTIONS = {
    "get_menu_items": get_menu_items,
}


def execute_tool(
    tool_name: str,
    arguments: dict[str, Any],
) -> str:
    """執行模型要求呼叫的工具。"""
    function = AVAILABLE_FUNCTIONS.get(tool_name)

    if function is None:
        return json.dumps(
            {"error": f"未知工具：{tool_name}"},
            ensure_ascii=False,
        )

    try:
        result = function(**arguments)
        return str(result)

    except TypeError as error:
        return json.dumps(
            {
                "error": "工具參數格式錯誤",
                "detail": str(error),
            },
            ensure_ascii=False,
        )

    except Exception as error:
        return json.dumps(
            {
                "error": "工具執行失敗",
                "detail": str(error),
            },
            ensure_ascii=False,
        )


def run_agent(user_input: str) -> str:
    """執行 Agent，直到模型不再要求呼叫工具。"""
    messages: list[Any] = [
        {
            "role": "system",
            "content": (
                "你是一位餐廳菜單助理。"
                "請一律使用繁體中文回答。"
                "當使用者詢問菜單、餐點、價格或預算推薦時，"
                "必須呼叫 get_menu_items 工具。"
                "只能根據工具結果回答，禁止自行編造餐點或價格。"
                "若查不到符合條件的餐點，請直接告知使用者。"
            ),
        },
        {
            "role": "user",
            "content": user_input,
        },
    ]

    # 最多執行 5 輪，避免模型異常時無限循環
    for _ in range(5):
        response: ChatResponse = chat(
            model=MODEL_NAME,
            messages=messages,
            tools=[get_menu_items],
            think=False,
        )

        messages.append(response.message)

        tool_calls = response.message.tool_calls

        if not tool_calls:
            return (
                response.message.content
                or "模型沒有產生回答。"
            )

        for tool_call in tool_calls:
            tool_name = tool_call.function.name
            arguments = tool_call.function.arguments

            print(
                f"\n[Agent 決定呼叫工具] {tool_name}"
            )
            print(
                f"[工具參數] {arguments}"
            )

            tool_result = execute_tool(
                tool_name,
                arguments,
            )

            messages.append(
                {
                    "role": "tool",
                    "tool_name": tool_name,
                    "content": tool_result,
                }
            )

    return "Agent 執行輪數過多，已停止執行。"


def main() -> None:
    print("=" * 50)
    print("Restaurant AI Agent")
    print(f"Model: {MODEL_NAME}")
    print("輸入 exit 可結束程式")
    print("=" * 50)

    while True:
        user_input = input("\n你：").strip()

        if user_input.lower() in {
            "exit",
            "quit",
            "離開",
        }:
            print("程式結束。")
            break

        if not user_input:
            print("請輸入問題。")
            continue

        try:
            answer = run_agent(user_input)
            print(f"\nAgent：{answer}")

        except ResponseError as error:
            print("\nOllama 執行失敗：")
            print(error.error)

            if error.status_code == 404:
                print(
                    f"請先執行：ollama pull {MODEL_NAME}"
                )

        except ConnectionError:
            print(
                "\n無法連接 Ollama，"
                "請確認 Ollama 是否正在執行。"
            )

        except Exception as error:
            print(f"\n程式發生錯誤：{error}")


if __name__ == "__main__":
    main()