#!/usr/bin/env python3
"""
项目常量定义模块
定义项目中使用的各种常量
"""

# ===========================
# HTTP 响应状态码
# ===========================
class ResponseCode:
    """响应状态码"""
    SUCCESS = 0                    # 成功
    FORBIDDEN = 403               # 禁止访问
    NOT_FOUND = 404               # 资源不存在
    METHOD_NOT_ALLOWED = 405      # 方法不允许
    CONFLICT = 409                # 资源冲突
    VALIDATION_ERROR = 422        # 验证错误
    RATE_LIMIT = 429              # 请求过于频繁
    PARAM_ERROR = 499             # 参数错误
    SERVER_ERROR = 500            # 服务器内部错误
    SERVICE_UNAVAILABLE = 503     # 服务不可用
    UNAUTHORIZED = 600            # 未授权


# ===========================
# 用户相关常量
# ===========================
class UserGender:
    """用户性别"""
    UNKNOWN = 0    # 未知
    MALE = 1       # 男
    FEMALE = 2     # 女

    @classmethod
    def get_display(cls, gender: int) -> str:
        """获取性别显示文本"""
        gender_map = {
            cls.UNKNOWN: "未知",
            cls.MALE: "男",
            cls.FEMALE: "女"
        }
        return gender_map.get(gender, "未知")

    @classmethod
    def get_all(cls) -> dict:
        """获取所有性别选项"""
        return {
            cls.UNKNOWN: "未知",
            cls.MALE: "男",
            cls.FEMALE: "女"
        }
    
class UserMeta:
    """用户元数据"""
    list = [
        "uid",
        "access_token",
    ]


class UserStatus:
    """用户状态"""
    INACTIVE = False    # 未激活
    ACTIVE = True       # 已激活


# ===========================
# 短信验证码相关常量
# ===========================
class SmsCode:
    """短信验证码常量"""
    CODE_LENGTH = 4              # 验证码长度
    CODE_EXPIRES = 300           # 验证码过期时间（秒）
    SEND_INTERVAL = 60           # 发送间隔（秒）
    MAX_ATTEMPTS = 5             # 最大尝试次数
    TEST_CODE = "1234"           # 测试验证码
    
    # 错误代码
    CODE_NOT_FOUND = "CODE_NOT_FOUND"           # 验证码不存在
    CODE_EXPIRED = "CODE_EXPIRED"               # 验证码过期
    CODE_INCORRECT = "CODE_INCORRECT"           # 验证码错误
    TOO_MANY_ATTEMPTS = "TOO_MANY_ATTEMPTS"     # 尝试次数过多
    PHONE_MISMATCH = "PHONE_MISMATCH"           # 手机号不匹配
    SEND_TOO_FREQUENT = "SEND_TOO_FREQUENT"     # 发送过于频繁


# ===========================
# 手机号相关常量
# ===========================
class PhoneCode:
    """国际区号"""
    CHINA = "+86"       # 中国
    USA = "+1"          # 美国
    UK = "+44"          # 英国
    JAPAN = "+81"       # 日本
    KOREA = "+82"       # 韩国

    @classmethod
    def get_all(cls) -> dict:
        """获取所有支持的国际区号"""
        return {
            cls.CHINA: "中国 (+86)",
            cls.USA: "美国 (+1)",
            cls.UK: "英国 (+44)",
            cls.JAPAN: "日本 (+81)",
            cls.KOREA: "韩国 (+82)"
        }


# ===========================
# JWT Token 相关常量
# ===========================
class TokenType:
    """Token 类型"""
    ACCESS_TOKEN = "access_token"      # 访问令牌
    REFRESH_TOKEN = "refresh_token"    # 刷新令牌

    # Token 有效期（小时）
    ACCESS_TOKEN_EXPIRE = 24           # 访问令牌24小时
    REFRESH_TOKEN_EXPIRE = 24 * 7      # 刷新令牌7天


