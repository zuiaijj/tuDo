import jwt
from datetime import datetime, timedelta
from typing import Optional, Dict, Any
from app.config.settings import settings

class JWTUtils:
    """JWT 工具类"""
    
    @staticmethod
    def create_access_token(user_id: int, username: str) -> str:
        """
        创建访问令牌
        
        Args:
            user_id: 用户ID
            username: 用户名
            
        Returns:
            str: JWT 访问令牌
        """
        expire = datetime.utcnow() + timedelta(hours=settings.JWT_EXPIRE_HOURS)
        payload = {
            "user_id": user_id,
            "username": username,
            "exp": expire,
            "iat": datetime.utcnow(),
            "type": "access"
        }
        return jwt.encode(payload, settings.JWT_SECRET_KEY, algorithm=settings.JWT_ALGORITHM)
    
    @staticmethod
    def create_refresh_token(user_id: int) -> str:
        """
        创建刷新令牌（有效期更长）
        
        Args:
            user_id: 用户ID
            
        Returns:
            str: JWT 刷新令牌
        """
        expire = datetime.utcnow() + timedelta(days=7)  # 刷新令牌7天有效
        payload = {
            "user_id": user_id,
            "exp": expire,
            "iat": datetime.utcnow(),
            "type": "refresh"
        }
        return jwt.encode(payload, settings.JWT_SECRET_KEY, algorithm=settings.JWT_ALGORITHM)
    
    @staticmethod
    def decode_token(token: str) -> Dict[str, Any]:
        """
        解码令牌
        
        Args:
            token: JWT 令牌
            
        Returns:
            Dict[str, Any]: 解码后的载荷
            
        Raises:
            JWTExpiredError: 令牌已过期
            JWTInvalidError: 无效的令牌
        """
        try:
            payload = jwt.decode(
                token, 
                settings.JWT_SECRET_KEY, 
                algorithms=[settings.JWT_ALGORITHM]
            )
            return payload
        except jwt.ExpiredSignatureError:
            raise JWTExpiredError("令牌已过期")
        except jwt.InvalidTokenError:
            raise JWTInvalidError("无效的令牌")
    
    @staticmethod
    def verify_access_token(token: str) -> Optional[Dict[str, Any]]:
        """
        验证访问令牌
        
        Args:
            token: JWT 访问令牌
            
        Returns:
            Dict[str, Any]: 用户信息，如果令牌无效返回 None
        """
        try:
            payload = JWTUtils.decode_token(token)
            
            # 检查令牌类型
            if payload.get("type") != "access":
                return None
            
            return {
                "user_id": payload.get("user_id"),
                "username": payload.get("username")
            }
        except (JWTExpiredError, JWTInvalidError):
            return None
    
    @staticmethod
    def verify_refresh_token(token: str) -> Optional[int]:
        """
        验证刷新令牌
        
        Args:
            token: JWT 刷新令牌
            
        Returns:
            int: 用户ID，如果令牌无效返回 None
        """
        try:
            payload = JWTUtils.decode_token(token)
            
            # 检查令牌类型
            if payload.get("type") != "refresh":
                return None
            
            return payload.get("user_id")
        except (JWTExpiredError, JWTInvalidError):
            return None
    
    @staticmethod
    def extract_token_from_header(authorization_header: str) -> Optional[str]:
        """
        从 Authorization 头部提取令牌
        
        Args:
            authorization_header: Authorization 头部值
            
        Returns:
            str: 提取的令牌，如果格式不正确返回 None
        """
        if not authorization_header:
            return None
        
        parts = authorization_header.split()
        if len(parts) != 2 or parts[0].lower() != "bearer":
            return None
        
        return parts[1]
    
    @staticmethod
    def get_token_expiry(token: str) -> Optional[datetime]:
        """
        获取令牌过期时间
        
        Args:
            token: JWT 令牌
            
        Returns:
            datetime: 过期时间，如果令牌无效返回 None
        """
        try:
            payload = JWTUtils.decode_token(token)
            exp_timestamp = payload.get("exp")
            if exp_timestamp:
                return datetime.utcfromtimestamp(exp_timestamp)
            return None
        except (JWTExpiredError, JWTInvalidError):
            return None
    
    @staticmethod
    def is_token_expired(token: str) -> bool:
        """
        检查令牌是否已过期
        
        Args:
            token: JWT 令牌
            
        Returns:
            bool: 如果已过期返回 True
        """
        expiry = JWTUtils.get_token_expiry(token)
        if not expiry:
            return True
        
        return datetime.utcnow() > expiry

class JWTError(Exception):
    """JWT 基础异常类"""
    pass

class JWTExpiredError(JWTError):
    """JWT 过期异常"""
    pass

class JWTInvalidError(JWTError):
    """JWT 无效异常"""
    pass
