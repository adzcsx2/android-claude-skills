# Android Dev Tools - Claude Code Plugin

[中文文档](./README.md)

All-in-one Android development toolkit for Claude Code. Install once, get everything.

## Included Skills

| Skill | Description |
|-------|-------------|
| `gradle-build-performance` | Debug and optimize Gradle build performance |
| `apply-remote-sign` | Auto-configure remote APK signing |
| `update-docs` | Generate Chinese technical documentation |
| `android-i18n` | Audit and generate i18n resources for 4 languages |
| `android-fold-adapter` | Diagnose and fix foldable screen adaptation issues |
| `code-note` | Add Chinese comments to Kotlin/Java source files |
| `auto-ui-test` | Android UI automation testing - Midscene + ADB with doc-driven mode |
| `update-remote-plugins` | Sync marketplace and update local plugins |

---

## gradle-build-performance

Debug and optimize Android/Gradle build performance.

**Features:**
- **NEW:** Diagnostic workflow with risk-level plans (Zero/Low/Medium)
- **NEW:** Common issues detection (dynamic versions, version inconsistencies)
- **NEW:** Recommended gradle.properties template
- Analyze Gradle build scans
- Identify configuration vs execution bottlenecks
- Enable configuration cache, build cache, parallel execution
- Optimize CI/CD build times
- Debug kapt/KSP annotation processing
- Groovy DSL and Kotlin DSL examples

**Usage:** `/android-dev-tools:gradle-build-performance`

---

## apply-remote-sign

Auto-configure remote APK signing for Android projects.

**Features:**
- Supports Groovy DSL (`build.gradle`) and Kotlin DSL (`build.gradle.kts`)
- Creates `.env.example` template
- Updates `.gitignore` and `gradle.properties`
- Integrates signing tasks into build scripts
- Includes AndroidAutoRemoteSignTool (built-in)

**Usage:**
```bash
/android-dev-tools:apply-remote-sign [project_path] [--modules module1,module2]
```

---

## update-docs

Auto-generate Chinese technical documentation for Android projects.

**Features:**
- Analyzes project structure
- Generates interface documentation (controls, functionality)
- Documents navigation flows (Activity-Fragment relationships)
- Lists four components (Activity, Service, Receiver, Provider)
- Documents notification channels and API endpoints
- Supports incremental updates
- Migrates root md files to docs/ directory
- Updates README with categorized doc quick links
- **NEW (v2.7.0):** CHANGELOG.md as update list with links to detailed updates
- **NEW (v2.7.0):** Detailed update documents in `docs/update-list/` with actual content changes
- **NEW (v2.7.0):** README shows only 1 most recent update (link to CHANGELOG for full history)
- **NEW (v2.7.0):** Records document content changes, not just git commits

**Usage:**
```bash
/android-dev-tools:update-docs [--force] [--dry-run] [interfaces|navigation|components|notifications|api]
```

---

## code-note

Add Chinese comments to Kotlin/Java source files.

**Features:**
- Analyze code structure (classes, methods, variables)
- Add KDoc/JavaDoc style documentation
- Comment key logic blocks
- Concise but comprehensive comments
- Preserve original code formatting

**Usage:**
```bash
/android-dev-tools:code-note 文件名
```

**Examples:**
- `/android-dev-tools:code-note AlbumActivity`
- `/android-dev-tools:code-note LoginActivity.kt`

---

## update-remote-plugins

Sync marketplace.json with plugins directory and update README files.

**Features:**
- Scan plugins directory for changes
- Auto-bump versions on plugin modifications
- Add/remove plugins from marketplace.json
- Sync English and Chinese README files
- Commit and push to remote
- Sync changes to local Claude Code plugins directory

**Usage:** `/android-dev-tools:update-remote-plugins`

---

## android-i18n

Audit Android project for hardcoded Chinese strings and generate i18n resources.

**Features:**
- Scan hardcoded strings in XML layouts and Kotlin/Java code
- Generate string resources in `strings.xml`
- Auto-translate to 4 languages (en/ru/zh/zh-rTW)
- Update code to use resource references

**Usage:**
```bash
/android-dev-tools:android-i18n [project_path]
```

---

## android-fold-adapter

Diagnose and fix Android foldable screen adaptation issues.

**Features:**
- Diagnose Activity recreation issues on fold/unfold
- Fix state loss problems (UI visibility, data fields)
- Resolve fragment reference invalidation (ViewPager2)
- Auto-update skill with new patterns/solutions
- Archive known issues for future reference

**Usage:**
```bash
/android-dev-tools:android-fold-adapter "搜索页折叠后内容消失"
```

---

## auto-ui-test

Android UI automation testing with intelligent mode selection and doc-driven testing.

**Features:**
- **Dual execution modes:** Midscene visual-driven + ADB fast execution
- **Doc-driven testing:** Parse test cases from markdown documents
- **Smart filtering:** Skip PASS cases, only test FAIL/pending cases
- **Auto report generation:** Reports saved to `docs/test/report/`
- **Intelligent mode selection:** Auto-choose best execution method

**Usage:**
```bash
# Direct execution
/android-dev-tools:auto-ui-test 点击Toast按钮，等待3秒后截图

# Doc-driven testing (parse document and execute tests)
/android-dev-tools:auto-ui-test docs/test/UI_TEST_REPORT.md
```

**Doc-driven Testing:**
- Automatically parses test cases from markdown documents
- Skips cases with `PASS` status
- Executes `FAIL`, `待验证`, or unmarked cases
- Generates report at `<project>/docs/test/report/UI_TEST_REPORT_YYYYMMDD_HHMMSS.md`

**Supported Document Formats:**
```markdown
## 测试用例: TC-001
**步骤**: 1. 点击按钮 2. 等待3秒
**状态**: FAIL          # Will be tested

## 测试用例: TC-002
**步骤**: 1. 进入设置
**状态**: PASS          # Skipped
```

**Environment Setup:**

1. **ADB installed**
   ```bash
   adb --version
   ```

2. **Start Playground CLI** (for debugging and visual operations)
   ```bash
   npx --yes @midscene/android-playground
   ```

3. **Integrate Midscene Agent** (project dependency)
   ```bash
   npm install @midscene/android --save-dev
   ```

**Detailed documentation:** https://midscenejs.com/android-getting-started.html

**Prerequisites:**
- ADB installed and in PATH
- Android device with USB debugging enabled
- Midscene Android integrated in project

---

## Installation

```bash
# 1. Add marketplace
/plugin marketplace add github.com/adzcsx2/claude_skill

# 2. Install (includes all skills)
/plugin install android-dev-tools@android-dev-tools
```

---

## Repository Structure

```
claude_skill/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   └── android-dev-tools/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── AndroidAutoRemoteSignTool/   # Built-in tool
│       │   └── remote_sign/
│       │       ├── apply_remote_sign.py
│       │       ├── apply_groovy_sign.py
│       │       ├── apply_kts_sign.py
│       │       └── ...
│       └── skills/
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
├── README.md            # Chinese
├── README_EN.md         # English
└── .gitignore
```

---

## Requirements

- Claude Code CLI
- For `apply-remote-sign`: Python 3.6+, `requests` library, JDK 11, Android SDK
- For `update-docs`: Android project with standard structure

---

## License

MIT

## Author

[adzcsx2](https://github.com/adzcsx2)
