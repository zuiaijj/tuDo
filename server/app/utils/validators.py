from pydantic import BaseModel, Field, validator
from typing import Optional
import re

class SendSmsRequest(BaseModel):
    """发送短信验证码请求"""
    phone: str = Field(..., description="手机号")
    
    @validator('phone')
    def validate_phone(cls, v):
        """验证手机号格式"""
        if not v:
            raise ValueError('手机号不能为空')
        
        # 移除所有空格和特殊字符
        phone = re.sub(r'[^\d]', '', v)
        
        # 验证手机号格式（中国大陆手机号）
        if not re.match(r'^1[3-9]\d{9}$', phone):
            raise ValueError('请输入正确的手机号格式')
        
        return phone

class LoginRequest(BaseModel):
    """手机号登录请求"""
    phone: str = Field(..., description="手机号")
    sms_code: str = Field(..., description="短信验证码")
    
    @validator('phone')
    def validate_phone(cls, v):
        """验证手机号格式"""
        if not v:
            raise ValueError('手机号不能为空')
        
        # 移除所有空格和特殊字符
        phone = re.sub(r'[^\d]', '', v)
        
        # 验证手机号格式（中国大陆手机号）
        if not re.match(r'^1[3-9]\d{9}$', phone):
            raise ValueError('请输入正确的手机号格式')
        
        return phone
    
    @validator('sms_code')
    def validate_sms_code(cls, v):
        """验证短信验证码格式"""
        if not v:
            raise ValueError('验证码不能为空')
        
        # 移除空格
        code = v.strip()
        
        # 验证验证码格式（4位数字）
        if not re.match(r'^\d{4}$', code):
            raise ValueError('验证码必须是4位数字')
        
        return code

class RegisterRequest(BaseModel):
    """用户注册请求"""
    phone: str = Field(..., description="手机号")
    sms_code: str = Field(..., description="短信验证码")
    nick_name: str = Field(..., description="用户昵称")
    
    @validator('phone')
    def validate_phone(cls, v):
        """验证手机号格式"""
        if not v:
            raise ValueError('手机号不能为空')
        
        # 移除所有空格和特殊字符
        phone = re.sub(r'[^\d]', '', v)
        
        # 验证手机号格式（中国大陆手机号）
        if not re.match(r'^1[3-9]\d{9}$', phone):
            raise ValueError('请输入正确的手机号格式')
        
        return phone
    
    @validator('sms_code')
    def validate_sms_code(cls, v):
        """验证短信验证码格式"""
        if not v:
            raise ValueError('验证码不能为空')
        
        # 移除空格
        code = v.strip()
        
        # 验证验证码格式（4位数字）
        if not re.match(r'^\d{4}$', code):
            raise ValueError('验证码必须是4位数字')
        
        return code
    
    @validator('nick_name')
    def validate_nick_name(cls, v):
        """验证用户昵称"""
        if not v:
            raise ValueError('用户昵称不能为空')
        
        # 移除首尾空格
        nick_name = v.strip()
        
        # 验证昵称长度
        if len(nick_name) < 2:
            raise ValueError('用户昵称至少2个字符')
        
        if len(nick_name) > 20:
            raise ValueError('用户昵称不能超过20个字符')
        
        # 验证昵称格式（允许中文、英文、数字、下划线）
        if not re.match(r'^[\u4e00-\u9fa5a-zA-Z0-9_]+$', nick_name):
            raise ValueError('用户昵称只能包含中文、英文、数字和下划线')
        
        return nick_name

class RefreshTokenRequest(BaseModel):
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

class RegisterResponse(BaseModel):
    """注册响应"""
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