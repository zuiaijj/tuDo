import traceback
from pydantic import ValidationError
from sanic import Blueprint, Request
from sanic.response import json
from app.models.const import UserMeta
from app.models.user.user import User
from app.utils.jwt_utils import JWTExpiredError, JWTInvalidError, JWTUtils
from app.utils.validators import DataResponse, ErrorResponse, UidSidValidator, error_response, param_error_response, uid_sid_check, success_response
from app.views.user.validator.v_login import RefreshTokenRequest

user_bp = Blueprint("user", url_prefix="/api/user")

@user_bp.get("/me")
async def get_current_user(request: Request):
    """
    获取当前用户信息
    
    需要在请求头中包含: Authorization: Bearer <access_token>
    """
    result = await uid_sid_check(request)
    if result["code"] != 0:
        return json(result)
    user = result["user"]
    return json(success_response(data=user.to_dict()))
    

@user_bp.post("profile/update")
async def update_user(request: Request):
    """
    更新用户信息
    """
    result = await uid_sid_check(request)
    if result["code"] != 0:
        return json(result)
    user = result["user"]
    '''遍历request.json,更新user的属性'''
    for key, value in request.json.items():
        if key not in UserMeta.list:
            if key not in user.__dict__:
                return json(error_response(message="非法参数"))
            setattr(user, key, value)
    await user.save()
    return json(success_response(data=user.to_dict()))



@user_bp.post("/refresh/token")
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
            return json(param_error_response(message="请求数据格式错误", error_details={"details": str(e)}))
        
        # 验证刷新令牌
        try:
            payload = JWTUtils.verify_refresh_token(data.refresh_token)
            user_id: int = payload["user_id"]
        except JWTExpiredError:
            return json(error_response(message="刷新令牌已过期，请重新登录"))
        except JWTInvalidError:
            return json(error_response(message="刷新令牌无效"))
        if (user_id != data.uid):
            return json(error_response(message="用户ID不匹配"))
        
        # 检查用户是否存在且激活
        user = await User.get(uid=user_id)
        if not user or not user.is_active:
            return json(error_response(message="用户不存在或已被禁用"))
        
        # 生成新的令牌
        new_access_token = JWTUtils.generate_access_token(user_id)
        new_refresh_token = JWTUtils.generate_refresh_token(user_id)
        await User.update_profile(user_id, "access_token", new_access_token)
        
        return json(success_response(data={
            "access_token": new_access_token,
            "refresh_token": new_refresh_token,
        })) 
        
    except Exception as e:
        print(f"刷新令牌错误: {e}")
        print(traceback.format_exc())
        return json(error_response(message="服务器内部错误"))