#!/usr/bin/env python3
"""
数据库重建脚本
删除现有数据库文件并重新创建表结构
可以在任何目录下执行：python shell/rebuild_db.py
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


async def rebuild_database():
    """重建数据库"""
    
    # 数据库文件路径
    db_path = os.path.join(server_dir, "db.sqlite3")
    db_wal_path = os.path.join(server_dir, "db.sqlite3-wal")
    db_shm_path = os.path.join(server_dir, "db.sqlite3-shm")
    
    print("🗑️  删除现有数据库文件...")
    
    # 删除数据库文件（如果存在）
    for file_path in [db_path, db_wal_path, db_shm_path]:
        if os.path.exists(file_path):
            try:
                os.remove(file_path)
                print(f"   已删除: {os.path.basename(file_path)}")
            except Exception as e:
                print(f"   删除失败 {os.path.basename(file_path)}: {e}")
    
    print("\n🔧 重新创建数据库...")
    
    # 初始化数据库连接
    await Tortoise.init(
        db_url=f"sqlite://{db_path}",
        modules={"models": ["app.models.user.user"]}
    )
    
    # 生成数据库表
    await Tortoise.generate_schemas()
    
    print("✅ 数据库表创建成功！")
    
    # 关闭数据库连接
    await Tortoise.close_connections()
    print("✅ 数据库连接已关闭")
    
    print("\n📋 重建完成！新的表结构包含以下字段（带默认值）：")
    print("   - uid (主键，自增)")
    print("   - nick_name (默认: '')")
    print("   - gender (默认: 0 - 未知)")
    print("   - avatar (默认: '')")
    print("   - access_token (默认: '')")
    print("   - phone (可空，唯一)")
    print("   - phone_last_four (默认: '')")
    print("   - is_active (默认: True)")
    print("   - created_at (自动设置)")
    print("   - updated_at (自动更新)")


if __name__ == "__main__":
    print("⚠️  警告：此操作将删除所有现有数据！")
    
    # 确认操作
    confirmation = input("确定要重建数据库吗？输入 'yes' 继续: ")
    if confirmation.lower() != 'yes':
        print("❌ 操作已取消")
        sys.exit(0)
    
    try:
        asyncio.run(rebuild_database())
        print("\n🎉 数据库重建完成！所有字段都有默认值，不会返回空值。")
    except Exception as e:
        print(f"\n❌ 数据库重建失败: {e}")
        sys.exit(1) 