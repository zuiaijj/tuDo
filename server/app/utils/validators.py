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
    sid: str = Field(..., description="会话ID")
    
    @validator('uid')
    def validate_uid(cls, v):
        """校验用户ID"""
        return v
    
    @validator('sid')
    def validate_sid(cls, v):
        """校验会话ID"""
        return v