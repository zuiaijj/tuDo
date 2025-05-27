from datetime import datetime
from tortoise.models import Model
from tortoise import fields
from typing import Optional
from ...utils.crypto_utils import CryptoUtils, PhoneCrypto


class User(Model):
    """
    用户模型 - 支持手机号验证码登录
    
    字段说明：
    - uid: 用户ID
    - nick_name: 用户昵称
    - access_token: 用户访问令牌
    - phone_hash: 手机号RSA加密哈希（用于查找和验证）
    - phone_last_four: 手机号后四位（用于显示）
    - is_active: 是否激活，默认为 True
    - created_at: 创建时间，自动设置
    - updated_at: 更新时间，自动更新
    
    加密说明：
    - 使用RSA-2048-OAEP加密手机号
    - 公钥用于加密，私钥用于解密
    - 使用SHA-256哈希算法
    - 测试验证码: 1234
    """
    
    uid = fields.IntField(pk=True, description="用户ID")
    nick_name = fields.CharField(max_length=50, description="用户昵称")
    access_token = fields.CharField(max_length=255, description="用户访问令牌")
    phone_hash = fields.CharField(max_length=255, unique=True, description="手机号哈希（用于查找）")
    phone_last_four = fields.CharField(max_length=4, description="手机号后四位（用于显示）")
    is_active = fields.BooleanField(default=True, description="是否激活")
    created_at = fields.DatetimeField(auto_now_add=True, description="创建时间")
    updated_at = fields.DatetimeField(auto_now=True, description="更新时间")
    
    # 关联任务（反向关系）
    # tasks = fields.ReverseRelation["Task"]  # 暂时注释，等Task模型创建后再启用
    
    class Meta:
        table = "users"
        table_description = "用户表"
        ordering = ["-created_at"]
    
    @classmethod
    def encrypt_phone(cls, phone: str) -> str:
        """
        加密手机号（使用RSA非对称加密）
        
        Args:
            phone: 明文手机号
            
        Returns:
            str: 加密后的手机号
        """
        return PhoneCrypto.encrypt(phone)
    
    @classmethod
    def decrypt_phone(cls, encrypted_phone: str) -> str:
        """
        解密手机号（使用RSA私钥解密）
        
        Args:
            encrypted_phone: 加密后的手机号
            
        Returns:
            str: 明文手机号
        """
        return PhoneCrypto.decrypt(encrypted_phone)
    
    @property
    def phone_display(self) -> str:
        """
        获取手机号显示格式（显示后四位）
        
        Returns:
            str: 手机号显示格式
        """
        return PhoneCrypto.get_display_phone(self.phone_last_four)
    
    
    @classmethod
    async def create_user(cls, phone: str) -> "User":
        """
        创建新用户
        
        Args:
            nick_name: 用户昵称
            phone: 手机号
            access_token: 用户访问令牌
        Returns:
            User: 创建的用户对象
            
        Raises:
            ValueError: 如果手机号已存在
        """
        # 加密手机号
        phone_hash = cls.encrypt_phone(phone)
        
        # 检查手机号是否已存在
        if await cls.filter(phone_hash=phone_hash).exists():
            raise ValueError(f"手机号 '{phone}' 已被注册")
        
        # 获取手机号后四位
        phone_last_four = PhoneCrypto.get_last_four_digits(phone)
        
        # 创建用户
        user = await cls.create(
            phone_hash=phone_hash,
            phone_last_four=phone_last_four,
            is_active=True,
            created_at=datetime.now(),
        )
        
        return user
    
    @classmethod
    async def update_profile(cls, user_id: int, profile_key: str, profile_value: str) -> None:
        """
        更新用户信息
        """
        target_field = f"${profile_key}"
        await cls.filter(id=user_id).update(**{target_field: profile_value})

    @classmethod
    async def get_user_by_phone(cls, phone: str) -> Optional["User"]:
        """
        通过手机号获取用户
        
        Args:
            phone: 手机号
            
        Returns:
            User: 用户对象或None
        """
        phone_hash = cls.encrypt_phone(phone)
        return await cls.get_or_none(phone_hash=phone_hash, is_active=True)
    
    def to_dict(self, include_phone: bool = False) -> dict:
        """
        转换为字典格式
        
        Args:
            include_phone: 是否包含手机号显示信息
            
        Returns:
            dict: 用户信息字典
        """
        data = {
            "uid": self.uid,
            "nick_name": self.nick_name,
            "is_active": self.is_active,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }
        
        if include_phone:
            data["phone_display"] = self.phone_display
            
        return data
    
    def __str__(self) -> str:
        return f"User(uid={self.uid}, nick_name={self.nick_name})"
    
    def __repr__(self) -> str:
        return f"<User {self.nick_name}>"
