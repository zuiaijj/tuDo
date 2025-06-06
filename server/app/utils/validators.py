#!/usr/bin/env python3
"""
参数校验工具模块
基于Pydantic提供API请求参数校验功能
"""

import traceback
from typing import Optional, Any, Dict, TypeVar, Generic
from pydantic import BaseModel, Field, validator, ValidationError
import time
from functools import wraps

from sanic import Request, json

from app.models.user.user import User
from app.models.const import ResponseCode, ErrorType, Message

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
    code: int = Field(default=ResponseCode.SUCCESS, description="响应状态码")
    message: str = Field(default=Message.SUCCESS, description="响应消息")
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
    code: int = Field(default=ResponseCode.SERVER_ERROR, description="错误状态码")
    message: str = Field(default=Message.SERVER_ERROR, description="错误消息")
    success: bool = Field(default=False, description="是否成功")
    error_type: Optional[str] = Field(default=None, description="错误类型")
    error_details: Optional[Dict[str, Any]] = Field(default=None, description="错误详情")


def success_response(
    data: Any = None,
    message: str = Message.SUCCESS,
    code: int = ResponseCode.SUCCESS
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
    message: str = Message.SERVER_ERROR,
    code: int = ResponseCode.SERVER_ERROR,
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

def param_error_response(
    message: str = Message.PARAM_ERROR,
    error_type: Optional[str] = None,
    error_details: Optional[Dict[str, Any]] = None
) -> Dict[str, Any]:
    return ErrorResponse(
        code=ResponseCode.PARAM_ERROR,
        message=message,
        success=False,
        error_type=error_type,
        error_details=error_details,
        timestamp=int(time.time() * 1000)
    ).json_response()


async def uid_check(request: Request) -> Dict[str, Any]:
    try:
        # 从查询参数获取令牌和用户ID，处理列表值
        query_params = {}
        for key, value in request.args.items():
            # request.args的值是列表，取第一个值
            query_params[key] = value[0] if isinstance(value, list) and len(value) > 0 else value
        
        auth_params = UidValidator(**query_params)
        user_id = auth_params.uid
        
        # 获取用户信息
        user = await User.get(uid=user_id)
        if not user or not user.is_active:
            return error_response(
                message=Message.USER_NOT_FOUND,
                code=ResponseCode.NOT_FOUND,
                error_type=ErrorType.NOT_FOUND_ERROR
            )
        return {
            "code": ResponseCode.SUCCESS,
            "user": user
        }
    except Exception as e:
        print(f"获取用户信息错误: {e}")
        print(traceback.format_exc())
        return error_response(
            message=Message.SERVER_ERROR,
            code=ResponseCode.SERVER_ERROR,
            error_type=ErrorType.SERVER_ERROR
        )


async def uid_sid_check(request: Request) -> Dict[str, Any]:
    try:
        # 从查询参数获取令牌和用户ID，处理列表值
        query_params = {}
        for key, value in request.args.items():
            # request.args的值是列表，取第一个值
            query_params[key] = value[0] if isinstance(value, list) and len(value) > 0 else value
        
        auth_params = UidSidValidator(**query_params)
        access_token = auth_params.access_token
        user_id = auth_params.uid
        
        # 获取用户信息
        user = await User.get(uid=user_id)
        if not user or not user.is_active:
            return error_response(
                message=Message.USER_NOT_FOUND,
                code=ResponseCode.NOT_FOUND,
                error_type=ErrorType.NOT_FOUND_ERROR
            )
        if (access_token != user.access_token):
            print(f"access_token: {access_token}, \n user.access_token: {user.access_token}")
            return error_response(
                message=Message.TOKEN_EXPIRED,
                code=ResponseCode.UNAUTHORIZED,
                error_type=ErrorType.AUTHENTICATION_ERROR
            )
        return {
            "code": ResponseCode.SUCCESS,
            "user": user
        }
        
    except ValidationError as e:
        print(f"参数验证错误: {e}")
        print(f"查询参数: {dict(request.args)}")
        return error_response(
            message=Message.PARAM_ERROR,
            code=ResponseCode.PARAM_ERROR,
            error_type=ErrorType.VALIDATION_ERROR,
            error_details={"validation_errors": e.errors()}
        )
    except Exception as e:
        print(f"获取用户信息错误: {e}")
        print(f"查询参数: {dict(request.args)}")
        print(traceback.format_exc())
        return error_response(
            message=Message.SERVER_ERROR,
            code=ResponseCode.SERVER_ERROR,
            error_type=ErrorType.SERVER_ERROR
        )
    

def require_auth(f):
    """
    认证装饰器 - 自动验证uid和access_token
    
    使用方法：
    @auth_bp.route('/api/user/profile/update', methods=['POST'])
    @require_auth
    async def update_user_profile(request, current_user):
        # current_user 是已验证的用户对象
        # 在这里处理业务逻辑
        pass
    """
    @wraps(f)
    async def decorated_function(request, *args, **kwargs):
        # 执行认证检查
        auth_result = await uid_sid_check(request)
        
        # 如果认证失败，直接返回错误响应
        if auth_result.get("code") != ResponseCode.SUCCESS:
            return json(auth_result)
        
        # 认证成功，将用户对象传递给路由函数
        current_user = auth_result.get("user")
        return await f(request, current_user, *args, **kwargs)
    
    return decorated_function


def require_uid(f):
    """
    用户认证装饰器 - 需要用户uid
    """
    @wraps(f)
    async def decorated_function(request, *args, **kwargs):
        auth_result = await uid_check(request)
        if auth_result.get("code") != ResponseCode.SUCCESS:
            return json(auth_result)
        current_user = auth_result.get("user")
        return await f(request, current_user, *args, **kwargs)
    return decorated_function

def optional_auth(f):
    """
    可选认证装饰器 - 如果提供了uid和access_token就验证，没有就传递None
    
    使用方法：
    @auth_bp.route('/api/public/info', methods=['GET'])
    @optional_auth
    async def get_public_info(request, current_user):
        # current_user 可能是User对象或None
        if current_user:
            # 已登录用户的逻辑
        else:
            # 未登录用户的逻辑
        pass
    """
    @wraps(f)
    async def decorated_function(request, *args, **kwargs):
        current_user = None
        
        # 检查是否提供了认证参数
        query_params = {}
        for key, value in request.args.items():
            query_params[key] = value[0] if isinstance(value, list) and len(value) > 0 else value
        
        if 'uid' in query_params and 'access_token' in query_params:
            # 提供了认证参数，尝试验证
            auth_result = await uid_sid_check(request)
            if auth_result.get("code") == ResponseCode.SUCCESS:
                current_user = auth_result.get("user")
        
        return await f(request, current_user, *args, **kwargs)
    
    return decorated_function


def admin_required(f):
    """
    管理员权限装饰器 - 需要用户认证且具有管理员权限
    
    注意：需要先在User模型中添加is_admin字段
    """
    @wraps(f)
    async def decorated_function(request, *args, **kwargs):
        # 先执行认证检查
        auth_result = await uid_sid_check(request)
        
        if auth_result.get("code") != ResponseCode.SUCCESS:
            return json(auth_result)
        
        current_user = auth_result.get("user")
        
        # 检查是否有管理员权限（需要在User模型中添加is_admin字段）
        # if not getattr(current_user, 'is_admin', False):
        #     return json(error_response(
        #         message=Message.PERMISSION_DENIED,
        #         code=ResponseCode.FORBIDDEN,
        #         error_type=ErrorType.AUTHORIZATION_ERROR
        #     ))
        
        return await f(request, current_user, *args, **kwargs)
    
    return decorated_function
