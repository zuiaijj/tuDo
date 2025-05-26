from sanic import Sanic, Request
from sanic.response import json
from sanic_cors import CORS
from app.config.database import init_db, close_db
from app.config.settings import settings
from app.views.auth import auth_bp

# 创建 Sanic 应用
app = Sanic("TuDoServer")

# 启用 CORS
CORS(app)

# 注册蓝图
app.blueprint(auth_bp)

# 数据库事件
@app.before_server_start
async def setup_db(app, loop):
    """服务启动前初始化数据库"""
    await init_db()

@app.after_server_stop
async def close_db_connection(app, loop):
    """服务停止后关闭数据库连接"""
    await close_db()

# 健康检查端点
@app.get("/health")
async def health_check(request: Request):
    return json({"status": "ok", "message": "TuDo Server is running!"})

# 根路径
@app.get("/")
async def index(request: Request):
    return json({
        "message": "欢迎使用 TuDo API",
        "version": "1.0.0",
        "status": "开发中..."
    })

if __name__ == "__main__":
    print(f"🚀 启动 TuDo 服务器...")
    print(f"📍 地址: http://{settings.HOST}:{settings.PORT}")
    print(f"🔧 调试模式: {settings.DEBUG}")
    
    app.run(
        host=settings.HOST,
        port=settings.PORT,
        debug=settings.DEBUG
    )
