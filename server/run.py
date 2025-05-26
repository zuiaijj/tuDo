#!/usr/bin/env python3
"""
TuDo 服务器启动脚本
"""
import sys
import os

# 将当前目录添加到 Python 路径
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.main import app
from app.config.settings import settings

if __name__ == "__main__":
    print(f"🚀 启动 TuDo 服务器...")
    print(f"📍 地址: http://{settings.HOST}:{settings.PORT}")
    print(f"🔧 调试模式: {settings.DEBUG}")
    
    app.run(
        host=settings.HOST,
        port=settings.PORT,
        debug=settings.DEBUG
    ) 