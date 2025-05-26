# TuDo 服务器管理指南

## 📋 目录
- [环境准备](#环境准备)
- [启动服务器](#启动服务器)
- [检查服务器状态](#检查服务器状态)
- [测试 API 端点](#测试-api-端点)
- [关闭服务器](#关闭服务器)
- [常用命令速查表](#常用命令速查表)
- [故障排除](#故障排除)

---

## 🚀 环境准备

### 1. 激活虚拟环境
```bash
# 进入项目目录
cd /Users/ikvs2212304p/Code/opensource/tuDo/server

# 激活虚拟环境
source venv/bin/activate

# 确认虚拟环境已激活（命令行前应显示 (venv)）
```

### 2. 检查依赖
```bash
# 查看已安装的包
pip list

# 如果需要重新安装依赖
pip install -r requirements.txt
```

---

## 🚀 启动服务器

### 方式一：前台启动（开发调试用）
```bash
# 激活虚拟环境后，直接执行（无需cd）
python shell/run.py
```
**特点：**
- 可以看到实时日志输出
- 按 `Ctrl+C` 可以停止服务器
- 关闭终端窗口服务器会停止

### 方式二：后台启动（推荐）
```bash
# 激活虚拟环境后，直接执行（无需cd）
nohup python shell/run.py > server.log 2>&1 &
```
**特点：**
- 服务器在后台运行
- 日志输出到 `server.log` 文件
- 关闭终端窗口服务器继续运行

### 启动成功标志
看到以下信息说明启动成功：
```
🚀 启动 TuDo 服务器...
📍 地址: http://127.0.0.1:8000
🔧 调试模式: True
[INFO] Goin' Fast @ http://127.0.0.1:8000
```

---

## 🔍 检查服务器状态

### 1. 检查进程是否运行
```bash
# 查看占用 8000 端口的进程
lsof -i :8000

# 应该看到类似输出：
# COMMAND   PID         USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
# Python  12345 username   12u  IPv4 0x...      0t0  TCP localhost:irdmi (LISTEN)
```

### 2. 检查进程详情
```bash
# 查看所有 Python 进程
ps aux | grep python | grep -v grep

# 查看特定的服务器进程
ps aux | grep "run.py"
```

### 3. 查看服务器日志
```bash
# 查看完整日志
cat server.log

# 实时查看日志（按 Ctrl+C 退出）
tail -f server.log

# 查看最后 20 行日志
tail -20 server.log
```

---

## 🧪 测试 API 端点

### 1. 基础连接测试
```bash
# 测试根路径
curl http://127.0.0.1:8000/

# 期望输出：
# {"message":"欢迎使用 TuDo API","version":"1.0.0","status":"开发中..."}
```

### 2. 健康检查
```bash
# 测试健康检查端点
curl http://127.0.0.1:8000/health

# 期望输出：
# {"status":"ok","message":"TuDo Server is running!"}
```

### 3. 详细测试（查看 HTTP 头信息）
```bash
# 详细模式测试
curl -v http://127.0.0.1:8000/

# 会显示完整的 HTTP 请求和响应信息
```

### 4. 格式化 JSON 输出
```bash
# 美化 JSON 输出
curl -s http://127.0.0.1:8000/ | python -m json.tool

# 显示中文字符
curl -s http://127.0.0.1:8000/ | python -c "import sys, json; print(json.dumps(json.load(sys.stdin), ensure_ascii=False, indent=2))"
```

### 5. 测试响应时间
```bash
# 测试 API 响应时间
curl -w "响应时间: %{time_total}秒\n" -o /dev/null -s http://127.0.0.1:8000/
```

### 6. 测试错误处理
```bash
# 测试 404 错误
curl http://127.0.0.1:8000/nonexistent

# 应该返回 404 Not Found
```

---

## 🛑 关闭服务器

### 方式一：通过进程 ID（推荐）

#### 步骤 1：查找进程 ID
```bash
lsof -i :8000
```
记下主进程的 PID（通常是第一个）

#### 步骤 2：优雅关闭
```bash
# 使用 TERM 信号优雅关闭（推荐）
kill -TERM <PID>

# 例如：kill -TERM 12345
```

#### 步骤 3：验证关闭
```bash
# 检查端口是否释放
lsof -i :8000

# 测试连接是否断开
curl http://127.0.0.1:8000/
# 应该显示：curl: (7) Failed to connect...
```

### 方式二：通过进程名称
```bash
# 通过进程名称关闭
pkill -f "run.py"
```

### 方式三：强制关闭（紧急情况）
```bash
# 强制终止（仅在服务器无响应时使用）
kill -9 <PID>

# 或者
pkill -9 -f "run.py"
```

**⚠️ 注意：**
- 优先使用 `kill -TERM`，它会给程序时间清理资源
- `kill -9` 是强制终止，可能导致数据丢失
- 强制关闭仅在程序无响应时使用

---

## 📋 常用命令速查表

| 操作 | 命令 | 说明 |
|------|------|------|
| **环境管理** |
| 激活虚拟环境 | `source venv/bin/activate` | 必须先激活才能运行服务器 |
| 检查 Python 版本 | `python --version` | 确保版本 ≥ 3.7 |
| 安装依赖 | `pip install -r requirements.txt` | 安装项目依赖包 |
| **服务器启动** |
| 前台启动 | `python shell/run.py` | 开发调试用，Ctrl+C 停止 |
| 后台启动 | `nohup python shell/run.py > server.log 2>&1 &` | 生产环境用 |
| **状态检查** |
| 查看端口占用 | `lsof -i :8000` | 检查服务器是否运行 |
| 查看进程 | `ps aux \| grep "run.py"` | 查看服务器进程 |
| 查看日志 | `tail -f server.log` | 实时查看日志 |
| **API 测试** |
| 基础测试 | `curl http://127.0.0.1:8000/` | 测试根路径 |
| 健康检查 | `curl http://127.0.0.1:8000/health` | 测试健康状态 |
| 详细测试 | `curl -v http://127.0.0.1:8000/` | 查看 HTTP 详情 |
| 格式化输出 | `curl -s http://127.0.0.1:8000/ \| python -m json.tool` | 美化 JSON |
| **服务器关闭** |
| 优雅关闭 | `kill -TERM <PID>` | 推荐方式 |
| 按名称关闭 | `pkill -f "run.py"` | 备用方式 |
| 强制关闭 | `kill -9 <PID>` | 紧急情况 |

---

## 🔧 故障排除

### 问题 1：服务器启动失败
**症状：** 运行 `python run.py` 后出现错误

**解决方案：**
1. 检查虚拟环境是否激活：`source venv/bin/activate`
2. 检查依赖是否安装：`pip install -r requirements.txt`
3. 检查端口是否被占用：`lsof -i :8000`
4. 查看详细错误信息：直接运行 `python shell/run.py`

### 问题 2：无法连接到服务器
**症状：** `curl: (7) Failed to connect to 127.0.0.1 port 8000`

**解决方案：**
1. 检查服务器是否运行：`lsof -i :8000`
2. 检查防火墙设置
3. 确认使用正确的地址和端口
4. 查看服务器日志：`cat server.log`

### 问题 3：服务器无响应
**症状：** 服务器进程存在但 API 无响应

**解决方案：**
1. 查看服务器日志：`tail -f server.log`
2. 检查系统资源：`top` 或 `htop`
3. 重启服务器：先关闭再启动
4. 如果无法正常关闭，使用强制关闭：`kill -9 <PID>`

### 问题 4：端口被占用
**症状：** 启动时提示端口已被使用

**解决方案：**
1. 查看占用端口的进程：`lsof -i :8000`
2. 关闭占用端口的进程：`kill -TERM <PID>`
3. 或者修改配置使用其他端口

### 问题 5：权限错误
**症状：** 启动时提示权限不足

**解决方案：**
1. 检查文件权限：`ls -la shell/run.py`
2. 添加执行权限：`chmod +x shell/run.py`
3. 确保对项目目录有读写权限

---

## 📞 获取帮助

### 查看更多文档
- 项目根目录的 `README.md`
- `help/` 目录下的其他文档

### 常用调试命令
```bash
# 查看 Python 模块路径
python -c "import sys; print('\n'.join(sys.path))"

# 检查 Sanic 是否正确安装
python -c "import sanic; print(sanic.__version__)"

# 查看环境变量
env | grep -E "(DATABASE_URL|JWT_SECRET_KEY|DEBUG|HOST|PORT)"
```

### 日志级别说明
- `[DEBUG]` - 调试信息，开发时有用
- `[INFO]` - 一般信息，如服务器启动
- `[WARNING]` - 警告信息，需要注意但不影响运行
- `[ERROR]` - 错误信息，需要立即处理

---

**最后更新：** 2025-05-26  
**版本：** 1.0.0  
**适用于：** TuDo 服务器 v1.0.0 