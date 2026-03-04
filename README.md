# Android Dev Tools - Claude Code Marketplace

Android development tools for Claude Code. This marketplace contains plugins for build performance optimization, remote APK signing, documentation generation, and marketplace management.

## Plugins

### android-dev-tools (Marketplace Management)

Marketplace management tools for this repository.

**Usage:** `/plugin android-dev-tools:update`

**Features:**
- Sync marketplace.json with plugins directory
- Auto-bump versions on plugin changes
- Add/remove plugins from marketplace
- Commit and push updates

---

### gradle-build-performance

Debug and optimize Android/Gradle build performance.

**Features:**
- Analyze Gradle build scans
- Identify configuration vs execution bottlenecks
- Enable configuration cache
- Optimize CI/CD build times
- Debug kapt/KSP annotation processing

**Usage:** `/gradle-build-performance:gradle-build-performance`

---

### apply-remote-sign

Auto-configure remote APK signing for Android projects.

**Features:**
- Supports Groovy DSL (`build.gradle`) and Kotlin DSL (`build.gradle.kts`)
- Creates `.env.example` template
- Updates `.gitignore` and `gradle.properties`
- Integrates signing tasks into build scripts
- **Includes AndroidAutoRemoteSignTool** (built-in)

**Usage:** `/apply-remote-sign:apply-remote-sign [project_path] [--modules module1,module2]`

---

### update-docs

Auto-generate Chinese technical documentation for Android projects.

**Features:**
- Analyzes project structure
- Generates interface documentation (controls, functionality)
- Documents navigation flows (Activity-Fragment relationships)
- Lists four components (Activity, Service, Receiver, Provider)
- Documents notification channels and API endpoints
- Supports incremental updates

**Usage:** `/update-docs:update-docs [--force] [--dry-run] [interfaces|navigation|components|notifications|api]`

---

## Installation

### Add Marketplace

```bash
/plugin marketplace add github.com/adzcsx2/claude_skill
```

### Install Plugins

```bash
# Install marketplace management tool
/plugin install android-dev-tools@android-dev-tools

# Install other plugins
/plugin install gradle-build-performance@android-dev-tools
/plugin install apply-remote-sign@android-dev-tools
/plugin install update-docs@android-dev-tools
```

### List Available Plugins

```bash
/plugin marketplace list
/plugin list
```

---

## Repository Structure

```
claude_skill/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace catalog
├── plugins/
│   ├── android-dev-tools/        # Marketplace management
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   └── skills/
│   │       └── update/
│   │           └── SKILL.md
│   ├── gradle-build-performance/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   └── skills/
│   │       └── gradle-build-performance/
│   │           └── SKILL.md
│   ├── apply-remote-sign/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   ├── skills/
│   │   │   └── apply-remote-sign/
│   │   │       └── SKILL.md
│   │   └── AndroidAutoRemoteSignTool/  # Built-in tool
│   │       └── remote_sign/
│   │           ├── apply_remote_sign.py
│   │           ├── apply_groovy_sign.py
│   │           ├── apply_kts_sign.py
│   │           └── ...
│   └── update-docs/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       └── skills/
│           └── update-docs/
│               └── SKILL.md
└── README.md
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
