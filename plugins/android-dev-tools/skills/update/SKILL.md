---
name: update
description: Sync marketplace.json with plugins directory. Bump versions on changes, add/remove plugins, then commit and push.
---

# Marketplace Update Skill

Automatically sync `.claude-plugin/marketplace.json` with the `plugins/` directory.

## When to Use

- After modifying any plugin in `plugins/` directory
- After adding a new plugin
- After removing a plugin
- To release a new version of your marketplace

## Trigger

```
/plugin android-dev-tools:update
```

---

## Workflow

### 1. Scan Plugins Directory

```bash
ls -1 plugins/
```

For each plugin directory, read its `plugin.json`:
```bash
cat plugins/{plugin-name}/.claude-plugin/plugin.json
```

### 2. Compare with Marketplace.json

Read current marketplace.json:
```bash
cat .claude-plugin/marketplace.json
```

Compare:
- **New plugin found** → Add to marketplace.json with version from plugin.json
- **Plugin removed** → Remove from marketplace.json
- **Plugin modified** → Bump version (patch +1)

### 3. Detect Plugin Modifications

For each plugin, check if any file changed since last commit:
```bash
git diff HEAD~1 --name-only -- plugins/{plugin-name}/
```

If changes detected, bump version:
- Current: `1.2.3` → New: `1.2.4` (patch)
- Or follow semver: major/minor/patch based on change type

### 4. Update Marketplace.json

Update the marketplace.json file:
```json
{
  "name": "android-dev-tools",
  "description": "...",
  "owner": { ... },
  "plugins": [
    {
      "name": "plugin-name",
      "source": "./plugins/plugin-name",
      "description": "from plugin.json",
      "version": "bumped version"
    }
  ]
}
```

### 5. Commit and Push

```bash
git add .claude-plugin/marketplace.json
git commit -m "chore: update marketplace - {changes summary}"
git push
```

---

## Version Bumping Rules

| Change Type | Version Bump | Example |
|-------------|--------------|---------|
| Bug fix / minor update | patch (+0.0.1) | 1.0.0 → 1.0.1 |
| New feature / skill | minor (+0.1.0) | 1.0.0 → 1.1.0 |
| Breaking change | major (+1.0.0) | 1.0.0 → 2.0.0 |
| New plugin added | use plugin.json version | - |
| Plugin removed | just remove from list | - |

---

## Execution Example

```bash
# 1. List plugins
PLUGINS=$(ls -1 plugins/)

# 2. For each plugin, get its info
for plugin in $PLUGINS; do
  if [ -f "plugins/$plugin/.claude-plugin/plugin.json" ]; then
    NAME=$(cat "plugins/$plugin/.claude-plugin/plugin.json" | grep '"name"' | cut -d'"' -f4)
    VERSION=$(cat "plugins/$plugin/.claude-plugin/plugin.json" | grep '"version"' | cut -d'"' -f4)
    DESC=$(cat "plugins/$plugin/.claude-plugin/plugin.json" | grep '"description"' | cut -d'"' -f4)
    echo "$NAME|$VERSION|$DESC"
  fi
done

# 3. Check for changes
git diff HEAD --name-only -- plugins/

# 4. Update marketplace.json (use Edit tool)

# 5. Commit and push
git add .claude-plugin/marketplace.json
git commit -m "chore: update marketplace"
git push
```

---

## Notes

1. Always run from the marketplace root directory
2. Ensure git is configured with push access
3. Plugin directories must have `.claude-plugin/plugin.json`
4. Version format: semver (major.minor.patch)
