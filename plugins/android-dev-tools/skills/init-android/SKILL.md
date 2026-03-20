---
name: init-android
description: Initialize or optimize claude.md for Android projects. Detect real project structure from Gradle and source folders, merge existing rules such as claude.md and common.mdc, and generate a concise low-token AI guidance file that prioritizes reusing existing architecture, utilities, and coding patterns. Optionally generate minimal verified checklist docs for APIs, dependencies, and modules when explicitly requested. Use when creating or refining Android AI instructions, reducing context tokens, aligning AI behavior with an existing codebase, auditing Android project metadata, or adapting to legacy and mixed Java/Kotlin Android projects.
---

> 中文环境要求
>
> - 面向用户的回复、注释、提示信息必须使用中文
> - AI 内部分析可以使用英文
> - 所有生成文件必须使用 UTF-8 编码
> - 对外输出优先简洁、明确、可执行，避免冗长项目介绍

# init-android Skill

为 Android 项目生成或优化 claude.md，使 AI 工具能够：

- 快速理解项目的真实结构与构建方式
- 优先复用现有实现，而不是重新设计一套
- 遵循项目已有编码规范、目录组织和局部写法
- 在尽量少的 token 下获得足够高价值的上下文
- 兼容传统 Android 项目、Java/Kotlin 混合项目、历史页面与新代码并存项目

## When to Use

- 新项目需要初始化 AI 规则文件
- 现有项目的 claude.md 需要瘦身、去重、降 token
- 项目已有 common.mdc、README、docs，但 AI 仍容易理解跑偏
- 希望 AI 优先复用现有架构、工具类、公共组件、网络层、目录结构
- 旧项目、混合 Java/Kotlin 项目、历史页面和新页面共存，需要 AI 跟随现状而不是套现代模板

## Trigger

```text
/init-android
```

## Core Goals

最终生成或更新的 claude.md 必须满足以下目标：

1. 重点是“AI 工作规则”，不是“项目介绍文档”
2. 优先帮助 AI 做正确决策，而不是堆背景信息
3. 明确单一事实来源，避免与真实工程配置冲突
4. 强化“先搜索、先复用、最小改动、局部一致”
5. 避免默认套用 MVVM、Clean Architecture、Compose、DI 等现代 Android 模板
6. 对历史项目保持保守，不擅自迁移语言、绑定方案、架构层次

## Execution Flow

### 1. Verify Project Type

确认当前目录是 Android 项目。至少满足以下条件之一：

- 存在 settings.gradle 或 settings.gradle.kts
- 存在 build.gradle 或 build.gradle.kts
- 存在 app/src/main/AndroidManifest.xml 或等价主模块 Manifest

如果不是 Android 项目，直接退出并说明原因。

### 2. Discover Existing Guidance

优先读取并分析已有规则和文档，禁止直接按模板覆盖：

