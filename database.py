import os

import mysql.connector
from dotenv import load_dotenv
from mysql.connector import MySQLConnection


load_dotenv()


def get_connection() -> MySQLConnection:
    """建立 MySQL 資料庫連線。"""

    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "127.0.0.1"),
        port=int(os.getenv("DB_PORT", "3306")),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASSWORD", ""),
        database=os.getenv("DB_NAME", "cbb109110"),
        charset="utf8mb4",
    )