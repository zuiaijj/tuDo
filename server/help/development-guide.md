# TuDo 项目开发指南

## 📋 目录
- [项目概述](#项目概述)
- [项目结构](#项目结构)
- [技术栈](#技术栈)
- [开发环境搭建](#开发环境搭建)
- [开发流程](#开发流程)
- [API 设计规范](#api-设计规范)
- [数据库设计](#数据库设计)
- [下一步开发计划](#下一步开发计划)

---

## 📖 项目概述

TuDo 是一款支持 Android/iOS/Mac/Windows 的跨平台任务管理应用，具备现代化UI、响应式布局、平台适配和高可用性。

### 主要功能模块
- **用户认证**：登录、注册、第三方登录
- **任务管理**：新建、编辑、删除、完成任务
- **日历视图**：任务日历、日程提醒
- **多端同步**：云端同步、数据备份
- **主题切换**：明暗模式、平台风格适配
- **设置中心**：账号、通知、偏好设置

---

## 🏗️ 项目结构

```
server/
├── venv/                    # Python 虚拟环境
├── app/                     # 主应用目录
│   ├── __init__.py
│   ├── main.py             # 主应用文件
│   ├── config/             # 配置文件
│   │   ├── __init__.py
│   │   ├── settings.py     # 应用设置
│   │   └── database.py     # 数据库配置
│   ├── models/             # 数据模型
│   │   ├── __init__.py
│   │   └── user.py         # 用户模型（待开发）
│   ├── views/              # API 视图
│   │   ├── __init__.py
│   │   └── auth.py         # 认证相关 API（待开发）
│   ├── middleware/         # 中间件
│   │   ├── __init__.py
│   │   └── auth.py         # 认证中间件（待开发）
│   ├── services/           # 业务逻辑
│   │   ├── __init__.py
│   │   └── auth_service.py # 认证服务（待开发）
│   └── utils/              # 工具函数
│       ├── __init__.py
│       └── jwt_utils.py    # JWT 工具（待开发）
├── help/                   # 帮助文档
│   ├── server-management.md
│   └── development-guide.md
├── .env                    # 环境变量配置
├── requirements.txt        # Python 依赖
├── run.py                  # 服务器启动脚本
├── server.log             # 服务器日志
├── todo.md                # 开发计划
└── README.md              # 项目说明
```

---

## 🛠️ 技术栈

### 后端框架
- **Sanic v23.12.1** - 高性能异步 Web 框架
- **Python 3.9.6** - 编程语言

### 数据库
- **SQLite** - 本地开发数据库
- **Tortoise ORM v0.20.0** - 异步 ORM 框架
- **aiosqlite** - SQLite 异步驱动

### 认证和安全
- **PyJWT v2.8.0** - JWT 令牌处理
- **passlib v1.7.4** - 密码加密
- **bcrypt** - 密码哈希算法

### 数据验证
- **Pydantic v2.5.0** - 数据验证和序列化

### 开发工具
- **pytest** - 测试框架
- **httpx** - HTTP 客户端（用于测试）
- **python-dotenv** - 环境变量管理

### 跨域支持
- **sanic-cors** - CORS 中间件

---

## 🚀 开发环境搭建

### 1. 环境要求
- Python 3.7 或更高版本
- pip 包管理器
- Git 版本控制

### 2. 项目克隆和设置
```bash
# 进入项目目录
cd /Users/ikvs2212304p/Code/opensource/tuDo/server

# 创建虚拟环境
python3 -m venv venv

# 激活虚拟环境
source venv/bin/activate

# 安装依赖
pip install -r requirements.txt
```

### 3. 环境变量配置
编辑 `.env` 文件：
```env
DATABASE_URL=sqlite://db.sqlite3
JWT_SECRET_KEY=your-super-secret-jwt-key-for-development
DEBUG=True
HOST=127.0.0.1
PORT=8000
```

### 4. 启动开发服务器
```bash
python run.py
```

---

## 🔄 开发流程

### 1. 功能开发步骤
1. **需求分析** - 明确功能需求和 API 设计
2. **数据模型** - 设计数据库表结构
3. **API 开发** - 实现 RESTful API 端点
4. **业务逻辑** - 编写服务层代码
5. **测试验证** - 编写和运行测试
6. **文档更新** - 更新 API 文档

### 2. 代码规范
- 使用 Python PEP 8 编码规范
- 函数和类添加详细的文档字符串
- 使用类型提示（Type Hints）
- 异步函数使用 `async/await` 语法

### 3. Git 工作流
```bash
# 创建功能分支
git checkout -b feature/user-authentication

# 提交代码
git add .
git commit -m "feat: 添加用户认证功能"

# 推送分支
git push origin feature/user-authentication
```

---

## 📡 API 设计规范

### 1. RESTful 设计原则
- 使用标准 HTTP 方法（GET, POST, PUT, DELETE）
- 使用复数名词作为资源名称
- 使用 HTTP 状态码表示操作结果

### 2. URL 设计规范
```
GET    /api/users          # 获取用户列表
POST   /api/users          # 创建新用户
GET    /api/users/{id}     # 获取特定用户
PUT    /api/users/{id}     # 更新用户信息
DELETE /api/users/{id}     # 删除用户
```

### 3. 响应格式规范
```json
// 成功响应
{
  "success": true,
  "data": {...},
  "message": "操作成功"
}

// 错误响应
{
  "success": false,
  "error": "错误类型",
  "message": "错误描述",
  "details": {...}
}
```

### 4. HTTP 状态码使用
- `200 OK` - 请求成功
- `201 Created` - 资源创建成功
- `400 Bad Request` - 请求参数错误
- `401 Unauthorized` - 未授权
- `403 Forbidden` - 禁止访问
- `404 Not Found` - 资源不存在
- `500 Internal Server Error` - 服务器内部错误

---

## 🗄️ 数据库设计

### 1. 用户表 (users)
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### 2. 数据关系
- 用户表为核心，后续可扩展其他业务表

---

## 🎯 下一步开发计划

### 阶段一：数据模型开发（1-2天）
- [ ] 完善用户模型 (`app/models/user.py`)
- [ ] 创建数据库迁移
- [ ] 测试模型功能

### 阶段二：用户认证系统（2-3天）
- [ ] JWT 工具类 (`app/utils/jwt_utils.py`)
- [ ] 认证中间件 (`app/middleware/auth.py`)
- [ ] 用户注册 API
- [ ] 用户登录 API
- [ ] 用户信息获取 API

### 阶段三：高级功能（1-2天）
- [ ] 错误处理中间件
- [ ] API 文档生成
- [ ] 单元测试编写

### 阶段四：部署准备（1天）
- [ ] Docker 配置
- [ ] 生产环境配置
- [ ] 性能优化
- [ ] 安全加固

---

## 📚 学习资源

### Sanic 官方文档
- [Sanic 官方文档](https://sanic.dev/)
- [Sanic 中文文档](https://sanic-org.github.io/sanic-guide/)

### Tortoise ORM 文档
- [Tortoise ORM 官方文档](https://tortoise.github.io/)

### 相关教程
- [Python 异步编程指南](https://docs.python.org/3/library/asyncio.html)
- [RESTful API 设计指南](https://restfulapi.net/)
- [JWT 认证原理](https://jwt.io/introduction)

---

## 🤝 贡献指南

### 代码提交规范
- `feat:` 新功能
- `fix:` 修复 bug
- `docs:` 文档更新
- `style:` 代码格式调整
- `refactor:` 代码重构
- `test:` 测试相关
- `chore:` 构建过程或辅助工具的变动

### 示例提交信息
```
feat: 添加用户注册功能

- 实现用户注册 API
- 添加邮箱验证
- 完善错误处理
```

---

**最后更新：** 2025-05-26  
**版本：** 1.0.0  
**维护者：** TuDo 开发团队 