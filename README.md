# Android 开发工具 - Claude Code 插件

[English](./README_EN.md)

一站式 Android 开发工具集。安装一次，拥有全部功能。

## 包含的 Skills

| Skill | 描述 |
|-------|------|
| `init-android` | 初始化或优化 Android 项目的 claude.md 文件 |
| `gradle-build-performance` | 调试和优化 Gradle 构建性能 |
| `apply-remote-sign` | 自动配置远程 APK 签名 |
| `update-docs` | 生成中文技术文档 |
| `android-i18n` | 审计并生成 4 种语言的国际化资源 |
| `android-fold-adapter` | 诊断和修复折叠屏适配问题 |
| `code-note` | 为 Kotlin/Java 源文件添加中文注释 |
| `auto-ui-test` | Android UI自动化测试 - Midscene视觉驱动 + ADB快速执行，支持文档驱动测试 |
| `update-remote-plugins` | 同步 marketplace 并更新本地插件 |

---

## init-android

初始化或优化 Android 项目的 claude.md 文件。从 Gradle 配置和源码目录检测真实项目结构，合并已有规则，生成简洁的 AI 指导文件。

**功能：**
- 从 Gradle 配置和源码目录检测真实项目结构
- 合并已有规则（claude.md、common.mdc）
- 生成简洁低 token 的 AI 指导文件
- 四个必须段落：AI 工作原则、单一事实来源、局部一致性规则、项目强约束
- 文档索引格式校验（仅合法 Markdown 链接）
- 可选生成 checklist（API、依赖、模块）

**用法：** `/android-dev-tools:init-android`

---

## gradle-build-performance

调试和优化 Android/Gradle 构建性能。

**功能：**
- **新增：** 诊断工作流，提供分级风险方案（零风险/低风险/中等风险）
- **新增：** 常见问题检测（动态版本、版本不一致等）
- **新增：** 推荐 gradle.properties 模板
- 分析 Gradle 构建扫描
- 识别配置与执行阶段瓶颈
- 启用配置缓存、构建缓存、并行编译
- 优化 CI/CD 构建时间
- 调试 kapt/KSP 注解处理
- Groovy DSL 和 Kotlin DSL 示例

**用法：** `/android-dev-tools:gradle-build-performance`

---

## apply-remote-sign

为 Android 项目自动配置远程 APK 签名。

**功能：**
- 支持 Groovy DSL (`build.gradle`) 和 Kotlin DSL (`build.gradle.kts`)
- 创建 `.env.example` 模板
- 更新 `.gitignore` 和 `gradle.properties`
- 集成签名任务到构建脚本
- 内置 AndroidAutoRemoteSignTool 工具

**用法：**
```bash
/android-dev-tools:apply-remote-sign [项目路径] [--modules 模块1,模块2]
```

---

## update-docs

为 Android 项目自动生成中文技术文档。

**功能：**
- 分析项目结构
- 生成界面文档（控件、功能说明）
- 文档化导航流程（Activity-Fragment 关系）
- 列出四大组件（Activity、Service、Receiver、Provider）
- 文档化通知渠道和 API 接口
- 支持增量更新
- 将根目录 md 文件迁移到 docs/ 目录
- 更新 README 并添加分类文档快捷链接
- **新增 (v2.7.0)：** CHANGELOG.md 作为更新列表，支持点击查看详情
- **新增 (v2.7.0)：** 详细更新文档存放在 `docs/update-list/`，记录实际内容变更
- **新增 (v2.7.0)：** README 只显示最近 1 条更新（链接到 CHANGELOG 查看全部）
- **新增 (v2.7.0)：** 记录文档内容变更，不仅仅是 git 提交

**用法：**
```bash
/android-dev-tools:update-docs [--force] [--dry-run] [interfaces|navigation|components|notifications|api]
```

---

## code-note

为 Kotlin/Java 源文件添加中文注释。

**功能：**
- 分析代码结构（类、方法、变量）
- 添加 KDoc/JavaDoc 风格文档
- 注释关键逻辑块
- 简短但全面的注释
- 保持原有代码格式

**用法：**
```bash
/android-dev-tools:code-note 文件名
```

**示例：**
- `/android-dev-tools:code-note AlbumActivity`
- `/android-dev-tools:code-note LoginActivity.kt`

---

## update-remote-plugins

同步 marketplace.json 与插件目录，并更新 README 文件。

**功能：**
- 扫描插件目录变更
- 插件修改时自动升级版本号
- 添加/移除插件到 marketplace.json
- 同步中英文 README 文件
- 提交并推送到远程
- 同步更新到本地 Claude Code 插件目录

