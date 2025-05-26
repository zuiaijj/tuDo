# TuDo 服务器帮助文档

欢迎使用 TuDo 服务器帮助文档！这里包含了所有你需要的操作指南和参考资料。

## 📚 文档目录

### 🚀 [快速参考手册](quick-reference.md)
**适合：** 有经验的开发者，需要快速查找命令
- 一键启动/关闭命令
- 常用命令速查表
- 故障排除速查
- 项目文件快速定位

### 🔧 [服务器管理指南](server-management.md)
**适合：** 所有用户，特别是初学者
- 详细的环境准备步骤
- 服务器启动和关闭方法
- 完整的状态检查流程
- API 测试方法
- 详细的故障排除指南

### 📖 [项目开发指南](development-guide.md)
**适合：** 开发者，了解项目架构和开发流程
- 项目概述和功能模块
- 完整的项目结构说明
- 技术栈详细介绍
- 开发环境搭建
- API 设计规范
- 数据库设计
- 下一步开发计划

## 🎯 根据你的需求选择文档

### 我是新手，第一次使用
👉 建议阅读顺序：
1. [服务器管理指南](server-management.md) - 学习基础操作
2. [快速参考手册](quick-reference.md) - 保存常用命令
3. [项目开发指南](development-guide.md) - 了解项目架构

### 我需要快速查找命令
👉 直接查看：[快速参考手册](quick-reference.md)

### 我想了解项目架构和开发
👉 重点阅读：[项目开发指南](development-guide.md)

### 我遇到了问题
👉 查看故障排除：
- [服务器管理指南 - 故障排除](server-management.md#故障排除)
- [快速参考手册 - 故障排除速查](quick-reference.md#故障排除速查)

## 🔍 快速搜索

### 常见操作
- **启动服务器**: [服务器管理指南 - 启动服务器](server-management.md#启动服务器)
- **关闭服务器**: [服务器管理指南 - 关闭服务器](server-management.md#关闭服务器)
- **测试 API**: [服务器管理指南 - 测试 API 端点](server-management.md#测试-api-端点)
- **查看日志**: [快速参考手册 - 日志查看](quick-reference.md#常用命令速查)

### 技术相关
- **项目结构**: [项目开发指南 - 项目结构](development-guide.md#项目结构)
- **技术栈**: [项目开发指南 - 技术栈](development-guide.md#技术栈)
- **API 设计**: [项目开发指南 - API 设计规范](development-guide.md#api-设计规范)
- **数据库设计**: [项目开发指南 - 数据库设计](development-guide.md#数据库设计)

## 📞 获取更多帮助

### 在线资源
- [Sanic 官方文档](https://sanic.dev/)
- [Tortoise ORM 文档](https://tortoise.github.io/)
- [Python 异步编程指南](https://docs.python.org/3/library/asyncio.html)

### 项目文件
- `../README.md` - 项目主要说明
- `../todo.md` - 开发计划和里程碑
- `../.env` - 环境变量配置

### 命令行帮助
```bash
# 查看 Python 版本
python --version

# 查看 Sanic 版本
python -c "import sanic; print(sanic.__version__)"

# 查看项目依赖
pip list
```

## 📝 文档更新

这些文档会随着项目的发展持续更新。如果你发现任何错误或有改进建议，请：

1. 检查是否是最新版本的文档
2. 查看相关的在线文档
3. 尝试重现问题并记录详细步骤

---

**最后更新**: 2025-05-26  
**文档版本**: 1.0.0  
**适用于**: TuDo 服务器 v1.0.0

**快速链接**:
- [🚀 快速参考](quick-reference.md)
- [🔧 服务器管理](server-management.md)  
- [📖 开发指南](development-guide.md) 