---
name: init
description: Initialize claude.md for Android projects. Analyzes project structure, generates AI development guidelines, build environment config, and creates checklist documents in docs/checklist/.
---

> **中文环境要求**
>
> 本技能运行在中文环境下，请遵循以下约定：
> - 面向用户的回复、注释、提示信息必须使用中文
> - AI 内部处理过程可以使用英文
> - 所有生成的文件必须使用 UTF-8 编码
>
> ---

# init Skill

为 Android 项目初始化 `claude.md` AI 开发规范文件，并生成 `docs/checklist/` 目录下的详细清单文档。

## When to Use

- 新项目需要创建 AI 开发规范
- 现有项目需要标准化开发流程
- 配置编译环境和变体说明
- 生成模块功能清单

## Trigger

```
/init
```

---

## Execution Flow

### 1. Verify Project Type

Check for Android project files:

```bash
# Must exist at least one
settings.gradle or settings.gradle.kts
build.gradle or build.gradle.kts
app/src/main/AndroidManifest.xml
```

If not an Android project, exit with message.

### 2. Check Existing claude.md

```bash
if [ -f "claude.md" ]; then
  echo "claude.md 已存在，是否覆盖？(yes/no)"
  # Wait for user confirmation
fi
```

### 3. Analyze Project Configuration

#### 3.1 Parse build.gradle / build.gradle.kts

Extract from root and app module:

| Field | Source | Example |
|-------|--------|---------|
| compileSdk | `android { compileSdk }` | 34 |
| minSdk | `android { defaultConfig { minSdk } }` | 24 |
| targetSdk | `android { defaultConfig { targetSdk } }` | 34 |
| Kotlin version | `plugins { kotlin("android") }` or classpath | 1.9.0 |
| AGP version | `plugins { id("com.android.application") }` or classpath | 8.2.0 |
| Java version | `compileOptions { sourceCompatibility }` | VERSION_11 |
| buildTypes | `android { buildTypes { } }` | debug, release |
| productFlavors | `android { productFlavors { } }` | dev, prod |

#### 3.2 Parse AndroidManifest.xml

Extract:

| Field | XPath/Pattern |
|-------|---------------|
| applicationId | `manifest[@package]` |
| versionCode | `manifest/@android:versionCode` or `build.gradle` |
| versionName | `manifest/@android:versionName` or `build.gradle` |
| permissions | `uses-permission/@android:name` |

#### 3.3 Detect JVM Environment

Check for:
1. `local.properties` - `org.gradle.java.home`
2. Environment variable - `echo $JAVA_HOME`
3. `/usr/libexec/java_home -V` - List available JVMs

Ask user if not detected.

### 4. Analyze Project Architecture

#### 4.1 Detect Directory Structure

```
Scan for:
- data/ (Repository, DataSource, Entity)
- domain/ (UseCase, Model)
- ui/ (Activity, Fragment, ViewModel)
- di/ (Koin/Dagger modules)
- common/ or core/ (Shared utilities)
```

#### 4.2 Detect DI Framework

```bash
# Koin
grep -r "org.koin" build.gradle*
grep -r "startKoin" *.kt

# Dagger/Hilt
grep -r "dagger" build.gradle*
grep -r "@HiltAndroidApp" *.kt
```

#### 4.3 Detect Architecture Pattern

| Pattern | Indicators |
|---------|------------|
| MVVM | ViewModel, StateFlow, LiveData |
| MVI | Intent, State, SingleEvent |
| Clean Architecture | domain/, data/, ui/ layers |

#### 4.4 Detect Common Libraries

```bash
# Check build.gradle for:
- Retrofit (network)
- Room (database)
- Coil/Glide (image)
- Coroutines (async)
- Jetpack Compose (UI)
- common-lib (shared library)
```

### 5. Detect common-lib Dependency

```bash
# Search for common-lib in dependencies
grep -r "common-lib" build.gradle*
grep -r "adzcsx2.android-common-lib" build.gradle*
```

If found, generate `docs/checklist/modules.md`.

### 6. Detect API Interfaces

```bash
# Find API interfaces
find . -name "*Api.kt" -o -name "*Api.java" -o -name "*Service.kt"
grep -r "@GET\|@POST\|@PUT\|@DELETE" --include="*.kt" --include="*.java"
```

