import asyncio
import random
import time
from typing import Dict, Optional, Any
from datetime import datetime, timedelta

class SmsService:
    """
    短信服务类 - 模拟短信发送和验证码管理
    
    在开发阶段，我们使用内存存储验证码
    生产环境建议使用Redis等缓存系统
    """
    
    def __init__(self):
        # 内存存储验证码 {phone: {"code": "1234", "expires": timestamp, "attempts": 0}}
        self._codes: Dict[str, Dict] = {}
        # 发送频率限制 {phone: last_send_time}
        self._send_limits: Dict[str, float] = {}
        
        # 配置
        self.CODE_LENGTH = 4  # 验证码长度
        self.CODE_EXPIRES = 300  # 验证码过期时间（秒）
        self.SEND_INTERVAL = 60  # 发送间隔（秒）
        self.MAX_ATTEMPTS = 5  # 最大尝试次数
        self.TEST_CODE = "1234"  # 测试验证码
    
    def _generate_code(self) -> str:
        """生成随机验证码"""
        return ''.join([str(random.randint(0, 9)) for _ in range(self.CODE_LENGTH)])
    
    def _is_test_phone(self, phone: str) -> bool:
        """判断是否为测试手机号"""
        # 测试手机号：以188开头的11位号码
        return phone.startswith('188') and len(phone) == 11
    
    async def send_sms_code(self, phone: str, dial_code: str) -> Dict[str, Any]:
        """
        发送短信验证码
        
        Args:
            phone: 手机号
            dial_code: 国际区号
            
        Returns:
            dict: 发送结果
            
        Raises:
            ValueError: 发送失败时抛出异常
        """
        current_time = time.time()
        full_phone = f"{dial_code}{phone}"
        # 检查发送频率限制
        if full_phone in self._send_limits:
            last_send_time = self._send_limits[full_phone]
            if current_time - last_send_time < self.SEND_INTERVAL:
                remaining = int(self.SEND_INTERVAL - (current_time - last_send_time))
                raise ValueError(f"发送过于频繁，请等待 {remaining} 秒后再试")
        
        # 生成验证码
        if self._is_test_phone(full_phone):
            # 测试手机号使用固定验证码
            code = self.TEST_CODE
        else:
            # 正式手机号生成随机验证码
            code = self._generate_code()
        
        # 存储验证码
        self._codes[full_phone] = {
            "code": code,
            "expires": current_time + self.CODE_EXPIRES,
            "attempts": 0,
            "created_at": datetime.now().isoformat()
        }
        
        # 更新发送时间
        self._send_limits[full_phone] = current_time
        
        # 模拟发送短信
        await self._simulate_send_sms(full_phone, code)
        
        return {
            "success": True,
            "message": "验证码发送成功",
            "phone_display": f"****{phone[-4:]}",
            "expires_in": self.CODE_EXPIRES,
            "test_mode": self._is_test_phone(full_phone),
            "code": code 
        }
    
    async def _simulate_send_sms(self, phone: str, code: str):
        """
        模拟发送短信
        
        Args:
            phone: 手机号
            code: 验证码
            dial_code: 国际区号
        """
        # 模拟网络延迟
        await asyncio.sleep(0.1)
        # 在开发环境下打印验证码到控制台
        print(f"📱 模拟短信发送:")
        print(f"   手机号: {phone}")
        print(f"   验证码: {code}")
        print(f"   有效期: {self.CODE_EXPIRES}秒")
        
        if self._is_test_phone(phone):
            print(f"   🧪 测试模式: 固定验证码 {self.TEST_CODE}")
        
        print("-" * 40)
    
    def verify_sms_code(self, phone: str, dial_code: str, code: str) -> Dict[str, Any]:
        """
        验证短信验证码
        
        Args:
            phone: 手机号
            dial_code: 国际区号
            code: 验证码
            
        Returns:
            dict: 验证结果
        """
        current_time = time.time()
        full_phone = f"{dial_code}{phone}"
        # 检查验证码是否存在
        if full_phone not in self._codes:
            return {
                "success": False,
                "message": "验证码不存在或已过期，请重新获取",
                "error_code": "CODE_NOT_FOUND"
            }
        
        code_info = self._codes[full_phone]
        
        # 检查验证码是否过期
        if current_time > code_info["expires"]:
            # 清理过期验证码
            del self._codes[full_phone]
            return {
                "success": False,
                "message": "验证码已过期，请重新获取",
                "error_code": "CODE_EXPIRED"
            }
        
        # 检查尝试次数
        if code_info["attempts"] >= self.MAX_ATTEMPTS:
            # 清理验证码
            del self._codes[full_phone]
            return {
                "success": False,
                "message": "验证码尝试次数过多，请重新获取",
                "error_code": "TOO_MANY_ATTEMPTS"
            }
        
        # 增加尝试次数
        code_info["attempts"] += 1
        
        # 验证验证码
        if code_info["code"] == code:
            # 验证成功，清理验证码
            del self._codes[full_phone]
            return {
                "success": True,
                "message": "验证码验证成功"
            }
        else:
            # 验证失败
            remaining_attempts = self.MAX_ATTEMPTS - code_info["attempts"]
            return {
                "success": False,
                "message": f"验证码错误，还可尝试 {remaining_attempts} 次",
                "error_code": "CODE_INCORRECT",
                "remaining_attempts": remaining_attempts
            }
    
    def get_code_info(self, phone: str) -> Optional[Dict[str, Any]]:
        """
        获取验证码信息（调试用）
        
        Args:
            phone: 手机号
            
        Returns:
            dict: 验证码信息
        """
        if phone not in self._codes:
            return None
        
        code_info = self._codes[phone]
        current_time = time.time()
        
        return {
            "phone": phone,
            "code": code_info["code"],
            "created_at": code_info["created_at"],
            "expires_in": max(0, int(code_info["expires"] - current_time)),
            "attempts": code_info["attempts"],
            "max_attempts": self.MAX_ATTEMPTS,
            "is_expired": current_time > code_info["expires"]
        }
    
    def cleanup_expired_codes(self):
        """清理过期的验证码"""
        current_time = time.time()
        expired_phones = []
        
        for phone, code_info in self._codes.items():
            if current_time > code_info["expires"]:
                expired_phones.append(phone)
        
        for phone in expired_phones:
            del self._codes[phone]
        
        return len(expired_phones)
    
    def get_stats(self) -> Dict[str, Any]:
        """获取服务统计信息"""
        current_time = time.time()
        active_codes = 0
        expired_codes = 0
        
        for code_info in self._codes.values():
            if current_time <= code_info["expires"]:
                active_codes += 1
            else:
                expired_codes += 1
        
        return {
            "active_codes": active_codes,
            "expired_codes": expired_codes,
            "total_codes": len(self._codes),
            "send_limits": len(self._send_limits)
        }

# 创建全局短信服务实例
sms_service = SmsService() 