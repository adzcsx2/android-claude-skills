# Android Dev Tools

All-in-one Android development toolkit for Claude Code.

## Version

2.0.1

## Included Skills

| Skill | Description |
|-------|-------------|
| `apply-remote-sign` | Automatically configure remote APK signing for Android projects. Supports Groovy DSL (build.gradle) and Kotlin DSL (build.gradle.kts). |
| `gradle-build-performance` | Debug and optimize Android/Gradle build performance. Use when builds are slow, investigating CI/CD performance, analyzing build scans, or identifying compilation bottlenecks. |
| `update-docs` | Auto-generate Chinese technical documentation for Android projects. Analyzes structure, generates interfaces, navigation, components, notifications, and API docs. |
| `update-remote-plugins` | Sync marketplace.json, plugin.json, and README files, then commit and push to remote. |

## Usage

```bash
# Configure remote signing
/android-dev-tools:apply-remote-sign

# Debug build performance
/android-dev-tools:gradle-build-performance

# Generate documentation
/android-dev-tools:update-docs

# Sync and publish plugin updates
/android-dev-tools:update-remote-plugins
```

## Author

**adzcsx2** - [GitHub](https://github.com/adzcsx2)
