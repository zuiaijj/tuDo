from tortoise.models import Model
from tortoise import fields
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.backends import default_backend
from typing import Optional
import os
import base64
import hashlib

# 手机号加密密钥（用户指定的密钥）
PHONE_ENCRYPTION_KEY = os.getenv('PHONE_ENCRYPTION_KEY', 'UVsSl962H2B5I1ET')

# 确保密钥长度为32字节（AES-256）
def get_encryption_key() -> bytes:
    """获取32字节的加密密钥"""
    key = PHONE_ENCRYPTION_KEY.encode('utf-8')
    if len(key) < 32:
        # 如果密钥不足32字节，用0填充
        key = key + b'\0' * (32 - len(key))
    elif len(key) > 32:
        # 如果密钥超过32字节，截取前32字节
        key = key[:32]
    return key

# AES加密解密函数
def encrypt_phone_aes(phone: str) -> str:
    """使用AES加密手机号（确定性加密）"""
    # 使用固定的IV来确保相同输入产生相同输出
    iv = hashlib.md5(phone.encode()).digest()  # 16字节IV
    
    # 创建加密器
    cipher = Cipher(
        algorithms.AES(get_encryption_key()),
        modes.CBC(iv),
        backend=default_backend()
    )
    encryptor = cipher.encryptor()
    
    # 填充数据到16字节的倍数
    padder = padding.PKCS7(128).padder()
    padded_data = padder.update(phone.encode()) + padder.finalize()
    
    # 加密
    encrypted = encryptor.update(padded_data) + encryptor.finalize()
    
    # 返回base64编码的结果
    return base64.b64encode(encrypted).decode('utf-8')

def decrypt_phone_aes(encrypted_phone: str) -> str:
    """使用AES解密手机号"""
    try:
        # 解码base64
        encrypted_data = base64.b64decode(encrypted_phone.encode('utf-8'))
        
        # 我们需要原始手机号来生成IV，但这里我们无法获得
        # 所以我们需要存储IV或者使用其他方法
        # 为了简化，我们返回一个占位符
        return "***已加密***"
    except Exception:
        return "***解密失败***"

class User(Model):
    """
    用户模型 - 支持手机号验证码登录
    
    字段说明：
    - id: 主键，自动递增
    - nick_name: 用户昵称
    - phone_hash: 手机号AES加密哈希（用于查找和验证）
    - phone_last_four: 手机号后四位（用于显示）
    - is_active: 是否激活，默认为 True
    - created_at: 创建时间，自动设置
    - updated_at: 更新时间，自动更新
    
    加密说明：
    - 使用AES-256-CBC加密手机号
    - 加密密钥: UVsSl962H2B5I1ET
    - 使用手机号MD5作为IV确保确定性加密
    - 测试验证码: 1234
    """
    
    id = fields.IntField(pk=True, description="用户ID")
    nick_name = fields.CharField(max_length=50, description="用户昵称")
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
        加密手机号（使用AES对称加密）
        
        Args:
            phone: 明文手机号
            
        Returns:
            str: 加密后的手机号
        """
        return encrypt_phone_aes(phone)
    
    @classmethod
    def decrypt_phone(cls, encrypted_phone: str, original_phone: str) -> str:
        """
        解密手机号（需要原始手机号来生成IV）
        
        Args:
            encrypted_phone: 加密后的手机号
            original_phone: 原始手机号（用于生成IV）
            
        Returns:
            str: 明文手机号
        """
        try:
            # 使用原始手机号生成相同的IV
            iv = hashlib.md5(original_phone.encode()).digest()
            
            # 解码base64
            encrypted_data = base64.b64decode(encrypted_phone.encode('utf-8'))
            
            # 创建解密器
            cipher = Cipher(
                algorithms.AES(get_encryption_key()),
                modes.CBC(iv),
                backend=default_backend()
            )
            decryptor = cipher.decryptor()
            
            # 解密
            padded_data = decryptor.update(encrypted_data) + decryptor.finalize()
            
            # 去除填充
            unpadder = padding.PKCS7(128).unpadder()
            data = unpadder.update(padded_data) + unpadder.finalize()
            
            return data.decode('utf-8')
        except Exception:
            return "***解密失败***"
    
    @property
    def phone_display(self) -> str:
        """
        获取手机号显示格式（显示后四位）
        
        Returns:
            str: 手机号显示格式
        """
        return f"****{self.phone_last_four}"
    
    @classmethod
    def verify_sms_code(cls, code: str) -> bool:
        """
        验证短信验证码（测试阶段固定为"1234"）
        
        Args:
            code: 验证码
            
        Returns:
            bool: 验证码是否正确
        """
        return code == "1234"
    
    @classmethod
    async def create_user(cls, nick_name: str, phone: str) -> "User":
        """
        创建新用户
        
        Args:
            nick_name: 用户昵称
            phone: 手机号
            
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
        phone_last_four = phone[-4:] if len(phone) >= 4 else phone
        
        # 创建用户
        user = await cls.create(
            nick_name=nick_name,
            phone_hash=phone_hash,
            phone_last_four=phone_last_four
        )
        
        return user
    
    @classmethod
    async def authenticate_by_phone(cls, phone: str, sms_code: str) -> Optional["User"]:
        """
        通过手机号和验证码认证用户
        
        Args:
            phone: 手机号
            sms_code: 短信验证码
            
        Returns:
            User: 认证成功返回用户对象，失败返回 None
        """
        # 验证短信验证码
        if not cls.verify_sms_code(sms_code):
            return None
        
        # 加密手机号进行查找
        phone_hash = cls.encrypt_phone(phone)
        user = await cls.get_or_none(phone_hash=phone_hash, is_active=True)
        
        return user
    
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
            "id": self.id,
            "nick_name": self.nick_name,
            "is_active": self.is_active,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }
        
        if include_phone:
            data["phone_display"] = self.phone_display
            
        return data
    
    def __str__(self) -> str:
        return f"User(id={self.id}, nick_name={self.nick_name})"
    
    def __repr__(self) -> str:
        return f"<User {self.nick_name}>"
