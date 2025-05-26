# TuDo 快速参考手册

## 🚀 一键启动

```bash
# 进入项目目录并启动服务器
cd /Users/ikvs2212304p/Code/opensource/tuDo/server
source venv/bin/activate
python run.py
```

## 🛑 一键关闭

```bash
# 查找并关闭服务器
lsof -i :8000 | grep Python | awk '{print $2}' | head -1 | xargs kill -TERM
```

## 📋 常用命令速查

### 环境管理
```bash
# 激活虚拟环境
source venv/bin/activate

# 安装依赖
pip install -r requirements.txt

# 查看已安装包
pip list
```

### 服务器操作
```bash
# 前台启动
python run.py

# 后台启动
nohup python run.py > server.log 2>&1 &

# 查看进程
lsof -i :8000

# 优雅关闭
kill -TERM <PID>

# 强制关闭
pkill -f "python run.py"
```

### 日志查看
```bash
# 查看完整日志
cat server.log

# 实时查看日志
tail -f server.log

# 查看最后 20 行
tail -20 server.log
```

### API 测试
```bash
# 基础测试
curl http://127.0.0.1:8000/

# 健康检查
curl http://127.0.0.1:8000/health

# 格式化输出
curl -s http://127.0.0.1:8000/ | python -m json.tool

# 中文显示
curl -s http://127.0.0.1:8000/ | python -c "import sys, json; print(json.dumps(json.load(sys.stdin), ensure_ascii=False, indent=2))"

# 响应时间测试
curl -w "响应时间: %{time_total}秒\n" -o /dev/null -s http://127.0.0.1:8000/
```

## 🔧 故障排除速查

### 服务器启动失败
```bash
# 检查虚拟环境
source venv/bin/activate

# 检查端口占用
lsof -i :8000

# 查看错误日志
python run.py
```

### 无法连接服务器
```bash
# 检查服务器状态
lsof -i :8000

# 查看日志
cat server.log

# 重启服务器
pkill -f "python run.py" && python run.py
```

## 📁 项目文件快速定位

```bash
# 主要配置文件
.env                    # 环境变量
app/config/settings.py  # 应用设置
app/main.py            # 主应用

# 启动和日志
run.py                 # 启动脚本
server.log            # 服务器日志

# 帮助文档
help/server-management.md  # 服务器管理
help/development-guide.md  # 开发指南
help/quick-reference.md    # 快速参考
```

## 🌐 浏览器访问

- **根路径**: http://127.0.0.1:8000/
- **健康检查**: http://127.0.0.1:8000/health

## 📞 获取帮助

```bash
# 查看详细文档
cat help/server-management.md
cat help/development-guide.md

# 检查 Sanic 版本
python -c "import sanic; print(sanic.__version__)"

# 查看环境变量
env | grep -E "(DATABASE_URL|JWT_SECRET_KEY|DEBUG|HOST|PORT)"
```

---

**提示**: 将此文件保存为书签，方便快速查阅常用命令！ 