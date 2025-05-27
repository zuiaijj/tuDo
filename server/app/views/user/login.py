from sanic import Blueprint, Request
from sanic.response import json
from pydantic import ValidationError
from app.models.user.user import User
from app.utils.jwt_utils import JWTUtils, JWTExpiredError, JWTInvalidError
from app.services.sms_service import sms_service
import traceback
from datetime import datetime

from app.utils.validators import UidSidValidator
from app.views.user.validator.v_login import LoginRequest, SendSmsRequest, RefreshTokenRequest

# 创建认证蓝图
auth_bp = Blueprint("login", url_prefix="/api/login")

# JWT工具类（静态方法，无需实例化）

@auth_bp.post("/send-sms")
async def send_sms_code(request: Request):
    """
    发送短信验证码
    
    请求体:
    {
        "phone": "加密后的手机号"
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
        "phone": "加密后的手机号",
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
            user = await User.create_user(data.phone)
        if not user.is_active:
            return json({
                "error": "USER_INACTIVE",
                "message": "用户账号已被禁用"
            }, status=403)
        
        # 生成JWT令牌
        access_token = JWTUtils.generate_access_token(user.uid)
        refresh_token = JWTUtils.generate_refresh_token(user.uid)
        await User.update_profile(user.uid, "access_token", access_token)
        
        return json({
            "message": "登录成功",
            "user": user.to_dict(),
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
        await User.update_profile(user_id, "access_token", new_access_token)
        
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
        # 从查询参数获取令牌和用户ID
        auth_header = UidSidValidator(**request.json)
        access_token = auth_header.access_token
        user_id = auth_header.uid
        
        # 获取用户信息
        user = await User.get(id=user_id)
        if not user or not user.is_active:
            return json({
                "error": "USER_INVALID",
                "message": "用户不存在或已被禁用"
            }, status=401)
        if (access_token != user.access_token):
            return json({
                "error": "TOKEN_INVALID",
                "message": "访问令牌过期，请重新登录"
            }, status=401)
        
        return json({
            "message": "获取用户信息成功",
            "user": user.to_dict(),
        }, status=200)
        
    except Exception as e:
        print(f"获取用户信息错误: {e}")
        print(traceback.format_exc())
        return json({
            "error": "INTERNAL_ERROR",
            "message": "服务器内部错误"
        }, status=500)