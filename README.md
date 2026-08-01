# Restaurant Operations AI Agent

## Overview

A local AI agent that answers restaurant menu, order, and sales questions using natural-language input.

## Features

- Query menu items within a budget
- Look up order status and order details
- Generate daily sales summaries
- Automatically select the appropriate tool
- Retrieve live data from MySQL
- Run locally without a paid cloud API

## Tech Stack

- Python
- Ollama
- Qwen3
- Streamlit
- MySQL
- mysql-connector-python

## Architecture

User
→ Streamlit
→ Ollama Agent
→ Python Function Tool
→ MySQL
→ Agent Response

## Available Tools

- `get_menu_items(max_price)`
- `get_order_status(order_id)`
- `get_daily_sales_summary(order_date)`

## Screenshots

### Menu Query

![Menu Query](screenshots/menu-query.png)

### Order Status

![Order Status](screenshots/order-status.png)

### Daily Sales Summary

![Daily Sales Summary](screenshots/daily-summary.png)

## Installation

### 1. Install prerequisites

- Python 3.10 or later
- Ollama
- MySQL

### 2. Clone the repository

```bash
git clone <repository-url>
cd restaurant-ai-agent
```

### 3. Create a virtual environment

```bash
python -m venv .venv
```

Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

### 4. Install dependencies

```bash
python -m pip install -r requirements.txt
```

### 5. Download the local model

```bash
ollama pull qwen3:1.7b
```

### 6. Configure the database

Copy `.env.example` to `.env` and update the values:

```env
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=cbb109110
```

Import:

```text
database/schema.sql
```

into MySQL.

### 7. Start the application

```bash
streamlit run streamlit_app.py
```

Open:

```text
http://localhost:8501
```
## Security

- Database credentials are stored in `.env`.
- `.env` is excluded through `.gitignore`.
- SQL queries use parameterized values.
- The Agent only exposes predefined read-only tools.
- The language model cannot execute arbitrary SQL.

## Testing

Manual tool-selection test cases are documented in:

```text
tests/test-cases.md
Known Limitations
-Ollama and MySQL must be running locally.
-The project does not currently include write operations.
-Test cases are currently manual rather than automated.
-Each question is processed independently and does not yet use the previous conversation as Agent context.
Import `database/schema.sql` into MySQL before starting the application.