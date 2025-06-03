#!/bin/bash

# Google Sheet 文档ID
SHEET_ID="1--1MD88tqKlWgrzjRGPcueWpbxElo7Cex4RxDaqwZcw"
DOWNLOAD_URL="https://docs.google.com/spreadsheets/d/${SHEET_ID}/export?format=xlsx"

# 生成当前时间戳
TIME_STR=$(date +"%Y-%m-%d-%H-%M")
EXCEL_FILE="origin/${TIME_STR}.xlsx"

# 获取当前脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)

# 保证origin目录下只保留一个excel文件
find origin/ -maxdepth 1 -name "*.xlsx" -type f -delete

# 下载 Google Sheets 表格
echo "正在下载最新多语言表..."
curl -L -o "$EXCEL_FILE" "$DOWNLOAD_URL"
if [ $? -ne 0 ]; then
  echo "下载表格失败，请检查网络或权限"
  exit 1
fi

echo "下载完成，调整sheet顺序..."
python3 "$SCRIPT_DIR/handle_intl_sheet.py" "$EXCEL_FILE"
if [ $? -ne 0 ]; then
  echo "调整sheet顺序失败"
  exit 1
fi

echo "开始执行多语言更新..."

# 执行translate命令
./translate 2 "$EXCEL_FILE"
if [ $? -ne 0 ]; then
  echo "多语言文件更新失败，请检查错误信息"
  exit 1
fi

echo "translate命令执行成功，开始复制文件..."

# 确保目标目录存在
mkdir -p ../lib/l10n

# 复制origin下的.arb文件到lib/l10n目录
echo "复制origin下的.arb文件到lib/l10n目录..."
cp -f origin/*.arb ../lib/l10n/
if [ $? -ne 0 ]; then
  echo "复制.arb文件失败"
  exit 1
fi

# 复制zh_TW文件到HK和MO
echo "复制zh_TW文件到HK和MO..."
if [ -f "../lib/l10n/intl_zh_TW.arb" ]; then
  cp -f ../lib/l10n/intl_zh_TW.arb ../lib/l10n/intl_zh_HK.arb
  cp -f ../lib/l10n/intl_zh_TW.arb ../lib/l10n/intl_zh_MO.arb
  echo "复制完成"
else
  echo "警告: ../lib/l10n/intl_zh_TW.arb文件不存在，无法创建HK和MO版本"
fi

# 执行intl_utils命令
echo "执行intl_utils命令生成代码..."
cd ..
flutter pub global run intl_utils:generate

if [ $? -ne 0 ]; then
  echo "intl_utils命令执行失败"
  exit 1
fi

echo "多语言文件更新完成!"
