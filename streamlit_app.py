import streamlit as st

from app import run_agent


st.set_page_config(
    page_title="Restaurant AI Agent",
    page_icon="🍽️",
    layout="centered",
)

st.title("🍽️ Restaurant AI Agent")

st.caption(
    "使用 Ollama、Python 與 MySQL 建立的餐廳營運 AI 助理"
)

with st.sidebar:
    st.subheader("可詢問的內容")

    st.markdown(
        """
        - 預算內的菜單
        - 訂單狀態與明細
        - 每日訂單與營業摘要
        """
    )

    st.subheader("測試問題")

    st.code("8 元內有什麼餐點？")
    st.code("請查詢訂單 ID 1 的狀態")
    st.code("請整理 2024-06-12 的營業摘要")

    if st.button("清除對話"):
        st.session_state.messages = []
        st.rerun()


if "messages" not in st.session_state:
    st.session_state.messages = []


for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])


user_input = st.chat_input("請輸入菜單、訂單或營業相關問題")


if user_input:
    st.session_state.messages.append(
        {
            "role": "user",
            "content": user_input,
        }
    )

    with st.chat_message("user"):
        st.markdown(user_input)

    with st.chat_message("assistant"):
        with st.spinner("Agent 正在查詢資料..."):
            try:
                answer = run_agent(user_input)

            except Exception as error:
                answer = f"執行失敗：{error}"

        st.markdown(answer)

    st.session_state.messages.append(
        {
            "role": "assistant",
            "content": answer,
        }
    )