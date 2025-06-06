from sanic import Blueprint, Request
from sanic.response import json
from pydantic import ValidationError
from app.models.user.user import User
from app.utils.jwt_utils import JWTUtils, JWTExpiredError, JWTInvalidError
from app.services.sms_service import sms_service
import traceback
from datetime import datetime

from app.utils.validators import DataResponse, ErrorResponse, UidSidValidator, error_response, param_error_response, success_response
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
        "dial_code": "国际区号"
    }
    """
    try:
        # 验证请求数据
        try:
            data = SendSmsRequest(**request.json)
        except ValidationError as e:
            return json(param_error_response(message="请求数据格式错误", error_details={"details": str(e)}))
        
        # 发送短信验证码
        result = await sms_service.send_sms_code(data.phone, data.dial_code)
        
        if result["success"]:
            response_data = {
                "code_id": result["code_id"],
            }
            
            return json(success_response(data=response_data))
        else:
            return json(error_response(message=result.get("message", "短信发送失败")))
            
    except ValueError as e:
        return json(error_response(message=str(e)))
    except Exception as e:
        print(f"发送短信验证码错误: {e}")
        print(traceback.format_exc())
        return json(error_response(message="服务器内部错误"))

@auth_bp.post("/phone/register")
async def register(request: Request):
    """
    手机号验证码登录
    
    请求体:
    {
        "phone": "加密后的手机号",
        "dial_code": "国际区号",
        "code_id": "验证码ID",
        "sms_code": "验证码"
    }
    """
    try:
        # 验证请求数据
        try:
            data = LoginRequest(**request.json)
        except ValidationError as e:
            return json(param_error_response(message="请求数据格式错误", error_details={"details": str(e)}))
        
        # 验证短信验证码
        verify_result = sms_service.verify_sms_code(data.phone, data.dial_code, data.sms_code, data.code_id)
        
        if not verify_result["success"]:
            return json(error_response(message=verify_result["message"], error_details={"error_code": verify_result["error_code"]}))
        
        # 查找用户
        user = await User.get_user_by_phone(verify_result["phone"])
        
        if not user:
            user = await User.create_user(verify_result["phone"])
        if not user.is_active:
            return json(error_response(message="用户账号已被禁用"))
        
        # 生成JWT令牌
        access_token = JWTUtils.generate_access_token(user.uid)
        refresh_token = JWTUtils.generate_refresh_token(user.uid)
        await User.update_profile(user.uid, "access_token", access_token)
        userJson = user.to_dict()
        userJson["access_token"] = access_token
        return json(success_response(data={
            "user": userJson,
            "refresh_token": refresh_token,
        }))
        
    except Exception as e:
        print(f"用户登录错误: {e}")
        print(traceback.format_exc())
        return json({
            "error": "INTERNAL_ERROR",
            "message": "服务器内部错误"
        }, status=500)