If found, generate `docs/checklist/api.md`.

### 7. Create docs/checklist/ Directory

```bash
mkdir -p docs/checklist
```

Generate checklist files based on detected features:

| File | Condition | Content |
|------|-----------|---------|
| modules.md | common-lib dependency | Module function checklist |
| api.md | API interfaces found | API endpoint checklist |
| dependencies.md | Always | Third-party library list |
| testing.md | Test files found | Testing guidelines |

### 8. Generate claude.md

Use template with detected values. Key sections:

1. **项目概述** - Basic project info
2. **架构原则** - Based on detected architecture
3. **模块优先级原则** - If common-lib found, reference modules.md
4. **代码规范** - Based on detected patterns
5. **编译环境要求** - JVM, SDK, Gradle versions
6. **默认编译变体** - Detected buildTypes + productFlavors
7. **编译命令** - gradlew commands with JAVA_HOME
8. **相关文档** - Links to docs/checklist/

### 9. Create .claude/settings.local.json

If not exists:

```json
{
  "env": {
    "JAVA_HOME": "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home"
  },
  "toolPermissions": {
    "Bash:./gradlew*": "allow"
  }
}
```

### 10. Summary Output

```
✅ claude.md 已生成
✅ docs/checklist/modules.md 已生成
✅ docs/checklist/api.md 已生成
✅ .claude/settings.local.json 已配置

📋 下一步:
1. 检查 claude.md 内容是否正确
2. 根据项目实际情况调整 docs/checklist/ 下的清单
3. 将 claude.md 纳入版本控制
```

---

## claude.md Template

```markdown
# {PROJECT_NAME} - Claude AI 开发规范

> 本文件定义项目的开发规范，使用 Claude Code 或其他 AI 工具辅助开发时，请将此文件放在项目根目录。

## 项目概述

- **项目名称**: {PROJECT_NAME}
- **Application ID**: {APPLICATION_ID}
- **当前版本**: {VERSION_NAME} (versionCode: {VERSION_CODE})
- **项目路径**: {PROJECT_PATH}

---

## 架构原则

### 1. 分层架构

```
{ARCHITECTURE_STRUCTURE}
```

### 2. 关键设计原则

| 原则 | 说明 |
|------|------|
{DESIGN_PRINCIPLES}

---

## 模块优先级原则 (CRITICAL)

**当功能已存在于项目模块时，必须优先使用，禁止重复实现。**

### 使用前检查清单

在编写新代码前，先检查以下模块是否已提供所需功能：

| 需求 | 对应模块 | 使用方式 |
|------|----------|----------|
{MODULE_CHECKLIST}

> 详细功能清单请查看 [docs/checklist/modules.md](./docs/checklist/modules.md)

---

## 代码规范

### 1. 依赖注入规范

{DI_GUIDELINES}

### 2. 命名规范

| 类型 | 规范 | 示例 |
|------|------|------|
{NAMING_CONVENTIONS}

---

## 编译环境要求

### JVM 环境

{JVM_REQUIREMENTS}

### 设置 JAVA_HOME

```bash
export JAVA_HOME={JAVA_HOME_PATH}
```

### Android SDK 版本

- **compileSdk**: {COMPILE_SDK}
- **minSdk**: {MIN_SDK}
- **targetSdk**: {TARGET_SDK}
- **buildToolsVersion**: {BUILD_TOOLS}

### Gradle 版本

- **Gradle Plugin**: {AGP_VERSION}
- **Kotlin**: {KOTLIN_VERSION}

---

## 默认编译变体

- **变体名称**: `{DEFAULT_VARIANT}`
- **构建类型**: {BUILD_TYPE}
- **产品风味**: {PRODUCT_FLAVOR}

---

## 编译命令

### 方式一：直接使用 gradlew

```bash
# 设置 Java 环境
export JAVA_HOME={JAVA_HOME_PATH}

# 清理并编译
./gradlew clean {DEFAULT_VARIANT}

