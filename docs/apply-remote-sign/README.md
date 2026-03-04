# Android Remote Sign Skill

此 skill 为 Android 项目自动配置远程签名，支持 Groovy DSL (build.gradle) 和 Kotlin DSL (build.gradle.kts)。

**内置工具**：AndroidAutoRemoteSignTool 已内置在 skill 中，无需额外配置路径。

## 安装方法

### 一键安装（推荐）

```bash
# 复制整个 skill 目录到全局配置
cp -r docs/apply-remote-sign ~/.claude/skills/apply-remote-sign

# 复制 command 文件
cp docs/apply-remote-sign/COMMAND.md ~/.claude/commands/apply-remote-sign.md
```

### 项目级别安装

```bash
# 复制到项目的 .claude 目录
cp -r docs/apply-remote-sign .claude/skills/apply-remote-sign
cp docs/apply-remote-sign/COMMAND.md .claude/commands/apply-remote-sign.md
```

## 使用方法

安装完成后，可以在 Claude Code 中使用以下命令：

```bash
# 简洁格式
/apply-remote-sign
/apply-remote-sign /path/to/android/project
/apply-remote-sign /path/to/project --modules app_d,app_link

# 自然语言格式
/apply-remote-sign 帮我配置 /path/to/project
/apply-remote-sign 给 ~/Documents/MyApp 配置远程签名
/apply-remote-sign 配置当前项目的远程签名
/apply-remote-sign 帮我配置 /path/to/project，包含 app_d 和 app_link 模块
```

## 功能说明

此 skill 会自动完成以下配置：

1. 创建 `.env.example` 环境变量模板
2. 更新 `.gitignore` 文件
3. 更新 `gradle.properties` 添加 AGP 配置
4. 修改模块的 `build.gradle` 或 `build.gradle.kts` 集成远程签名任务
5. 复制运行时脚本到项目的 `scripts/` 目录

## 依赖要求

- Python 3.6+
- `requests` 库（`pip install requests`）
- JDK 11
- Android SDK

## 文件结构

```
docs/apply-remote-sign/
├── SKILL.md                    # Skill 定义文件
├── COMMAND.md                  # Command 定义文件
├── README.md                   # 安装说明
└── AndroidAutoRemoteSignTool/  # 内置工具（内置）
    ├── remote_sign/
    │   ├── apply_remote_sign.py
    │   ├── apply_groovy_sign.py
    │   ├── apply_kts_sign.py
    │   ├── sign_apk.py
    │   ├── build.py
    │   └── config_tool.py
    ├── README.md
    └── README.en.md
```
