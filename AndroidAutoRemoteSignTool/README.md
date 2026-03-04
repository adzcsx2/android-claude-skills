# Android Auto Remote Sign Tool

Android APK 远程自动签名工具，支持测试环境和生产环境的自动化构建与签名。

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Python](https://img.shields.io/badge/python-3.6+-green.svg)](https://www.python.org/downloads/)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey.svg)](https://github.com)

## 功能特点

### 核心功能
- **一键配置**：自动配置 Android 项目以支持远程签名
- **双 DSL 支持**：自动检测并支持 Groovy DSL (`build.gradle`) 和 Kotlin DSL (`build.gradle.kts`)
- **V1+V2 签名**：本地计算摘要(32字节)，远程获取签名数据，本地组装签名 APK
- **命令行支持**：支持通过命令行参数指定项目路径
- **多模块支持**：支持为额外模块配置远程签名（如 `app_d`、`app_link` 等）
- **自动签名**：构建完成后自动调用远程签名服务
- **环境隔离**：支持测试环境和生产环境的独立配置
- **构建统计**：实时显示编译耗时和签名耗时
- **高效传输**：只传输摘要和签名数据(几KB)，而非整个APK文件
- **多源 Token 读取**：依次从项目根目录 `.env`、上级目录 `.env`、系统环境变量读取 `SIGN_TOKEN`，适配多项目共享和 CI/CD 场景

### 智能修复
- **签名配置自动修复**：自动替换不存在的 keystore 引用为 debug 签名
- **多 Flavor 支持**：正确处理多个 productFlavors
- **编码兼容**：支持多种文件编码（UTF-8/GBK）

### 兼容性增强（v2.1）
- 修复 Kotlin DSL 生成代码中 `java.io.File` / `java.io.IOException` 未导入导致编译失败的问题
- 修复 `create("debug")` 与 AGP 自动创建的 debug 签名配置冲突，改用 `getByName("debug")`
- 新增 `_ensure_imports()` 步骤，自动在目标文件顶部注入必要的 `import` 声明

### 兼容性增强（v2.0）
- 支持 Kotlin DSL (`build.gradle.kts`) 和 Groovy DSL (`build.gradle`)
- 自动检测项目 DSL 类型，无需手动指定
- 拆分为独立模块：`apply_groovy_sign.py` 和 `apply_kts_sign.py`
- Kotlin DSL 支持 `create("flavor")` 语法、`signingConfigs.getByName()` 等
- 兼容 AGP 8.x 现代 DSL（`lint {}`、`packaging {}` 等）

### 兼容性增强（v1.1）
- 兼容 `apply plugin` 老式语法
- 兼容 `buildFeatures { viewBinding true }` 写法
- 更详细的错误提示信息
- 改进插入点检测策略

---

## 快速开始

### 使用命令行配置

```bash
# 通过命令行参数指定目标 Android 项目路径
python remote_sign/apply_remote_sign.py --project-path "D:/MyAndroidProject"

# 或使用简写
python remote_sign/apply_remote_sign.py -p "/path/to/your/android/project"

# 同时为额外模块配置远程签名（可选）
python remote_sign/apply_remote_sign.py -p "/path/to/project" --modules app_d,app_link
```

---

## 前置条件

**重要：使用本工具前，请确保已在 Android Studio 中至少编译一次项目。**

Android Studio 会自动创建 `local.properties` 文件，该文件包含 `sdk.dir` 配置。如果该文件不存在，构建时会提示错误。

**Python 依赖：签名脚本需要 `requests` 库，请确保已安装：**
```bash
pip install requests

# macOS Homebrew Python 如果报错，使用:
pip install --break-system-packages requests
```

---

## 配置完成后的步骤

### 1. 配置签名 Token（三选一）

`SIGN_TOKEN` 读取优先级：项目根目录 `.env` > 上级目录 `.env` > 系统环境变量

**方式一：在项目根目录创建 .env 文件（推荐）**

```bash
# 复制环境变量模板
copy .env.example .env          # Windows
cp .env.example .env            # Linux/macOS

# 编辑 .env 文件，填入实际的签名服务 Token
# SIGN_TOKEN=your_actual_token_here
```

**方式二：在上级目录创建 .env 文件（多项目共享 Token）**

```bash
# 在项目根目录的上一级创建 .env 文件
# 适合多个 Android 项目共享同一个 SIGN_TOKEN
echo "SIGN_TOKEN=your_actual_token_here" > ../.env
```

**方式三：使用系统环境变量（适合 CI/CD 或终端命令行构建）**

```bash
# Linux/macOS
export SIGN_TOKEN=your_actual_token_here
# 添加到 ~/.zshrc 或 ~/.bashrc 中可永久生效

# Windows
set SIGN_TOKEN=your_actual_token_here
```

> **注意**：macOS 从 Dock 启动的 Android Studio 无法读取 `.zshrc` 中的环境变量，请使用 `.env` 文件或从终端运行 `./gradlew`。

### 2. 构建项目（自动签名）

```bash
# 使用 Python 构建脚本（推荐，自动检测 JDK 11）
python scripts\build.py assembleDebug

# 或直接使用 Gradle
gradlew.bat assembleDebug       # Windows
./gradlew assembleDebug         # Linux/macOS
```

也可以直接在 Android Studio 中构建，会自动调用签名脚本。

---

## 目录结构

### 工具目录结构

```
AndroidAutoRemoteSignTool/
├── remote_sign/                    # 源代码目录
│   ├── apply_remote_sign.py       # 命令行配置脚本（调度器，自动检测 DSL 类型）
│   ├── apply_groovy_sign.py      # Groovy DSL (build.gradle) 处理模块
│   ├── apply_kts_sign.py         # Kotlin DSL (build.gradle.kts) 处理模块
│   ├── sign_apk.py                # APK V1+V2 远程签名脚本
│   ├── sign_apk_old.py            # 旧版签名脚本（上传下载模式，仅保留参考）
│   ├── build.py                   # 构建脚本（自动检测 JDK 11）
│   └── config_tool.py             # GUI 配置工具
├── README.md                       # 中文说明文档
└── README.en.md                    # 英文说明文档
```

### 配置后生成的文件

配置脚本会在目标 Android 项目中生成/修改以下文件：

```
YourAndroidProject/
├── scripts/
│   ├── sign_apk.py                # 签名脚本
│   └── build.py                   # 构建脚本
├── .env.example                   # 环境变量模板（新增）
├── .gitignore                     # 已更新
├── gradle.properties              # 已更新
├── app/build.gradle               # Groovy DSL 项目：已更新
├── app/build.gradle.kts           # Kotlin DSL 项目：已更新
└── <module>/build.gradle(.kts)    # 通过 --modules 指定的额外模块（可选）
```

---

## 修改的项目文件

配置脚本会自动修改以下文件：

| 文件 | 修改内容 |
|------|----------|
| `.env.example` | 环境变量模板（新增） |
| `.gitignore` | 添加 `.env` 等文件的忽略规则 |
| `gradle.properties` | 添加资源合并相关配置 |
| `app/build.gradle` | Groovy DSL：集成远程签名任务、自动修复签名配置 |
| `app/build.gradle.kts` | Kotlin DSL：集成远程签名任务、自动修复签名配置 |
| `<module>/build.gradle(.kts)` | 通过 `--modules` 参数指定的额外模块（可选） |

**自动修复功能**：

1. **签名配置修复**：如果项目中的签名配置引用了不存在的 keystore 文件，脚本会自动将其替换为 debug 签名配置，确保项目可以正常编译。
   - Groovy: `signingConfig signingConfigs.vertu` → `signingConfig signingConfigs.debug`
   - Kotlin: `signingConfigs.getByName("vertu")` → `signingConfigs.getByName("debug")`

2. **多 Flavor 支持**：正确处理多个 productFlavors，支持 Groovy 的 `stageEnv { }` 和 Kotlin 的 `create("stageEnv") { }` 两种语法。

---

---

## 构建变体

| 变体 | 说明 |
|------|------|
| `assembleDebug` | Debug 版本 |
| `assembleRelease` | Release 版本 |

如果你的项目定义了 productFlavors，可以使用对应的变体：
- `assembleDebugEnvDebug`
- `assembleReleaseEnvRelease`
- 等等

查看所有可用变体：
```bash
gradlew.bat tasks --group=build
```

---

## 签名服务配置

| 配置项 | 值 |
|--------|-----|
| 签名基础URL | `https://public-service.vertu.cn/android/apk` |
| V1签名接口 | `{base_url}/handleSignV1` |
| V2签名接口 | `{base_url}/handleSignV2` |
| 认证方式 | Bearer Token（配置在 `.env` 文件或系统环境变量的 `SIGN_TOKEN`，支持上级目录 `.env`） |
| 签名方式 | 本地计算摘要 + 远程获取签名数据 + 本地组装 |

如需修改签名服务 URL，请编辑目标项目的 build 文件：
- **Groovy DSL**: `app/build.gradle` 中的 flavor `ext { signApiUrl = "..." }`
- **Kotlin DSL**: `app/build.gradle.kts` 中的 `signApiUrls` map

---

## 常见问题

### Q: JDK 版本要求？
**A:** 需要 JDK 11。`build.py` 脚本会自动检测并配置，无需手动设置 JAVA_HOME。

### Q: 签名失败怎么办？
**A:** 请检查：
1. `.env` 文件中的 `SIGN_TOKEN` 是否正确（或系统环境变量是否已配置）
2. 网络是否能访问签名服务
3. 查看构建日志中的错误信息

### Q: macOS 下 Android Studio 构建时提示“SIGN_TOKEN未配置”？
**A:** macOS 从 Dock 启动的应用无法读取 `.zshrc` / `.bashrc` 中的环境变量。解决方案：
- 使用 `.env` 文件配置 Token（推荐）
- 或从终端运行 `./gradlew assembleXxx`（终端能正常读取环境变量）

### Q: 支持哪些 Android 项目？
**A:** 支持使用 Gradle 构建的 Android 项目，同时支持 **Groovy DSL** (`build.gradle`) 和 **Kotlin DSL** (`build.gradle.kts`)，自动检测并适配不同的 productFlavors 配置。

### Q: 配置后项目无法编译？
**A:** 检查是否已在 Android Studio 中至少编译过一次项目，确保 `local.properties` 文件存在。

### Q: 如何为多个模块配置远程签名？
**A:** 使用 `--modules` 参数，多个模块用逗号分隔：
```bash
python remote_sign/apply_remote_sign.py -p "/path/to/project" --modules app_d,app_link
```
该参数可选，不指定时默认只配置 `app` 模块。

### Q: 如何构建 Windows EXE？
**A:** 已移除 EXE 打包功能，请直接使用 Python 运行命令行工具。

---

## 远程签名实现原理

### 概述

传统的 APK 签名需要将整个 APK 文件上传到签名服务器，签名完成后再下载。远程签名方案的核心思想是：**本地计算摘要，远程获取签名，本地组装 APK**。

只需传输 32 字节的摘要数据，服务端返回签名数据（约几 KB），本地完成最终的 APK 组装。

### V1 签名（JAR Signature）

V1 签名基于 JAR 签名规范，将签名信息存储在 APK 内的 `META-INF/` 目录中：

```
META-INF/
├── MANIFEST.MF    # 清单文件，包含所有文件的摘要
├── ANDROID.SF     # 签名文件，包含 MANIFEST.MF 的摘要
└── ANDROID.RSA    # 签名块文件，包含对 .SF 文件的签名和证书
```

**V1 远程签名流程：**

1. 遍历 APK 中所有文件，计算每个文件的 SHA-256 摘要
2. 生成 MANIFEST.MF（包含文件名和摘要）
3. 生成 ANDROID.SF（包含 MANIFEST.MF 摘要和各条目摘要）
4. 计算 ANDROID.SF 的 SHA-256 摘要（**32 字节**）
5. 发送 sf_digest 到服务端 `/handleSignV1`
6. 服务端使用私钥签名，返回 ANDROID.RSA
7. 本地将签名文件注入 APK

### V2 签名（APK Signature Scheme V2）

V2 签名是 Android 7.0 引入的新方案，在 ZIP 结构中插入 **APK Signing Block**：

```
┌──────────────────────────────┐
│      ZIP Contents (files)    │
├──────────────────────────────┤
│   APK Signing Block          │  ← 新增签名块
│   - V2 Signature Block       │
│   - Verity Padding           │
├──────────────────────────────┤
│      Central Directory       │
├──────────────────────────────┤
│      EOCD                    │
└──────────────────────────────┘
```

**V2 远程签名流程：**

1. 将 APK 分为三部分：before_cd、cd、eocd
2. 计算内容摘要（分块 SHA-256，**32 字节**）：
   - 按 1MB 分块
   - 每块计算: `SHA-256(0xA5 || len(chunk) || chunk)`
   - 最终: `SHA-256(0x5A || count || all_chunk_digests)`
3. 发送 content_digest 到服务端 `/handleSignV2`
4. 服务端返回签名包：signed_data, signature, certificate, public_key
5. 本地构建 APK Signing Block 并组装最终 APK

### V1 + V2 联合签名流程

```
1. V1 签名
   ├── 计算 sf_digest (32 bytes)
   ├── 请求 V1 签名 → 获取 cert_rsa
   └── 注入 META-INF/*.MF, *.SF, *.RSA

2. V2 签名（基于 V1 签名后的 APK）
   ├── 计算 content_digest (32 bytes)
   ├── 请求 V2 签名 → 获取 sign_package
   └── 插入 APK Signing Block

3. 输出最终签名 APK
```

**注意**：V2 签名必须基于 V1 签名后的 APK 计算，因为 V1 签名会修改 APK 内容。

### 兼容性

| Android 版本 | V1 签名 | V2 签名 |
|-------------|---------|---------|
| < 7.0       | ✅      | ❌      |
| >= 7.0      | ✅      | ✅      |

### 网络传输对比

| 方案 | 上传数据 | 下载数据 | 总计 |
|------|---------|---------|------|
| 传统方案 | ~50 MB | ~50 MB | ~100 MB |
| 远程签名 | 64 bytes | ~2 KB | ~2 KB |

**传输量减少 99.99%+**

---

## 更新日志

### v2.1 (2026-02-27)
**Kotlin DSL 兼容性修复**

- 修复生成的 Kotlin DSL 代码中 `java.io.File` / `java.io.IOException` 未导入导致 `Unresolved reference: io` 编译错误
- 修复 `create("debug")` 与 AGP 自动创建的 debug 签名配置名称冲突（`Cannot add a SigningConfig with name 'debug'`），改用 `getByName("debug")`
- 新增 `_ensure_imports()` 自动在目标 `.gradle.kts` 顶部注入 `import java.io.File` 和 `import java.io.IOException`
- 模板代码中 FQN 引用统一替换为简单类名，保持代码简洁

### v2.0 (2026-02-27)
**Kotlin DSL 支持**

- 新增 Kotlin DSL (`build.gradle.kts`) 支持，自动检测项目 DSL 类型
- 拆分为独立模块：`apply_groovy_sign.py`（Groovy）和 `apply_kts_sign.py`（Kotlin）
- `apply_remote_sign.py` 精简为调度器，自动检测 `.gradle` / `.gradle.kts` 并调用对应处理模块
- Kotlin DSL 支持 `create("flavor")` 语法、`signingConfigs.getByName()` 等
- 兼容 AGP 8.x 现代 DSL（`lint {}`、`packaging {}`、`extra["key"]`）
- Kotlin 签名任务使用顶层 `signApiUrls` map 而非 flavor `ext` 块，更简洁
- 原有 Groovy DSL 功能完全不受影响

### v1.7 (2026-02-27)
**多级 .env 查找与环境变量支持**

- SIGN_TOKEN 读取优先级：项目根目录 `.env` > 上级目录 `.env` > 系统环境变量
- 支持上级目录 `.env` 文件，适合多个项目共享同一个 Token
- 每个查找步骤均输出详细日志，便于排查配置问题
- 更新配置完成后的提示信息，说明三种 Token 配置方式

### v1.6 (2026-02-27)
**环境变量支持**

- 新增系统环境变量读取 `SIGN_TOKEN` 支持
- 适配 CI/CD 场景，无需创建 `.env` 文件即可通过环境变量配置 Token
- 优化 Token 读取日志，明确显示 Token 来源（不打印具体值）

### v1.5 (2026-02-26)
**多模块支持**

- 新增 `--modules` / `-m` 参数，支持为额外模块配置远程签名（如 `app_d`, `app_link`）
- 默认仍然只配置 `app` 模块，完全向后兼容
- GUI 配置工具同步支持额外模块输入
- 单个模块配置失败不会阻断其他模块的配置流程

### v1.4 (2026-02-14)
**体验优化**

- 自动生成 `debug.keystore`：新电脑首次构建时自动检测并生成缺失的 keystore 文件
- Python 命令自动回退：签名脚本优先使用 `python`，失败后自动尝试 `python3`
- 构建完成后显示 APK 输出路径
- 移除 GUI 工具，简化为纯命令行工具
- 优化 `pip install` 提示信息，支持 macOS Homebrew Python

### v1.3 (2026-02-13)
**签名逻辑重构**

- 新的签名方式：本地计算摘要(32字节) + 远程获取签名数据 + 本地组装 V1+V2 签名
- 替代旧的整个 APK 上传下载模式，大幅减少网络传输量
- 新增 `requests` 库依赖
- 移除 EXE 打包功能（build_exe.py, PyInstaller spec 文件）
- 移除重复的 apk_signer.py
- 保留 sign_apk_old.py 作为旧版参考

### v1.1 (2026-02-11)
**兼容性增强更新**

- 兼容老项目使用 `apply plugin` 语法（而非 `plugins {}` 块）
- 兼容使用 `buildFeatures { viewBinding true }` 的项目（无需 `viewBinding {}` 块）
- 支持多种文件编码（UTF-8 和 GBK）
- 增强错误处理，提供更详细的错误信息：
  - 项目根目录不存在检查
  - app 目录不存在检查
  - build.gradle 文件不存在检查
  - 文件权限错误提示
- 改进插入点检测策略，支持多种 Gradle 配置风格

### v1.0 (初始版本)
- 一键配置 Android 项目远程签名
- 命令行支持
- 自动签名配置修复
- 构建时间统计功能

---

## 许可证

MIT License