- claude.md
- common.mdc
- README.md
- docs/architecture/*
- docs/development/*
- docs/checklist/*
- 其他明确用于 AI 规则或开发规范的文件

目标不是复制这些文档，而是抽取其中对 AI 最关键的高频约束、真实事实和复用入口。

### 3. Build Single Sources of Truth

以下信息必须只从真实来源提取：

- SDK、AGP、Kotlin、Java、buildTypes、productFlavors、模块依赖：来自 Gradle 配置
- 模块列表：来自 settings.gradle 或 settings.gradle.kts
- 真实目录结构：来自源码目录扫描结果
- 现有编码模式：来自相邻代码、公共基类、工具类、网络层、UI 组件
- 默认构建命令：来自 Gradle 配置和已有项目文档
- 项目特殊规则：来自现有规范文件和真实实现

如果文档与代码冲突，以代码和构建配置为准；若两者都不明确，再保留谨慎描述。

### 4. Detect Local Coding Patterns

必须检测而不是臆测：

#### 4.1 Language Mix

- Java 和 Kotlin 的实际占比
- 哪些目录以 Java 为主，哪些目录以 Kotlin 为主
- 是否存在“旧页面 Java、新功能 Kotlin”的明显分层

#### 4.2 View Binding Style

- ButterKnife 是否仍在使用
- ViewBinding 是否已启用并在哪些目录中使用
- DataBinding 是否存在
- 是否存在老页面与新页面绑定方案并存

生成规则时必须写明：
修改代码时优先跟随目标文件和同目录已有绑定模式，不因为偏好擅自迁移。

#### 4.3 Reuse Entrypoints

优先识别这些复用入口：

- BaseActivity / BaseFragment / BaseAdapter / BaseViewHolder
- utils / helper / manager / provider / repository / http / model / view
- 公共 Dialog、公共 View、公共网络封装、公共响应体、公共常量、公共工具类
- 字符串资源、颜色资源、日志工具、Toast 工具、存储工具、权限工具

#### 4.4 Architecture Reality

检查项目真实结构，而不是套预设模板：

- 实际源码目录如何命名
- 业务是按 activity/fragment/adapter/http/model/utils/manager/view 组织，还是其他方式
- 是否有明显的公共模块和本地库模块
- 是否存在老架构与新写法混用

不要因为检测到 ViewModel、LiveData、StateFlow 就自动断言项目是完整 MVVM。

### 5. Generate or Optimize claude.md

默认行为是“优化已有 claude.md”，不是“全量重写”。

只有在以下情况才接近重写：

- 项目不存在 claude.md
- 现有 claude.md 明显是低质量模板、信息严重过时、与实际代码大量冲突
- 用户明确要求重写

生成结果必须符合：

- 目标长度控制在 60 到 120 行
- 使用“规则 + 路径索引”的高密度写法
- 保留高频、高约束、高复用信息
- 删除低频背景描述和教程式内容
- 不重复 README 中的大段项目介绍
- 不展开完整变体表、完整 APK 输出说明、完整构建教程
- 不写通用 Android 教程式代码示例

### 6. Required Structure of claude.md

生成的 claude.md 应优先包含这些部分：

1. AI 工作原则
2. 单一事实来源
3. 复用优先级
4. 局部一致性规则
5. 项目强约束
6. 真实目录结构
7. 默认构建方式
8. 文档索引

每一部分都应短、硬、可执行。

### 7. Mandatory Reuse Rules

生成 claude.md 时必须尽量固化这些规则：

- 修改前先搜索目标文件同目录和同类实现
- 优先复用现有 Activity、Fragment、Adapter、Http、Model、Utils、Manager、View
- 优先在已有类中扩展，不轻易新增平行封装
- 优先最小改动，不做无关重构
- Java 文件优先延续 Java 写法
- Kotlin 文件优先延续 Kotlin 写法
- 保持相邻代码的命名、调用链、目录组织和异常处理方式一致
- 不主动引入新的 MVVM、Repository、UseCase、DI、Compose、三方库，除非用户明确要求
- 对传统项目和历史页面保持保守，不把局部修改升级成架构改造

### 8. Project-Specific Constraints

如果项目中存在明确的资源、工具、常量、存储、日志规范，必须前置写入 claude.md，例如：

- 文本不得硬编码，优先查 strings.xml
- 颜色不得硬编码，优先查 colors.xml
- Toast 统一使用既有工具
- 日志统一使用既有日志工具
- SharedPreferences 或其他存储统一使用既有封装
- KEY、常量、工具方法优先复用已有定义
- 已有同类 Utils 时优先追加方法，不新建重复工具类

注意：这些规则必须来自真实项目实现或已有规范，不能凭空推荐。

### 9. Optional Checklist Generation

默认不生成 docs/checklist/*。

只有在以下情况才生成：

- 用户明确要求生成
- 项目几乎没有任何文档，需要建立最小索引
- 扫描结果足够可靠，不会产生大量模板化伪信息

如果生成 checklist，必须遵循：

- 只记录从项目中真实扫描到的内容
- 不得虚构模块、接口、依赖
- 不得预设 common-core、Koin、Hilt、Compose、MMKV 等项目未使用内容
- 如果信息提取不可靠，则宁可少写，也不要编造

### 10. Optional .gitignore Update

不要默认把 claude.md 加入 .gitignore。

先询问用户希望：

- 仅本地使用
- 团队共享 AI 规则

如果用户选择仅本地使用，再建议加入 .gitignore。
如果用户希望团队共享，则不要加入 .gitignore。

### 11. Output Standard

对用户的总结说明要包含：

- 生成或更新了什么
- 依据哪些真实来源抽取规则
- 删除了哪些冗余内容
- 保留了哪些项目特有约束
- 是否生成了 checklist
- 是否改动了 .gitignore
- 哪些地方仍建议用户人工确认

## Anti-Patterns

禁止以下做法：

- 把 claude.md 写成 README 的重复版本
- 把通用 Android 最佳实践直接套进旧项目
- 自动宣称项目是 MVVM / Clean Architecture / Compose 项目
- 默认生成一批内容空泛的 checklist 文档
- 在 modules.md、dependencies.md、api.md 中填充模板示例
- 因为检测到少量新写法就要求全项目迁移
- 忽略已有规则文件，直接覆盖
- 输出冗长、低频、难执行的说明

## Expected Outcome

高质量结果应满足：

- AI 首次读取后能快速知道“先去哪看、优先复用什么、不能乱改什么”
- claude.md 长度明显缩短，但决策信息更强
- 规则更贴近真实代码，而不是通用模板
- 面对旧项目、混合语言、并存绑定方案时，AI 行为更稳定
- 减少 AI 自己新起架构、重复造工具、擅自迁移技术方案的概率
