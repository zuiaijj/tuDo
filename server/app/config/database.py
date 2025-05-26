from tortoise import Tortoise
from app.config.settings import settings

# Tortoise ORM 配置
TORTOISE_ORM = {
    "connections": {
        "default": settings.DATABASE_URL
    },
    "apps": {
        "models": {
            "models": ["app.models.user.user"],
            "default_connection": "default",
        },
    },
}

async def init_db():
    """初始化数据库连接"""
    print(f"🔗 连接数据库: {settings.DATABASE_URL}")
    await Tortoise.init(config=TORTOISE_ORM)
    await Tortoise.generate_schemas()
    print("✅ 数据库表创建成功")

async def close_db():
    """关闭数据库连接"""
    await Tortoise.close_connections()
    print("✅ 数据库连接已关闭")
