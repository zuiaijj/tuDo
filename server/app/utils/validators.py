#!/usr/bin/env python3
"""
参数校验工具模块
基于Pydantic提供API请求参数校验功能
"""

from typing import Optional, Any, Dict, Type, TypeVar
from pydantic import BaseModel, Field, validator, ValidationError
import re
from functools import wraps

# 定义类型变量
T = TypeVar('T', bound=BaseModel)

class BaseRequest(BaseModel):
    """基础校验器"""
    
    class Config:
        # 禁止额外字段
        extra = "forbid"
        # 验证赋值
        validate_assignment = True


class UidSidValidator(BaseRequest):
    """用户ID和会话ID组合校验器"""
    uid: int = Field(..., description="用户ID")
    access_token: str = Field(..., description="访问令牌")
    
    @validator('uid')
    def validate_uid(cls, v):
        """校验用户ID"""
        return v
    
    @validator('access_token')
    def validate_access_token(cls, v):
        """校验访问令牌"""
        return v
    
class UidValidator(BaseRequest):
    """用户ID校验器"""
    uid: int = Field(..., description="用户ID")
    
    @validator('uid')
    def validate_uid(cls, v):
        """校验用户ID"""
        return v