# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个 n8n 社区节点包，集成了 Claude Agent SDK，允许在 n8n 工作流中使用 AI 驱动的编程任务。该节点支持会话管理、工具权限控制、系统提示词定制和多目录访问控制。

## 核心能力

### ClaudeAgent 节点 (ClaudeAgent.node.ts)

**会话管理**
- **New Query**: 启动新的 AI 对话会话
- **Continue**: 继续最近的会话（自动关联上一次 session_id）
- **Resume**: 通过 session_id 恢复特定历史会话
- **Fork**: 从某个会话分叉出新的会话分支

**模型选择**
- **Sonnet**: Claude Sonnet 4.5 (默认) - 快速高效的最新模型
- **Opus**: 最强大的模型，适合复杂任务
- **Haiku**: 最快速且最具成本效益的模型

**权限模式**
- **Bypass All**: 无需确认，全自动执行（推荐用于 n8n）
- **Accept Edits**: 自动接受文件编辑
- **Ask Always**: 每次操作都需要确认
- **Plan Mode**: 先规划再执行

**系统提示词**
- **Default**: 使用 Claude Agent 预设
- **Append**: 在默认提示词基础上追加自定义指令（必填）
- **Custom**: 完全自定义系统提示词（必填）

**工具权限控制**
- 允许工具白名单 (allowedTools)
- 禁止工具黑名单 (disallowedTools)
- 支持 10+ 种内置工具：Bash、Edit、Glob、Grep、Read、Write、Task、TodoWrite、WebFetch、WebSearch

**多目录访问**
- 通过 fixedCollection 类型配置多个额外目录
- 每个目录独立的路径输入框
- 支持动态添加/删除目录

**输出格式**
- **Summary**: 关键指标和结果（推荐）- 包含 session_id、成功状态、耗时、成本、token 使用量
- **Full**: 完整对话，包含所有消息和时间线
- **Text Only**: 仅返回最终结果文本

**高级选项**
- Fallback Model: 主模型过载时的备用模型
- Max Thinking Tokens: 限制扩展思考的 token 数量
- Debug Mode: 启用详细日志
- Include Stream Events: 包含实时流式事件（仅 Full 格式）

## 本地开发与安装

### 快速安装

```bash
# 一键安装到本地 n8n
./install-local.sh
```

### 安装流程详解

**步骤 1: 构建项目**
```bash
npm run build
# 执行: format:check → 清理 dist → TypeScript 编译 → 复制图标 → 复制模式文件
```

**步骤 2: 打包项目**
```bash
npm pack
# 生成: lvlv-feifei-n8n-nodes-claudecode-1.0.0.tgz (~41 KB)
```

**步骤 3: 安装到 n8n**
```bash
mkdir -p ~/.n8n/nodes
cd ~/.n8n/nodes
npm install <项目路径>/lvlv-feifei-n8n-nodes-claudecode-1.0.0.tgz
```

**步骤 4: 验证安装**
```bash
ls ~/.n8n/nodes/node_modules/@lvlv-feifei/n8n-nodes-claudecode/dist/nodes/
# 应包含: ClaudeAgent/ 和 ClaudeCode/
```

**步骤 5: 重启 n8n**
- 完全停止 n8n 服务
- 重新启动 n8n
- 清除浏览器缓存 (Ctrl+Shift+R / Cmd+Shift+R)

### 开发命令

```bash
# 构建（格式检查 + 编译 + 资源复制）
npm run build

# 开发模式（TypeScript 监听编译）
npm run dev

# 代码格式化
npm run format
npm run format:check

# 代码检查
npm run lint
npm run lintfix

# 规范化提交
npm run commit

# 本地安装到 n8n
./install-local.sh
```

## 项目结构

```
nodes/ClaudeAgent/
├── ClaudeAgent.node.ts          # 主节点实现
├── claudeagent.svg              # 节点图标
└── __schema__/v2.0.0/           # JSON 模式文件
    ├── query.json               # New Query 操作
    ├── continue.json            # Continue 操作
    ├── resume.json              # Resume 操作
    └── fork.json                # Fork 操作

nodes/ClaudeCode/                # 旧节点（向后兼容）
```

## 技术栈

**运行时依赖**
- `@anthropic-ai/claude-agent-sdk` ^2.0.8 - Claude Agent SDK
- `n8n-workflow` - n8n 核心工作流库

**开发依赖**
- TypeScript 5.8.2 - 类型安全编译
- ESLint + n8n 插件 - 代码质量检查
- Prettier - 代码格式化
- Gulp - 构建资源文件
- Semantic Release - 自动化发布

**编译配置**
- 目标: ES2019
- 模块: CommonJS
- 严格模式: 完全启用
- 输出: dist/

## 开发注意事项

### 参数验证
- 条件必填字段使用 `required: true` + `displayOptions.show`
- 例如：System Prompt 在 append/custom 模式下必填

### 参数类型选择
- 列表数据优先使用 `fixedCollection` 而非逗号分隔字符串
- 例如：additionalDirectories 使用 fixedCollection 提供更好的 UX

### n8n 节点规范
- 修改节点定义后必须运行 `npm run build`
- 图标和模式文件通过 Gulp 任务复制到 dist/
- 版本化模式放在 `__schema__/vX.Y.Z/` 目录
- 使用 `pairedItem` 维护节点间的数据关联

### 代码提交
- 使用 `npm run commit` 遵循 conventional commits 规范
- 提交前运行 `npm run format:check` 和 `npm run lint`

### 测试流程
1. 修改代码
2. 运行 `./install-local.sh`
3. 完全重启 n8n
4. 清除浏览器缓存
5. 在 n8n 界面测试

## SDK 升级说明

从 Claude Code SDK 1.0.90 升级到 Claude Agent SDK 0.1.10：

**主要变化**
- Sonnet 模型默认使用 Claude Sonnet 4.5 (claude-sonnet-4-5-20250929)
- `systemPrompt` 更名为 `appendSystemPrompt`
- 新增 `customSystemPrompt` 选项
- 新增 `supportedModels()` API
- `abortController` 移至 `options` 内部

**向后兼容**
- 保留 ClaudeCode 节点以支持现有工作流
- ClaudeAgent 节点为新版本，提供更多功能


- 在遇到不确定的内容时，需要回复不确定。此外应该基于代码事实而不是推断进行思考
