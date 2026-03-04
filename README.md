# Android Dev Tools - Claude Code Plugin

[中文文档](./README_CN.md)

All-in-one Android development toolkit for Claude Code. Install once, get everything.

## Included Skills

| Skill | Description |
|-------|-------------|
| `gradle-build-performance` | Debug and optimize Gradle build performance |
| `apply-remote-sign` | Auto-configure remote APK signing |
| `update-docs` | Generate Chinese technical documentation |
| `update-remote-plugins` | Sync marketplace.json and README files |

---

## gradle-build-performance

Debug and optimize Android/Gradle build performance.

**Features:**
- Analyze Gradle build scans
- Identify configuration vs execution bottlenecks
- Enable configuration cache
- Optimize CI/CD build times
- Debug kapt/KSP annotation processing

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

**Usage:**
```bash
/android-dev-tools:update-docs [--force] [--dry-run] [interfaces|navigation|components|notifications|api]
```

---

## update-remote-plugins

Sync marketplace.json with plugins directory and update README files.

**Features:**
- Scan plugins directory for changes
- Auto-bump versions on plugin modifications
- Add/remove plugins from marketplace.json
- Sync English and Chinese README files
- Commit and push to remote

**Usage:** `/android-dev-tools:update-remote-plugins`

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
│           └── update-remote-plugins/
│               └── SKILL.md
├── README.md            # English
├── README_CN.md         # Chinese
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
