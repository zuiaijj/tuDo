#!/usr/bin/env python3
"""
TuDo 开发服务器启动脚本
支持热重载、文件监控等开发功能
可以在任何目录下执行：python shell/dev.py
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

def start_dev_server():
    """启动开发服务器"""
    print("🔥 TuDo 开发服务器 - 热重载模式")
    print("=" * 50)
    print(f"📍 地址: http://{settings.HOST}:{settings.PORT}")
    print(f"🔧 调试模式: {settings.DEBUG}")
    print(f"🔥 自动重载: 启用")
    print(f"📁 监控目录: {', '.join(settings.RELOAD_DIRS)}")
    print("=" * 50)
    print("💡 提示: 修改代码后会自动重启服务器")
    print("💡 按 Ctrl+C 停止服务器")
    print("=" * 50)
    
    try:
        app.run(
            host=settings.HOST,
            port=settings.PORT,
            debug=True,  # 开发模式强制开启调试
            auto_reload=True,  # 强制开启热重载
            reload_dir=settings.RELOAD_DIRS,
            workers=1  # 开发模式使用单进程
        )
    except KeyboardInterrupt:
        print("\n🛑 服务器已停止")
    except Exception as e:
        print(f"❌ 服务器启动失败: {e}")
        sys.exit(1)

if __name__ == "__main__":
    start_dev_server() 