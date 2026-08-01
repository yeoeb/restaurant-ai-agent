import json
from typing import Any

from ollama import ChatResponse, ResponseError, chat

from restaurant_tools import (
    get_daily_sales_summary,
    get_menu_items,
    get_order_status,
)


MODEL_NAME = "qwen3:1.7b"

from restaurant_tools import (
    get_daily_sales_summary,
    get_menu_items,
    get_order_status,
)

AVAILABLE_FUNCTIONS = {
    "get_menu_items": get_menu_items,
    "get_order_status": get_order_status,
    "get_daily_sales_summary": get_daily_sales_summary,
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
                "你是餐廳營運 AI 助理。"
                "請一律使用繁體中文回答。"

                "使用者詢問菜單、餐點、價格或預算時，"
                "必須呼叫 get_menu_items。"

                "使用者詢問某筆訂單時，"
                "必須呼叫 get_order_status。"

                "使用者詢問某一天的訂單數、營業額、"
                "待處理訂單或熱銷餐點時，"
                "必須呼叫 get_daily_sales_summary。"

                "只能根據工具結果回答，禁止編造資料。"
                "缺少訂單 ID 或日期時，請要求使用者補充。"
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
            tools=[
                get_menu_items,
                get_order_status,
                get_daily_sales_summary,
            ],
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