# 或者直接编译
./gradlew {DEFAULT_VARIANT}
```

### 一行命令编译

```bash
JAVA_HOME={JAVA_HOME_PATH} ./gradlew {DEFAULT_VARIANT}
```

---

## 输出 APK 信息

编译成功后，APK 输出位置：

```
app/build/outputs/apk/{FLAVOR}/{BUILD_TYPE}/
```

---

## 其他可用变体

| 变体 | 说明 |
|------|------|
{BUILD_VARIANTS_TABLE}

---

## 注意事项

{IMPORTANT_NOTES}

---

## Claude Code 使用说明

### AI 编译指令

推荐使用以下方式让 AI 编译项目：

```
编译 {DEFAULT_VARIANT} 变体
```

AI 会自动使用正确的 Java 环境：

```bash
export JAVA_HOME={JAVA_HOME_PATH}
./gradlew {DEFAULT_VARIANT}
```

### 环境变量

项目配置的环境变量：
- `JAVA_HOME`: `{JAVA_HOME_PATH}`

---

## 相关文档

- [README.md](./README.md) - 项目说明
- [模块功能清单](./docs/checklist/modules.md) - 模块详细功能
- [API 接口清单](./docs/checklist/api.md) - API 端点列表
- [依赖库清单](./docs/checklist/dependencies.md) - 第三方库列表
```

---

## docs/checklist/modules.md Template

```markdown
# 模块功能清单

> 本文档列出项目所有模块的功能，供 AI 开发时参考。在实现新功能前，请先检查是否已有现成的实现。

---

## common-core

核心抽象层，提供基础接口和工具。

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| 状态管理 | `UIState<T>` | 统一 UI 状态封装 |
| 协程扩展 | `withIO`, `withMain` | 协程调度器切换 |
| 日志记录 | `Logger.d()`, `Logger.e()` | 统一日志输出 |

---

## common-network

网络请求模块。

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| Retrofit 工厂 | `RetrofitFactory.createService()` | 创建 API 服务 |
| 拦截器 | `LoggingInterceptor` | 请求日志拦截 |

---

## common-utils

工具类模块。

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| 键值存储 | `MMKVUtils` | MMKV 封装 |
| Toast | `ToastUtils.show()` | Toast 显示 |
| 权限请求 | `LivePermissions` | 运行时权限 |

---

## 添加新模块

当添加新模块时，请更新此文档：

```markdown
## {模块名称}

{模块描述}

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| ... | ... | ... |
```
```

---

## docs/checklist/api.md Template

```markdown
# API 接口清单

> 本文档列出项目所有 API 接口，供 AI 开发时参考。

---

## 基础配置

- **BASE_URL**: `{BASE_URL}`
- **认证方式**: Token / OAuth / None

---

## API 列表

### 用户模块

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/user/profile` | 获取用户信息 |
| POST | `/user/login` | 用户登录 |

### {模块名称}

| 方法 | 路径 | 说明 |
|------|------|------|
| ... | ... | ... |

---

## 添加新接口

当添加新接口时，请更新此文档。
```

---

## docs/checklist/dependencies.md Template

```markdown
# 依赖库清单

> 本文档列出项目使用的第三方库，供 AI 开发时参考。

---

## 核心依赖

| 库 | 版本 | 用途 |
|------|------|------|
| Kotlin | {KOTLIN_VERSION} | 编程语言 |
| AndroidX Core | {VERSION} | Android 核心库 |
| Retrofit | {VERSION} | 网络请求 |
| OkHttp | {VERSION} | HTTP 客户端 |
| Room | {VERSION} | 数据库 |
| Coil | {VERSION} | 图片加载 |
| Coroutines | {VERSION} | 协程 |

## 依赖注入

| 库 | 版本 | 用途 |
|------|------|------|
| Koin | {VERSION} | 依赖注入框架 |

## UI 组件

| 库 | 版本 | 用途 |
|------|------|------|
| Material | {VERSION} | Material Design |
| ConstraintLayout | {VERSION} | 布局 |

## 测试

| 库 | 版本 | 用途 |
|------|------|------|
| JUnit | {VERSION} | 单元测试 |
| MockK | {VERSION} | Mock 框架 |
```

---

## Notes

1. **Always analyze before generating** - Detect project structure first
2. **Keep claude.md concise** - Detailed checklists go to docs/checklist/
3. **Preserve existing files** - Ask before overwriting
4. **Auto-detect JVM** - Use local.properties or system default
5. **Link to checklists** - claude.md should reference docs/checklist/ files
6. **Update version** - Increment plugin version after adding this skill