**用法：** `/android-dev-tools:update-remote-plugins`

---

## android-i18n

审计 Android 项目中的硬编码中文字符串并生成国际化资源。

**功能：**
- 扫描 XML 布局和 Kotlin/Java 代码中的中文字符串
- 在 `strings.xml` 中生成字符串资源
- 自动翻译为 4 种语言 (en/ru/zh/zh-rTW)
- 更新代码使用资源引用

**用法：**
```bash
/android-dev-tools:android-i18n [项目路径]
```

---

## android-fold-adapter

诊断和修复 Android 折叠屏适配问题。

**功能：**
- 诊断折叠/展开时的 Activity 重建问题
- 修复状态丢失问题（UI 可见性、数据字段）
- 解决 Fragment 引用失效（ViewPager2）
- 自动更新 skill 以记录新模式/解决方案
- 归档已知问题供将来参考

**用法：**
```bash
/android-dev-tools:android-fold-adapter "搜索页折叠后内容消失"
```

---

## auto-ui-test

Android UI 自动化测试，智能选择执行模式，支持文档驱动测试。

**功能：**
- **双执行模式：** Midscene 视觉驱动 + ADB 快速执行
- **文档驱动测试：** 从 markdown 文档解析测试用例
- **智能过滤：** 跳过 PASS 用例，仅测试 FAIL/待验证用例
- **自动生成报告：** 报告保存到 `docs/test/report/`
- **智能模式选择：** 自动选择最优执行方式

**用法：**
```bash
# 直接执行测试任务
/android-dev-tools:auto-ui-test 点击Toast按钮，等待3秒后截图

# 文档驱动测试（解析文档并执行测试）
/android-dev-tools:auto-ui-test docs/test/UI_TEST_REPORT.md
```

**文档驱动测试：**
- 自动从 markdown 文档解析测试用例
- 跳过状态为 `PASS` 的用例
- 执行 `FAIL`、`待验证` 或无状态的用例
- 生成报告到 `<项目>/docs/test/report/UI_TEST_REPORT_YYYYMMDD_HHMMSS.md`

**支持的文档格式：**
```markdown
## 测试用例: TC-001
**步骤**: 1. 点击按钮 2. 等待3秒
**状态**: FAIL          # 将被执行

## 测试用例: TC-002
**步骤**: 1. 进入设置
**状态**: PASS          # 跳过
```

**环境配置：**

1. **ADB 已安装**
   ```bash
   adb --version
   ```

2. **启动 Playground CLI**（用于调试和可视化操作）
   ```bash
   npx --yes @midscene/android-playground
   ```

3. **集成 Midscene Agent**（项目依赖）
   ```bash
   npm install @midscene/android --save-dev
   ```

**详细文档：** https://midscenejs.com/zh/android-getting-started.html

**前置条件：**
- ADB 已安装并在 PATH 中
- Android 设备已启用 USB 调试
- 项目已集成 Midscene Android

---

## 安装

```bash
# 1. 添加 marketplace
/plugin marketplace add github.com/adzcsx2/claude_skill

# 2. 安装（包含所有 skills）
/plugin install android-dev-tools@android-dev-tools
```

---

## 仓库结构

```
claude_skill/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   └── android-dev-tools/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── AndroidAutoRemoteSignTool/   # 内置工具
│       │   └── remote_sign/
│       │       ├── apply_remote_sign.py
│       │       ├── apply_groovy_sign.py
│       │       ├── apply_kts_sign.py
│       │       └── ...
│       └── skills/
│           ├── init-android/
│           │   └── SKILL.md
│           ├── gradle-build-performance/
│           │   └── SKILL.md
│           ├── apply-remote-sign/
│           │   └── SKILL.md
│           ├── update-docs/
│           │   └── SKILL.md
│           ├── android-i18n/
│           │   └── SKILL.md
│           ├── android-fold-adapter/
│           │   └── SKILL.md
│           ├── code-note/
│           │   └── SKILL.md
│           ├── auto-ui-test/
│           │   ├── SKILL.md
│           │   └── references/
│           │       ├── doc-parser-guide.md
│           │       └── midscene-reference.md
│           └── update-remote-plugins/
│               └── SKILL.md
├── README.md                  # 中文
├── README_EN.md               # 英文
└── .gitignore
```

---

## 环境要求

- Claude Code CLI
- `apply-remote-sign` 需要：Python 3.6+、`requests` 库、JDK 11、Android SDK
- `update-docs` 需要：标准结构的 Android 项目

---

## 许可证

MIT

## 作者

[adzcsx2](https://github.com/adzcsx2)
