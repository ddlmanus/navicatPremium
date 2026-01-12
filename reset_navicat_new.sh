#!/bin/bash
# Navicat Premium 重置试用期脚本 - 适配 v15/v16/v17
# 原理：删除 plist、Keychain 和隐藏文件中的试用验证数据

set -e

echo "=========================================="
echo "   Navicat Premium 试用期重置工具 v2.0"
echo "=========================================="

# 检测 Navicat 版本
if [ -d "/Applications/Navicat Premium.app" ]; then
    version=$(defaults read "/Applications/Navicat Premium.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null)
    major_version=$(echo "$version" | cut -d. -f1)
    echo "✓ 检测到 Navicat Premium 版本: $version"
else
    echo "✗ 未找到 Navicat Premium，请确保已安装"
    exit 1
fi

# 检查并强制退出 Navicat
echo ""
echo "检查 Navicat 运行状态..."
if pgrep -x "Navicat Premium" > /dev/null; then
    echo "⚠ Navicat Premium 正在运行，正在强制退出..."
    pkill -x "Navicat Premium"
    sleep 2
    echo "✓ Navicat Premium 已退出"
else
    echo "✓ Navicat Premium 未在运行"
fi

# 确定 plist 文件路径
case $major_version in
    "17"|"16")
        plist_file=~/Library/Preferences/com.navicat.NavicatPremium.plist
        keychain_service="com.navicat.NavicatPremium"
        ;;
    "15")
        plist_file=~/Library/Preferences/com.prect.NavicatPremium15.plist
        keychain_service="com.prect.NavicatPremium15"
        ;;
    *)
        echo "✗ 不支持的版本: $major_version"
        exit 1
        ;;
esac

echo "✓ plist 文件: $plist_file"

# 刷新 cfprefsd 缓存确保 plist 修改生效
echo ""
echo "刷新系统缓存..."
killall cfprefsd 2>/dev/null || true
sleep 1
echo "✓ 缓存已刷新"

# 删除 plist 中的试用验证 key
echo ""
echo "正在删除 plist 试用验证数据..."

if [ -f "$plist_file" ]; then
    # 预定义的试用验证 key（包括 v16 和 v17 已知的 key）
    known_keys=(
        "014BF4EC24C114BEF46E1587042B3619"
        "91F6C435D172C8163E0689D3DAD3F3E9"
        "B966DBD409B87EF577C9BBF3363E9614"
    )
    
    for key in "${known_keys[@]}"; do
        if /usr/libexec/PlistBuddy -c "Delete :$key" "$plist_file" 2>/dev/null; then
            echo "  ✓ 已删除 key: $key"
        fi
    done
    
    # 动态查找并删除所有 32 位哈希值格式的顶级 key
    while IFS= read -r key; do
        if [[ $key =~ ^[0-9A-F]{32}$ ]]; then
            if /usr/libexec/PlistBuddy -c "Delete :$key" "$plist_file" 2>/dev/null; then
                echo "  ✓ 已删除动态 key: $key"
            fi
        fi
    done < <(/usr/libexec/PlistBuddy -c "Print" "$plist_file" 2>/dev/null | grep -E "^    [0-9A-F]{32} = " | awk '{print $1}')
else
    echo "  ⚠ plist 文件不存在，跳过"
fi

# 删除 Keychain 中的试用期验证条目
echo ""
echo "正在删除 Keychain 试用验证数据..."

# 查找并删除所有与 Navicat 相关的 32 位哈希格式的 Keychain 条目
keychain_accounts=$(security dump-keychain 2>/dev/null | grep -B20 "svce.*\"$keychain_service\"" | grep "acct" | sed 's/.*=\"\([^\"]*\)\".*/\1/' | grep -E "^[0-9A-F]{32}$" || true)

if [ ! -z "$keychain_accounts" ]; then
    for account in $keychain_accounts; do
        if security delete-generic-password -s "$keychain_service" -a "$account" 2>/dev/null; then
            echo "  ✓ 已删除 Keychain 条目: $account"
        fi
    done
else
    echo "  ⚠ 未找到需要删除的 Keychain 条目"
fi

# 删除隐藏文件
hidden_dir=~/Library/Application\ Support/PremiumSoft\ CyberTech/Navicat\ CC/Navicat\ Premium

echo ""
echo "正在删除隐藏文件..."

if [ -d "$hidden_dir" ]; then
    # 删除所有 . 开头的隐藏文件（排除 . 和 ..）
    for file in "$hidden_dir"/.[0-9A-Z]*; do
        if [ -f "$file" ]; then
            rm -f "$file"
            echo "  ✓ 已删除: $(basename "$file")"
        fi
    done
else
    echo "  ⚠ 隐藏文件目录不存在，跳过"
fi

# 再次刷新缓存
echo ""
echo "再次刷新系统缓存..."
killall cfprefsd 2>/dev/null || true
defaults read "$plist_file" > /dev/null 2>&1 || true
echo "✓ 缓存已刷新"

echo ""
echo "=========================================="
echo "✓ 重置完成！"
echo ""
echo "【重要】请等待 5 秒后再打开 Navicat Premium"
echo "=========================================="