# ===========================
# 错误类型常量
# ===========================
class ErrorType:
    """错误类型"""
    VALIDATION_ERROR = "ValidationError"           # 验证错误
    AUTHENTICATION_ERROR = "AuthenticationError"   # 认证错误
    AUTHORIZATION_ERROR = "AuthorizationError"     # 授权错误
    NOT_FOUND_ERROR = "NotFoundError"             # 资源不存在
    CONFLICT_ERROR = "ConflictError"              # 资源冲突
    RATE_LIMIT_ERROR = "RateLimitError"           # 频率限制错误
    SERVER_ERROR = "ServerError"                  # 服务器错误
    DATABASE_ERROR = "DatabaseError"              # 数据库错误
    EXTERNAL_API_ERROR = "ExternalApiError"       # 外部API错误


# ===========================
# 文件上传相关常量
# ===========================
class FileUpload:
    """文件上传常量"""
    # 允许的图片格式
    ALLOWED_IMAGE_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.gif', '.webp'}
    
    # 允许的文件格式
    ALLOWED_FILE_EXTENSIONS = {'.pdf', '.doc', '.docx', '.txt', '.md'}
    
    # 文件大小限制（字节）
    MAX_IMAGE_SIZE = 5 * 1024 * 1024      # 5MB
    MAX_FILE_SIZE = 10 * 1024 * 1024      # 10MB
    
    # 上传目录
    UPLOAD_DIR = "uploads"
    AVATAR_DIR = "uploads/avatars"
    FILE_DIR = "uploads/files"


# ===========================
# 缓存相关常量
# ===========================
class CacheKey:
    """缓存键前缀"""
    USER_INFO = "user:info:"              # 用户信息
    SMS_CODE = "sms:code:"                # 短信验证码
    TOKEN_BLACKLIST = "token:blacklist:"  # Token黑名单
    RATE_LIMIT = "rate:limit:"            # 频率限制

    # 缓存过期时间（秒）
    USER_INFO_EXPIRE = 3600               # 用户信息1小时
    SMS_CODE_EXPIRE = 300                 # 短信验证码5分钟
    TOKEN_EXPIRE = 86400                  # Token 24小时
    RATE_LIMIT_EXPIRE = 3600              # 频率限制1小时


# ===========================
# 正则表达式常量
# ===========================
class RegexPattern:
    """正则表达式模式"""
    # 手机号（中国大陆）
    CHINA_PHONE = r'^1[3-9]\d{9}$'
    
    # 邮箱
    EMAIL = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    
    # 密码（至少8位，包含字母和数字）
    PASSWORD = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$'
    
    # 用户名（字母、数字、下划线，3-20位）
    USERNAME = r'^[a-zA-Z0-9_]{3,20}$'
    
    # ID卡号（身份证）
    ID_CARD = r'^\d{17}[\dXx]$'


# ===========================
# 分页相关常量
# ===========================
class Pagination:
    """分页常量"""
    DEFAULT_PAGE = 1          # 默认页码
    DEFAULT_PAGE_SIZE = 20    # 默认每页数量
    MAX_PAGE_SIZE = 100       # 最大每页数量


# ===========================
# 消息常量
# ===========================
class Message:
    """响应消息常量"""
    # 成功消息
    SUCCESS = "操作成功"
    LOGIN_SUCCESS = "登录成功"
    LOGOUT_SUCCESS = "退出成功"
    REGISTER_SUCCESS = "注册成功"
    UPDATE_SUCCESS = "更新成功"
    DELETE_SUCCESS = "删除成功"
    SEND_SUCCESS = "发送成功"
    
    # 错误消息
    PARAM_ERROR = "参数错误"
    AUTH_FAILED = "认证失败"
    PERMISSION_DENIED = "权限不足"
    USER_NOT_FOUND = "用户不存在"
    USER_DISABLED = "用户已被禁用"
    PHONE_REGISTERED = "手机号已注册"
    INVALID_CODE = "验证码错误"
    CODE_EXPIRED = "验证码已过期"
    TOKEN_EXPIRED = "令牌已过期"
    SERVER_ERROR = "服务器内部错误"
    RATE_LIMIT_EXCEEDED = "请求过于频繁"
    FILE_TOO_LARGE = "文件过大"
    INVALID_FILE_TYPE = "不支持的文件类型"
