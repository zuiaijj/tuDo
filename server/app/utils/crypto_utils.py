#!/usr/bin/env python3
"""
加密解密工具模块
提供RSA和AES加密解密功能，支持手机号等敏感信息的加密处理
"""

import os
import base64
import hashlib
from typing import Optional
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives import padding, serialization, hashes
from cryptography.hazmat.primitives.asymmetric import padding as rsa_padding
from cryptography.hazmat.primitives.asymmetric.rsa import RSAPublicKey, RSAPrivateKey
from cryptography.hazmat.backends import default_backend


class CryptoConfig:
    """加密配置类"""
    
    # 密钥文件路径
    PUBLIC_KEY_PATH = os.getenv('PUBLIC_KEY_PATH', 'keys/phone/public/phone_encryption_public_key.pem')
    PRIVATE_KEY_PATH = os.getenv('PRIVATE_KEY_PATH', 'keys/phone/private/phone_decryption_private_key.pem')
    
    # 私钥密码
    PRIVATE_KEY_PASSWORD = os.getenv('PHONE_PRIVATE_KEY_PASSWORD', "maketodu")
    
    # AES密钥（用于对称加密）
    AES_KEY = os.getenv('AES_ENCRYPTION_KEY', 'UVsSl962H2B5I1ET')


class KeyLoader:
    """密钥加载器"""
    
    @staticmethod
    def load_public_key() -> str:
        """从文件加载公钥"""
        try:
            with open(CryptoConfig.PUBLIC_KEY_PATH, 'r') as f:
                return f.read()
        except FileNotFoundError:
            raise FileNotFoundError(f"公钥文件不存在: {CryptoConfig.PUBLIC_KEY_PATH}")
    
    @staticmethod
    def load_private_key() -> str:
        """从文件加载私钥"""
        try:
            with open(CryptoConfig.PRIVATE_KEY_PATH, 'r') as f:
                return f.read()
        except FileNotFoundError:
            raise FileNotFoundError(f"私钥文件不存在: {CryptoConfig.PRIVATE_KEY_PATH}")


class AESCrypto:
    """AES对称加密工具类"""
    
    @staticmethod
    def get_encryption_key() -> bytes:
        """获取32字节的AES加密密钥"""
        key = CryptoConfig.AES_KEY.encode('utf-8')
        if len(key) < 32:
            # 如果密钥不足32字节，用0填充
            key = key + b'\0' * (32 - len(key))
        elif len(key) > 32:
            # 如果密钥超过32字节，截取前32字节
            key = key[:32]
        return key
    
    @staticmethod
    def encrypt(plaintext: str) -> str:
        """
        使用AES加密文本
        
        Args:
            plaintext: 明文
            
        Returns:
            str: 加密后的base64编码字符串
        """
        try:
            # 使用明文的MD5作为IV，确保相同明文产生相同的加密结果
            iv = hashlib.md5(plaintext.encode()).digest()
            
            # 创建加密器
            cipher = Cipher(
                algorithms.AES(AESCrypto.get_encryption_key()),
                modes.CBC(iv),
                backend=default_backend()
            )
            encryptor = cipher.encryptor()
            
            # 添加填充
            padder = padding.PKCS7(128).padder()
            padded_data = padder.update(plaintext.encode('utf-8')) + padder.finalize()
            
            # 加密
            encrypted_data = encryptor.update(padded_data) + encryptor.finalize()
            
            # 返回base64编码的结果
            return base64.b64encode(encrypted_data).decode('utf-8')
        except Exception as e:
            # 如果加密失败，使用简单的base64编码作为备选方案
            return base64.b64encode(plaintext.encode('utf-8')).decode('utf-8')
    
    @staticmethod
    def decrypt(encrypted_text: str, original_text: str) -> str:
        """
        使用AES解密文本
        
        Args:
            encrypted_text: 加密后的文本
            original_text: 原始文本（用于生成IV）
            
        Returns:
            str: 解密后的明文
        """
        try:
            # 使用原始文本生成相同的IV
            iv = hashlib.md5(original_text.encode()).digest()
            
            # 解码base64
            encrypted_data = base64.b64decode(encrypted_text.encode('utf-8'))
            
            # 创建解密器
            cipher = Cipher(
                algorithms.AES(AESCrypto.get_encryption_key()),
                modes.CBC(iv),
                backend=default_backend()
            )
            decryptor = cipher.decryptor()
            
            # 解密
            padded_data = decryptor.update(encrypted_data) + decryptor.finalize()
            
            # 去除填充
            unpadder = padding.PKCS7(128).unpadder()
            data = unpadder.update(padded_data) + unpadder.finalize()
            
            return data.decode('utf-8')
        except Exception:
            return "***解密失败***"


