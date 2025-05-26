from tortoise.models import Model
from tortoise import fields
from passlib.context import CryptContext
from typing import Optional

# 密码加密上下文
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class User(Model):
    """
    用户模型
    
    字段说明：
    - id: 主键，自动递增
    - username: 用户名，唯一
    - email: 邮箱地址，唯一
    - password_hash: 加密后的密码
    - is_active: 是否激活，默认为 True
    - created_at: 创建时间，自动设置
    - updated_at: 更新时间，自动更新
    """
    
    id = fields.IntField(pk=True, description="用户ID")
    username = fields.CharField(max_length=50, unique=True, description="用户名")
    email = fields.CharField(max_length=100, unique=True, description="邮箱地址")
    password_hash = fields.CharField(max_length=255, description="加密密码")
    is_active = fields.BooleanField(default=True, description="是否激活")
    created_at = fields.DatetimeField(auto_now_add=True, description="创建时间")
    updated_at = fields.DatetimeField(auto_now=True, description="更新时间")
    
    # 关联任务（反向关系）
    tasks = fields.ReverseRelation["Task"]
    
    class Meta:
        table = "users"
        table_description = "用户表"
        ordering = ["-created_at"]
    
    def verify_password(self, password: str) -> bool:
        """
        验证密码
        
        Args:
            password: 明文密码
            
        Returns:
            bool: 密码是否正确
        """
        return pwd_context.verify(password, self.password_hash)
    
    @classmethod
    def hash_password(cls, password: str) -> str:
        """
        加密密码
        
        Args:
            password: 明文密码
            
        Returns:
            str: 加密后的密码
        """
        return pwd_context.hash(password)
    
    @classmethod
    async def create_user(cls, username: str, email: str, password: str) -> "User":
        """
        创建新用户
        
        Args:
            username: 用户名
            email: 邮箱
            password: 明文密码
            
        Returns:
            User: 创建的用户对象
            
        Raises:
            ValueError: 如果用户名或邮箱已存在
        """
        # 检查用户名是否已存在
        if await cls.filter(username=username).exists():
            raise ValueError(f"用户名 '{username}' 已存在")
        
        # 检查邮箱是否已存在
        if await cls.filter(email=email).exists():
            raise ValueError(f"邮箱 '{email}' 已被注册")
        
        # 创建用户
        password_hash = cls.hash_password(password)
        user = await cls.create(
            username=username,
            email=email,
            password_hash=password_hash
        )
        
        return user
    
    @classmethod
    async def authenticate(cls, username: str, password: str) -> Optional["User"]:
        """
        用户认证
        
        Args:
            username: 用户名或邮箱
            password: 明文密码
            
        Returns:
            User: 认证成功返回用户对象，失败返回 None
        """
        # 尝试通过用户名查找
        user = await cls.get_or_none(username=username, is_active=True)
        
        # 如果用户名没找到，尝试通过邮箱查找
        if not user:
            user = await cls.get_or_none(email=username, is_active=True)
        
        # 验证密码
        if user and user.verify_password(password):
            return user
        
        return None
    
    def to_dict(self, exclude_password: bool = True) -> dict:
        """
        转换为字典格式
        
        Args:
            exclude_password: 是否排除密码字段
            
        Returns:
            dict: 用户信息字典
        """
        data = {
            "id": self.id,
            "username": self.username,
            "email": self.email,
            "is_active": self.is_active,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }
        
        if not exclude_password:
            data["password_hash"] = self.password_hash
            
        return data
    
    def __str__(self) -> str:
        return f"User(id={self.id}, username={self.username})"
    
    def __repr__(self) -> str:
        return f"<User {self.username}>"
