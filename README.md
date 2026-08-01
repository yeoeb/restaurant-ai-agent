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

1. Install Python, Ollama and MySQL.
2. Download the model:
    ```bash
    ollama pull qwen3:1.7b
3. Create and activate the virtual environment.
4. Install dependencies:
    pip install -r requirements.txt
5. Copy .env.example to .env.
6. Configure the MySQL connection.
7. Start the application
    streamlit run streamlit_app.py
Security
    Database credentials are excluded through .gitignore.
    SQL queries use parameterized values.
    The current Agent only performs read operations.
    The model cannot execute arbitrary SQL.
Known Limitations
    Requires Ollama and MySQL to run locally.
    Does not currently support order modification.
    Responses depend on the selected local model.
    Automated tests have not yet been implemented.
Import `database/schema.sql` into MySQL before starting the application.