---
name: install-all
description: Install all plugins from this marketplace. Run after adding the marketplace to install everything at once.
---

# Install All Plugins

Install all available plugins from the android-dev-tools marketplace.

## When to Use

- After adding the marketplace for the first time
- When you want all Android development tools installed
- Fresh setup of Claude Code for Android development

## Trigger

```
/plugin android-dev-tools:install-all
```

---

## Execution

### 1. Read Marketplace Plugins

Read the marketplace.json to get all available plugins:

```bash
cat .claude-plugin/marketplace.json
```

Extract plugin names from the `plugins` array.

### 2. Install Each Plugin

For each plugin (except android-dev-tools itself), run:

```bash
/plugin install {plugin-name}@android-dev-tools
```

### 3. Installation Order

Install in this order:
1. gradle-build-performance
2. apply-remote-sign
3. update-docs

### 4. Verify Installation

After installation, verify all plugins are installed:

```bash
/plugin list
```

---

## Example Output

```
Installing all plugins from android-dev-tools marketplace...

✓ Installing gradle-build-performance@android-dev-tools...
✓ Installing apply-remote-sign@android-dev-tools...
✓ Installing update-docs@android-dev-tools...

Done! All plugins installed.
```

---

## Notes

1. Requires the marketplace to be added first: `/plugin marketplace add github.com/adzcsx2/claude_skill`
2. Skips android-dev-tools (already installed if running this skill)
3. If a plugin is already installed, it will be skipped or updated
