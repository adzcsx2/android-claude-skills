# Android Remote Sign Configuration

为 Android 项目自动配置远程签名，支持 Groovy DSL 和 Kotlin DSL。

## 自然语言参数解析

用户可以使用自然语言输入，你需要从中提取以下信息：

| 参数 | 提取规则 | 示例 |
|------|----------|------|
| `project_path` | 查找路径格式（以 `/` 开头或包含项目名称） | `/path/to/project`、`~/MyApp`、`当前项目` |
| `modules` | 查找"模块"、"module"等关键词后的名称 | `app_d,app_link`、`app_d 和 app_link` |

### 解析示例

| 用户输入 | 提取结果 |
|----------|----------|
| `/apply-remote-sign` | path=当前目录, modules=无 |
| `/apply-remote-sign 帮我配置 /Users/xxx/MyApp` | path=/Users/xxx/MyApp, modules=无 |
| `配置 /path/to/project，包含 app_d 和 app_link 模块` | path=/path/to/project, modules=app_d,app_link |
| `给当前目录的 Android 项目配置远程签名` | path=当前目录, modules=无 |
| `/apply-remote-sign ~/Documents/MyApp --modules app_d` | path=~/Documents/MyApp, modules=app_d |

## Step 1: 解析用户输入

1. 从用户输入中提取项目路径
   - 如果包含路径（以 `/`、`~`、`./` 开头），使用该路径
   - 如果提到"当前项目"、"当前目录"，使用工作目录
   - 如果没有明确路径，使用当前工作目录

2. 从用户输入中提取模块名称
   - 查找 `--modules` 参数
   - 查找"模块"、"module"、"包含"等关键词后的名称
   - 多个模块用逗号连接

## Step 2: 验证项目路径

1. 展开路径中的 `~` 为用户主目录
2. 将相对路径转换为绝对路径
3. 检查目录是否为有效的 Android 项目（存在 `build.gradle` 或 `build.gradle.kts` 或 `settings.gradle`）
4. 如果不是有效项目，提示用户并询问是否继续

## Step 3: 构建执行命令

工具路径（skill 内置）: `$HOME/.claude/skills/apply-remote-sign/AndroidAutoRemoteSignTool`

基本命令格式:
```bash
python "$HOME/.claude/skills/apply-remote-sign/AndroidAutoRemoteSignTool/remote_sign/apply_remote_sign.py" --project-path "{project_path}"
```

如果用户指定了额外模块:
```bash
python "$HOME/.claude/skills/apply-remote-sign/AndroidAutoRemoteSignTool/remote_sign/apply_remote_sign.py" --project-path "{project_path}" --modules "{modules}"
```

## Step 4: 执行配置

1. 使用 Bash 工具执行命令
2. 捕获并显示输出
3. 检查执行结果

## Step 5: 配置后提示

配置完成后，提示用户：
1. 复制 `.env.example` 为 `.env` 并填入 SIGN_TOKEN
2. 使用 `python scripts/build.py assembleDebug` 构建项目
3. 检查 `build.gradle` 或 `build.gradle.kts` 的修改内容

## 支持的输入格式

```
# 简洁格式
/apply-remote-sign
/apply-remote-sign /path/to/project
/apply-remote-sign /path/to/project --modules app_d,app_link

# 自然语言格式
/apply-remote-sign 帮我配置 /path/to/project
/apply-remote-sign 给 /Users/xxx/MyApp 配置远程签名
/apply-remote-sign 配置当前项目的远程签名
/apply-remote-sign 帮我配置 ~/Documents/MyApp，包含 app_d 和 app_link 模块
```

## 注意事项

- 配置前建议先提交 Git，以便回滚
- 签名 Token 需要单独配置
- 首次使用需安装 Python requests 库
