from sanic import Blueprint, Request
from sanic.response import json
from pydantic import ValidationError
from app.models.user.user import User
from app.utils.validators import (
    SendSmsRequest, LoginRequest, RegisterRequest, RefreshTokenRequest,
    LoginResponse, RegisterResponse, SmsResponse, RefreshTokenResponse, ErrorResponse
)
from app.utils.jwt_utils import JWTUtils, JWTExpiredError, JWTInvalidError
from app.services.sms_service import sms_service
import traceback
from datetime import datetime

# 创建认证蓝图
auth_bp = Blueprint("auth", url_prefix="/api/auth")

# JWT工具类（静态方法，无需实例化）

def format_user_response(user: User) -> dict:
    """格式化用户响应数据"""
    return {
        "id": user.id,
        "nick_name": user.nick_name,
        "phone_display": user.phone_display,
        "is_active": user.is_active,
        "created_at": user.created_at.isoformat(),
        "updated_at": user.updated_at.isoformat()
    }

@auth_bp.post("/send-sms")
async def send_sms_code(request: Request):
    """
    发送短信验证码
    
    请求体:
    {
        "phone": "13800138000"
    }
    """
    try:
        # 验证请求数据
        try:
            data = SendSmsRequest(**request.json)
        except ValidationError as e:
            return json({
                "error": "VALIDATION_ERROR",
                "message": "请求数据格式错误",
                "details": str(e)
            }, status=400)
        
        # 发送短信验证码
        result = await sms_service.send_sms_code(data.phone)
        
        if result["success"]:
            response_data = {
                "message": result["message"],
                "phone_display": result["phone_display"],
                "expires_in": result["expires_in"]
            }
            
            # 如果是测试模式，返回验证码
            if result.get("test_mode"):
                response_data["test_code"] = result["test_code"]
                response_data["test_mode"] = True
            
            return json(response_data, status=200)
        else:
            return json({
                "error": "SMS_SEND_FAILED",
                "message": result.get("message", "短信发送失败")
            }, status=500)
            
    except ValueError as e:
        return json({
            "error": "SMS_SEND_ERROR",
            "message": str(e)
        }, status=400)
    except Exception as e:
        print(f"发送短信验证码错误: {e}")
        print(traceback.format_exc())
        return json({
            "error": "INTERNAL_ERROR",
            "message": "服务器内部错误"
        }, status=500)

@auth_bp.post("/login")
async def login(request: Request):
    """
    手机号验证码登录
    
    请求体:
    {
        "phone": "13800138000",
        "sms_code": "1234"
    }
    """
    try:
        # 验证请求数据
        try:
            data = LoginRequest(**request.json)
        except ValidationError as e:
            return json({
                "error": "VALIDATION_ERROR",
                "message": "请求数据格式错误",
                "details": str(e)
            }, status=400)
        
        # 验证短信验证码
        verify_result = sms_service.verify_sms_code(data.phone, data.sms_code)
        
        if not verify_result["success"]:
            return json({
                "error": verify_result.get("error_code", "SMS_VERIFY_FAILED"),
                "message": verify_result["message"]
            }, status=400)
        
        # 查找用户
        user = await User.get_user_by_phone(data.phone)
        
        if not user:
            return json({
                "error": "USER_NOT_FOUND",
                "message": "用户不存在，请先注册"
            }, status=404)
        
        if not user.is_active:
            return json({
                "error": "USER_INACTIVE",
                "message": "用户账号已被禁用"
            }, status=403)
        
        # 生成JWT令牌
        access_token = JWTUtils.generate_access_token(user.id)
        refresh_token = JWTUtils.generate_refresh_token(user.id)
        
        return json({
            "message": "登录成功",
            "user": format_user_response(user),
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "Bearer",
            "expires_in": JWTUtils.ACCESS_TOKEN_EXPIRES
        }, status=200)
        
    except Exception as e:
        print(f"用户登录错误: {e}")
        print(traceback.format_exc())
        return json({
            "error": "INTERNAL_ERROR",
            "message": "服务器内部错误"
        }, status=500)

