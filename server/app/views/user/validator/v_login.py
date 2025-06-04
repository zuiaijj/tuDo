from pydantic import BaseModel, Field, validator
from typing import Optional
import re

from app.utils.crypto_utils import PhoneCrypto
from app.utils.validators import UidValidator

class SendSmsRequest(BaseModel):
    """发送短信验证码请求"""
    phone: str = Field(..., description="手机号")
    dial_code: str = Field(..., description="国际区号")
    
    @validator('phone')
    def validate_phone(cls, v):
        """验证手机号格式"""
        if not v:
            raise ValueError('手机号不能为空')
        
        # 移除所有空格和特殊字符
        phone = re.sub(r'[^\d]', '', PhoneCrypto.decrypt(v))

        if not phone.isdigit():
            raise ValueError('手机号格式错误')
        
        return phone

class LoginRequest(BaseModel):
    """手机号登录请求"""
    phone: str = Field(..., description="手机号")
    dial_code: str = Field(..., description="国际区号")
    sms_code: str = Field(..., description="短信验证码")
    code_id: str = Field(..., description="验证码ID")
    
    @validator('phone')
    def validate_phone(cls, v):
        """验证手机号格式"""
        if not v:
            raise ValueError('手机号不能为空')
        
        # 移除所有空格和特殊字符
        phone = re.sub(r'[^\d]', '', PhoneCrypto.decrypt(v))

        if not phone.isdigit():
            raise ValueError('手机号格式错误')
        
        return phone
    
    @validator('sms_code')
    def validate_sms_code(cls, v):
        """验证短信验证码格式"""
        if not v:
            raise ValueError('验证码不能为空')
        
        # 移除空格
        code = v.strip()
        return code
    
class RefreshTokenRequest(UidValidator):
    """刷新令牌请求"""
    refresh_token: str = Field(..., description="刷新令牌")
    
    @validator('refresh_token')
    def validate_refresh_token(cls, v):
        """验证刷新令牌"""
        if not v:
            raise ValueError('刷新令牌不能为空')
        return v.strip()