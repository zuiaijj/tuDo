#!/usr/bin/env python3
"""
数据库初始化脚本
可以在任何目录下执行：python shell/init_db.py
"""

import asyncio
import sys
import os

# 获取脚本所在目录和server目录的绝对路径
script_dir = os.path.dirname(os.path.abspath(__file__))
server_dir = os.path.dirname(script_dir)  # 上一级目录（server目录）

# 将server目录添加到 Python 路径
sys.path.insert(0, server_dir)

# 切换工作目录到server目录，确保相对路径正确
os.chdir(server_dir)

from tortoise import Tortoise


async def init_database():
    """初始化数据库"""
    
    # 初始化数据库连接
    db_path = os.path.join(server_dir, "db.sqlite3")
    await Tortoise.init(
        db_url=f"sqlite://{db_path}",
        modules={"models": ["app.models.user.user"]}
    )
    
    # 生成数据库表
    await Tortoise.generate_schemas()
    
    print("数据库表创建成功！")
    
    # 关闭数据库连接
    await Tortoise.close_connections()
    print("数据库连接已关闭")


if __name__ == "__main__":
    try:
    asyncio.run(init_database()) 
        print("数据库初始化完成，程序退出")
    except Exception as e:
        print(f"数据库初始化失败: {e}")
        sys.exit(1) 