class RSACrypto:
    """RSA非对称加密工具类"""
    
    @staticmethod
    def encrypt(plaintext: str) -> str:
        """
        使用RSA公钥加密文本
        
        Args:
            plaintext: 明文
            
        Returns:
            str: 加密后的base64编码字符串
        """
        try:
            # 解析公钥
            public_key = serialization.load_pem_public_key(
                KeyLoader.load_public_key().encode('utf-8'),
                backend=default_backend()
            )
            
            # 确保是RSA公钥
            if not isinstance(public_key, RSAPublicKey):
                raise ValueError("提供的密钥不是RSA公钥")
            
            # 使用RSA公钥加密
            encrypted = public_key.encrypt(
                plaintext.encode('utf-8'),
                rsa_padding.OAEP(
                    mgf=rsa_padding.MGF1(algorithm=hashes.SHA256()),
                    algorithm=hashes.SHA256(),
                    label=None
                )
            )
            
            # 返回base64编码的结果
            return base64.b64encode(encrypted).decode('utf-8')
        except Exception as e:
            print(f"RSA加密失败: {e}")
            # 如果RSA加密失败，使用简单的base64编码作为备选方案
            return base64.b64encode(plaintext.encode('utf-8')).decode('utf-8')
    
    @staticmethod
    def decrypt(encrypted_text: str) -> str:
        """
        使用RSA私钥解密文本
        
        Args:
            encrypted_text: 加密后的文本
            
        Returns:
            str: 解密后的明文
        """
        try:
            # 解码base64
            encrypted_data = base64.b64decode(encrypted_text.encode('utf-8'))
            
            # 解析私钥（加密的私钥需要密码）
            password_bytes = CryptoConfig.PRIVATE_KEY_PASSWORD.encode('utf-8') if CryptoConfig.PRIVATE_KEY_PASSWORD else None
            
            private_key = serialization.load_pem_private_key(
                KeyLoader.load_private_key().encode('utf-8'),
                password=password_bytes,
                backend=default_backend()
            )
            
            # 确保是RSA私钥
            if not isinstance(private_key, RSAPrivateKey):
                raise ValueError("提供的密钥不是RSA私钥")
            
            # 使用RSA私钥解密
            decrypted = private_key.decrypt(
                encrypted_data,
                rsa_padding.PKCS1v15()
            )
            
            return decrypted.decode('utf-8')
        except Exception as e:
            print(f"RSA解密失败: {e}")
            return "***解密失败***"


class PhoneCrypto:
    """手机号加密工具类"""
    
    @staticmethod
    def encrypt(phone: str) -> str:
        """
        加密手机号（使用RSA）
        
        Args:
            phone: 明文手机号
            
        Returns:
            str: 加密后的手机号
        """
        return RSACrypto.encrypt(phone)
    
    @staticmethod
    def decrypt(encrypted_phone: str) -> str:
        """
        解密手机号（使用RSA）
        
        Args:
            encrypted_phone: 加密后的手机号
            
        Returns:
            str: 明文手机号
        """
        return RSACrypto.decrypt(encrypted_phone)
    
    @staticmethod
    def get_display_phone(phone_last_four: str) -> str:
        """
        获取手机号显示格式（显示后四位）
        
        Args:
            phone_last_four: 手机号后四位
            
        Returns:
            str: 手机号显示格式
        """
        return f"****{phone_last_four}"
    
    @staticmethod
    def get_last_four_digits(phone: str) -> str:
        """
        获取手机号后四位
        
        Args:
            phone: 完整手机号
            
        Returns:
            str: 手机号后四位
        """
        return phone[-4:] if len(phone) >= 4 else phone


class CryptoUtils:
    """加密工具统一入口类"""
    
    # 静态实例
    aes = AESCrypto()
    rsa = RSACrypto()
    phone = PhoneCrypto()
    
    @staticmethod
    def check_key_files() -> dict:
        """
        检查密钥文件是否存在
        
        Returns:
            dict: 检查结果
        """
        result = {
            'public_key_exists': os.path.exists(CryptoConfig.PUBLIC_KEY_PATH),
            'private_key_exists': os.path.exists(CryptoConfig.PRIVATE_KEY_PATH),
            'public_key_path': CryptoConfig.PUBLIC_KEY_PATH,
            'private_key_path': CryptoConfig.PRIVATE_KEY_PATH
        }
        return result