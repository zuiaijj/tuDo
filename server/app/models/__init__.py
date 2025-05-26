# 统一模型导入
# 这样可以在子文件夹中组织模型，而不需要每个子文件夹都有__init__.py

# 用户相关模型
from .user.user import User

# 导出所有模型
__all__ = [
    "User"
]
