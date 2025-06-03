#!/usr/bin/env python3
"""
参数校验工具模块
基于Pydantic提供API请求参数校验功能
"""

from typing import Optional, Any, Dict, Type, TypeVar, Generic, List
from pydantic import BaseModel, Field, validator, ValidationError
import re
import time
from functools import wraps

# 定义类型变量
T = TypeVar('T', bound=BaseModel)
DataT = TypeVar('DataT')

class BaseRequest(BaseModel):
    """基础校验器"""
    
    class Config:
        # 禁止额外字段
        extra = "allow"
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


class BaseResponse(BaseModel):
    """基础响应模型"""
    code: int = Field(default=0, description="响应状态码")
    message: str = Field(default="success", description="响应消息")
    success: bool = Field(default=True, description="是否成功")
    timestamp: Optional[int] = Field(default=None, description="时间戳")
    
    class Config:
        # 允许额外字段用于向后兼容
        extra = "allow"
    
    def to_dict(self) -> Dict[str, Any]:
        """转换为字典，确保JSON序列化兼容"""
        data = self.dict()
        # 如果timestamp为None，设置为当前时间戳
        if data.get('timestamp') is None:
            data['timestamp'] = int(time.time() * 1000)  # 毫秒时间戳
        return data
    
    def json_response(self) -> Dict[str, Any]:
        """返回可JSON序列化的响应字典"""
        return self.to_dict()


class DataResponse(BaseResponse, Generic[DataT]):
    """带数据的响应模型"""
    data: Optional[DataT] = Field(default=None, description="响应数据")
    
    def to_dict(self) -> Dict[str, Any]:
        """转换为字典，确保JSON序列化兼容"""
        result = super().to_dict()
        return result


class ErrorResponse(BaseResponse):
    """错误响应模型"""
    code: int = Field(default=500, description="错误状态码")
    message: str = Field(default="error", description="错误消息")
    success: bool = Field(default=False, description="是否成功")
    error_type: Optional[str] = Field(default=None, description="错误类型")
    error_details: Optional[Dict[str, Any]] = Field(default=None, description="错误详情")


def success_response(
    data: Any = None,
    message: str = "success",
    code: int = 0
) -> Dict[str, Any]:
    """创建成功响应模型对象"""
    return DataResponse(
        code=code,
        message=message,
        success=True,
        data=data,
        timestamp=int(time.time() * 1000)
    ).json_response()


def error_response(
    message: str = "error",
    code: int = 500,
    error_type: Optional[str] = None,
    error_details: Optional[Dict[str, Any]] = None
) -> Dict[str, Any]:
    """创建错误响应模型对象"""
    return ErrorResponse(
        code=code,
        message=message,
        success=False,
        error_type=error_type,
        error_details=error_details,
        timestamp=int(time.time() * 1000)
    ).json_response()

