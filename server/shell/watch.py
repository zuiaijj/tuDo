#!/usr/bin/env python3
"""
TuDo 高级文件监控启动脚本
使用 watchdog 库实现精细的文件监控和热重载
需要安装: pip install watchdog
"""
import sys
import os
import time
import subprocess
import signal
from pathlib import Path

# 获取脚本所在目录和server目录的绝对路径
script_dir = os.path.dirname(os.path.abspath(__file__))
server_dir = os.path.dirname(script_dir)

try:
    from watchdog.observers import Observer
    from watchdog.events import FileSystemEventHandler
except ImportError:
    print("❌ 需要安装 watchdog 库:")
    print("   pip install watchdog")
    sys.exit(1)

class CodeChangeHandler(FileSystemEventHandler):
    """代码变更处理器"""
    
    def __init__(self, restart_callback):
        self.restart_callback = restart_callback
        self.last_restart = 0
        self.restart_delay = 1  # 防抖延迟（秒）
        
    def on_modified(self, event):
        if event.is_directory:
            return
            
        # 只监控 Python 文件
        if not event.src_path.endswith('.py'):
            return
            
        # 防抖处理
        current_time = time.time()
        if current_time - self.last_restart < self.restart_delay:
            return
            
        print(f"🔄 检测到文件变更: {event.src_path}")
        self.last_restart = current_time
        self.restart_callback()

class ServerManager:
    """服务器管理器"""
    
    def __init__(self):
        self.process = None
        self.observer = None
        
    def start_server(self):
        """启动服务器"""
        if self.process:
            self.stop_server()
            
        print("🚀 启动服务器...")
        self.process = subprocess.Popen([
            sys.executable, 
            os.path.join(script_dir, "run.py")
        ], cwd=server_dir)
        
    def stop_server(self):
        """停止服务器"""
        if self.process:
            print("🛑 停止服务器...")
            self.process.terminate()
            try:
                self.process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.process.kill()
            self.process = None
            
    def restart_server(self):
        """重启服务器"""
        print("🔄 重启服务器...")
        self.stop_server()
        time.sleep(0.5)  # 等待端口释放
        self.start_server()
        
    def start_watching(self):
        """开始文件监控"""
        print("👀 开始监控文件变更...")
        
        # 监控的目录
        watch_dirs = [
            os.path.join(server_dir, "app"),
            os.path.join(server_dir, "shell"),
        ]
        
        handler = CodeChangeHandler(self.restart_server)
        self.observer = Observer()
        
        for watch_dir in watch_dirs:
            if os.path.exists(watch_dir):
                self.observer.schedule(handler, watch_dir, recursive=True)
                print(f"📁 监控目录: {watch_dir}")
                
        self.observer.start()
        
    def stop_watching(self):
        """停止文件监控"""
        if self.observer:
            self.observer.stop()
            self.observer.join()
            
    def run(self):
        """运行服务器管理器"""
        print("🔥 TuDo 高级热重载服务器")
        print("=" * 50)
        print("💡 功能:")
        print("   - 自动监控 Python 文件变更")
        print("   - 智能防抖重启")
        print("   - 优雅的进程管理")
        print("=" * 50)
        
        try:
            self.start_server()
            self.start_watching()
            
            print("✅ 服务器已启动，正在监控文件变更...")
            print("💡 按 Ctrl+C 停止服务器")
            
            # 保持运行
            while True:
                time.sleep(1)
                
        except KeyboardInterrupt:
            print("\n🛑 正在关闭...")
        finally:
            self.stop_watching()
            self.stop_server()
            print("✅ 已完全关闭")

def main():
    """主函数"""
    manager = ServerManager()
    
    # 注册信号处理器
    def signal_handler(signum, frame):
        manager.stop_watching()
        manager.stop_server()
        sys.exit(0)
        
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    manager.run()

if __name__ == "__main__":
    main() 