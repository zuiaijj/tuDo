import os
from dotenv import load_dotenv

# 加载环境变量
load_dotenv()

class Settings:
    # 数据库配置
    DATABASE_URL = os.getenv("DATABASE_URL", "sqlite://db.sqlite3")
    
    # JWT 配置
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", "your-secret-key")
    JWT_ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")
    JWT_EXPIRE_HOURS = int(os.getenv("JWT_EXPIRE_HOURS", 24))
    
    # 应用配置
    DEBUG = os.getenv("DEBUG", "True").lower() == "true"
    HOST = os.getenv("HOST", "127.0.0.1")
    PORT = int(os.getenv("PORT", 8000))
    
    # Redis 配置
    REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379")

settings = Settings()
