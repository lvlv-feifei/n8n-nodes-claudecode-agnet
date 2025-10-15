#!/bin/bash
# 本地安装 n8n 自定义节点脚本

set -e  # 遇到错误时退出

echo "🚀 开始安装 Claude Agent 节点到 n8n..."

# 1. 构建项目
echo ""
echo "📦 步骤 1/4: 构建项目..."
npm run build

# 2. 创建 tarball
echo ""
echo "📦 步骤 2/4: 打包项目..."
npm pack

# 3. 获取生成的 tarball 文件名
TARBALL=$(ls -t lvlv-feifei-n8n-nodes-claudeagent-*.tgz | head -1)
if [ -z "$TARBALL" ]; then
    echo "❌ 错误: 未找到打包文件"
    exit 1
fi
echo "✅ 打包文件: $TARBALL"

# 4. 确保 ~/.n8n/nodes 目录存在
echo ""
echo "📦 步骤 3/4: 检查 n8n 目录..."
mkdir -p ~/.n8n/nodes

# 5. 安装到 n8n
echo ""
echo "📦 步骤 4/4: 安装到 ~/.n8n/nodes..."
cd ~/.n8n/nodes
npm install "$OLDPWD/$TARBALL"

# 6. 清理 tarball
echo ""
echo "🧹 清理临时文件..."
cd "$OLDPWD"
rm -f "$TARBALL"

echo ""
echo "✅ 安装完成!"
echo ""
echo "📝 下一步操作:"
echo "   1. 重启 n8n 服务"
echo "   2. 在 n8n 界面中搜索 'Claude Agent' 节点"
echo "   3. 将节点拖拽到工作流中使用"
echo ""
echo "💡 提示: 如果节点未出现，请检查:"
echo "   - n8n 是否已完全重启"
echo "   - 浏览器缓存是否已清除 (Ctrl+Shift+R)"
echo "   - ~/.n8n/nodes/node_modules/@lvlv-feifei/n8n-nodes-claudeagent 是否存在"
