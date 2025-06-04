import traceback
from sanic import Blueprint, Request
from sanic.response import json
from app.models.const import UserMeta
from app.models.user.user import User
from app.utils.validators import DataResponse, ErrorResponse, UidSidValidator, error_response, uid_sid_check, success_response

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