@auth_bp.post("/register")
async def register(request: Request):
    """
    用户注册
    
    请求体:
    {
        "phone": "13800138000",
        "sms_code": "1234",
        "nick_name": "用户昵称"
    }
    """
    try:
        # 验证请求数据
        try:
            data = RegisterRequest(**request.json)
        except ValidationError as e:
            return json({
                "error": "VALIDATION_ERROR",
                "message": "请求数据格式错误",
                "details": str(e)
            }, status=400)
        
        # 验证短信验证码
        verify_result = sms_service.verify_sms_code(data.phone, data.sms_code)
        
        if not verify_result["success"]:
            return json({
                "error": verify_result.get("error_code", "SMS_VERIFY_FAILED"),
                "message": verify_result["message"]
            }, status=400)
        
        # 检查用户是否已存在
        existing_user = await User.get_user_by_phone(data.phone)
        if existing_user:
            return json({
                "error": "USER_EXISTS",
                "message": "该手机号已注册，请直接登录"
            }, status=409)
        
        # 创建新用户
        try:
            user = await User.create_user(data.nick_name, data.phone)
        except ValueError as e:
            return json({
                "error": "USER_CREATE_FAILED",
                "message": str(e)
            }, status=400)
        
        # 生成JWT令牌
        access_token = JWTUtils.generate_access_token(user.id)
        refresh_token = JWTUtils.generate_refresh_token(user.id)
        
        return json({
            "message": "注册成功",
            "user": format_user_response(user),
            "access_token": access_token,
            "refresh_token": refresh_token,
            "token_type": "Bearer",
            "expires_in": JWTUtils.ACCESS_TOKEN_EXPIRES
        }, status=201)
        
    except Exception as e:
        print(f"用户注册错误: {e}")
        print(traceback.format_exc())
        return json({
            "error": "INTERNAL_ERROR",
            "message": "服务器内部错误"
        }, status=500)

@auth_bp.post("/refresh")
async def refresh_token(request: Request):
    """
    刷新访问令牌
    
    请求体:
    {
        "refresh_token": "refresh_token_here"
    }
    """
    try:
        # 验证请求数据
        try:
            data = RefreshTokenRequest(**request.json)
        except ValidationError as e:
            return json({
                "error": "VALIDATION_ERROR",
                "message": "请求数据格式错误",
                "details": str(e)
            }, status=400)
        
        # 验证刷新令牌
        try:
            payload = JWTUtils.verify_refresh_token(data.refresh_token)
            user_id: int = payload["user_id"]
        except JWTExpiredError:
            return json({
                "error": "TOKEN_EXPIRED",
                "message": "刷新令牌已过期，请重新登录"
            }, status=401)
        except JWTInvalidError:
            return json({
                "error": "TOKEN_INVALID",
                "message": "刷新令牌无效"
            }, status=401)
        
        # 检查用户是否存在且激活
        user = await User.get(id=user_id)
        if not user or not user.is_active:
            return json({
                "error": "USER_INVALID",
                "message": "用户不存在或已被禁用"
            }, status=401)
        
        # 生成新的令牌
        new_access_token = JWTUtils.generate_access_token(user_id)
        new_refresh_token = JWTUtils.generate_refresh_token(user_id)
        
        return json({
            "message": "令牌刷新成功",
            "access_token": new_access_token,
            "refresh_token": new_refresh_token,
            "token_type": "Bearer",
            "expires_in": JWTUtils.ACCESS_TOKEN_EXPIRES
        }, status=200)
        
    except Exception as e:
        print(f"刷新令牌错误: {e}")
        print(traceback.format_exc())
        return json({
            "error": "INTERNAL_ERROR",
            "message": "服务器内部错误"
        }, status=500)

@auth_bp.get("/me")
async def get_current_user(request: Request):
    """
    获取当前用户信息
    
    需要在请求头中包含: Authorization: Bearer <access_token>
    """
    try:
        # 从请求头获取令牌
        auth_header = request.headers.get("Authorization")
        if not auth_header or not auth_header.startswith("Bearer "):
            return json({
                "error": "TOKEN_MISSING",
                "message": "缺少访问令牌"
            }, status=401)
        
        access_token = auth_header.split(" ")[1]
        
        # 验证访问令牌
        try:
            payload = JWTUtils.verify_access_token(access_token)
            user_id: int = payload["user_id"]
        except JWTExpiredError:
            return json({
                "error": "TOKEN_EXPIRED",
                "message": "访问令牌已过期"
            }, status=401)
        except JWTInvalidError:
            return json({
                "error": "TOKEN_INVALID",
                "message": "访问令牌无效"
            }, status=401)
        
        # 获取用户信息
        user = await User.get(id=user_id)
        if not user or not user.is_active:
            return json({
                "error": "USER_INVALID",
                "message": "用户不存在或已被禁用"
            }, status=401)
        
        return json({
            "message": "获取用户信息成功",
            "user": format_user_response(user)
        }, status=200)
        
    except Exception as e:
        print(f"获取用户信息错误: {e}")
        print(traceback.format_exc())
        return json({
            "error": "INTERNAL_ERROR",
            "message": "服务器内部错误"
        }, status=500)