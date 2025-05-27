from pydantic import BaseModel, Field, validator
from typing import Optional
import re

from app.utils.crypto_utils import PhoneCrypto
from app.utils.validators import UidSidValidator

class SendSmsRequest(UidSidValidator):
    """发送短信验证码请求"""
    phone: str = Field(..., description="手机号")
    
    @validator('phone')
    def validate_phone(cls, v):
        """验证手机号格式"""
        if not v:
            raise ValueError('手机号不能为空')
        
        # 移除所有空格和特殊字符
        phone = re.sub(r'[^\d]', '', PhoneCrypto.decrypt(v))
        
        return phone

class LoginRequest(UidSidValidator):
    """手机号登录请求"""
    phone: str = Field(..., description="手机号")
    sms_code: str = Field(..., description="短信验证码")
    
    @validator('phone')
    def validate_phone(cls, v):
        """验证手机号格式"""
        if not v:
            raise ValueError('手机号不能为空')
        
        # 移除所有空格和特殊字符
        phone = re.sub(r'[^\d]', '', PhoneCrypto.decrypt(v))
        
        return phone
    
    @validator('sms_code')
    def validate_sms_code(cls, v):
        """验证短信验证码格式"""
        if not v:
            raise ValueError('验证码不能为空')
        
        # 移除空格
        code = v.strip()
        return code
    
class RefreshTokenRequest(UidSidValidator):
    """刷新令牌请求"""
    refresh_token: str = Field(..., description="刷新令牌")
    
    @validator('refresh_token')
    def validate_refresh_token(cls, v):
        """验证刷新令牌"""
        if not v:
            raise ValueError('刷新令牌不能为空')
        return v.strip()

# 响应模型
class UserResponse(BaseModel):
    """用户信息响应"""
    id: int
    nick_name: str
    phone_display: str
    is_active: bool
    created_at: str
    updated_at: str

class LoginResponse(BaseModel):
    """登录响应"""
    message: str
    user: UserResponse
    access_token: str
    refresh_token: str
    token_type: str = "Bearer"
    expires_in: int

class SmsResponse(BaseModel):
    """短信发送响应"""
    message: str
    phone_display: str
    expires_in: int = 300  # 5分钟过期

class RefreshTokenResponse(BaseModel):
    """刷新令牌响应"""
    message: str
    access_token: str
    refresh_token: str
    token_type: str = "Bearer"
    expires_in: int

class ErrorResponse(BaseModel):
    """错误响应"""
    error: str
    message: str
    details: Optional[str] = None 