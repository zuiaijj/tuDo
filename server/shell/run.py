#!/usr/bin/env python3
"""
TuDo 服务器启动脚本
可以在任何目录下执行：python shell/run.py
"""
import sys
import os

# 获取脚本所在目录和server目录的绝对路径
script_dir = os.path.dirname(os.path.abspath(__file__))
server_dir = os.path.dirname(script_dir)  # 上一级目录（server目录）

# 将server目录添加到 Python 路径
sys.path.insert(0, server_dir)

# 切换工作目录到server目录，确保相对路径正确
os.chdir(server_dir)

from app.main import app
from app.config.settings import settings

if __name__ == "__main__":
    print(f"🚀 启动 TuDo 服务器...")
    print(f"📍 地址: http://{settings.HOST}:{settings.PORT}")
    print(f"🔧 调试模式: {settings.DEBUG}")
    print(f"🔥 自动重载: {settings.AUTO_RELOAD}")
    
    app.run(
        host=settings.HOST,
        port=settings.PORT,
        debug=settings.DEBUG,
        auto_reload=settings.AUTO_RELOAD,
        reload_dir=settings.RELOAD_DIRS
    ) 