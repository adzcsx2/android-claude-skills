---
name: update-remote-plugins
description: Sync marketplace.json, plugin.json, and README files, then commit and push to remote. Also syncs changes to local Claude Code plugins directory.
---

# Update Remote Plugins

Sync marketplace.json with plugins directory, update both English and Chinese README files, then commit and push to remote.

## When to Use

- After modifying any skill in `plugins/` directory
- To release a new version of the plugin
- To sync English and Chinese documentation

## Trigger

```
/android-dev-tools:update-remote-plugins
```

---

## Workflow

### 1. Scan Skills Directory

List all skills in the plugin:
```bash
ls -1 plugins/android-dev-tools/skills/
```

For each skill, read its SKILL.md to get name and description.

### 2. Detect Changes

Check if any file changed since last commit:
```bash
git diff HEAD --name-only -- plugins/
```

If changes detected, determine version bump:
- **Bug fix / minor update** → patch (+0.0.1): 1.0.0 → 1.0.1
- **New skill / feature** → minor (+0.1.0): 1.0.0 → 1.1.0
- **Breaking change** → major (+1.0.0): 1.0.0 → 2.0.0

### 3. Update plugin.json

Update version in `plugins/android-dev-tools/.claude-plugin/plugin.json`.

### 4. Update marketplace.json

Update version in `.claude-plugin/marketplace.json`.

### 5. Sync README Files

**README.md (English)** - Update skills table:
```markdown
## Included Skills

| Skill | Description |
|-------|-------------|
| `skill-name` | Description from SKILL.md |
...
```

**README_CN.md (Chinese)** - Sync with English version:
- Translate any new content
- Keep structure identical
- Update skills table

### 6. Commit and Push

```bash
git add -A
git commit -m "chore: update plugin to v{version} - {changes summary}"
git push
```

### 7. Sync Local Plugins

After successful push, sync changes to local Claude Code plugins directory:

**Target Directory**: `~/.claude/plugins/cache/android-dev-tools/`

**Sync Process**:

1. **Determine target path**:
   ```
   ~/.claude/plugins/cache/android-dev-tools/android-dev-tools/{version}/
   ```

2. **Copy updated files**:
   ```bash
   # Copy skills
   cp -r plugins/android-dev-tools/skills/* ~/.claude/plugins/cache/android-dev-tools/android-dev-tools/{version}/skills/

   # Copy plugin.json
   cp plugins/android-dev-tools/.claude-plugin/plugin.json ~/.claude/plugins/cache/android-dev-tools/android-dev-tools/{version}/.claude-plugin/

   # Copy README files
   cp README.md README_CN.md ~/.claude/plugins/cache/android-dev-tools/android-dev-tools/{version}/
   ```

3. **Verify sync**:
   - Check all skill files exist
   - Verify plugin.json version matches
   - Confirm README files are updated

4. **Log sync result**:
   ```
   ✅ Synced {N} skills to local plugins
   ✅ Updated plugin.json to v{version}
   ✅ Synced README files
   ```

---

## README Sync Rules

When syncing README.md and README_CN.md:

1. **Structure must match** - Same sections in same order
2. **Skills table** - Update both English and Chinese versions
3. **New skills** - Add to both files with translated description
4. **Removed skills** - Remove from both files
5. **Version number** - Update in both files

---

## Example Execution

```bash
# 1. Check for changes
CHANGES=$(git diff HEAD --name-only -- plugins/)

# 2. If changes exist, bump version
if [ -n "$CHANGES" ]; then
  # Read current version
  CURRENT=$(cat plugins/android-dev-tools/.claude-plugin/plugin.json | grep '"version"' | cut -d'"' -f4)

  # Bump patch version
  NEW_VERSION=$(echo $CURRENT | awk -F. '{$NF++;print}')

  # Update plugin.json
  # Update marketplace.json
fi

# 3. Update README files
# Sync skills table between README.md and README_CN.md

# 4. Commit and push
git add -A
git commit -m "chore: update to v$NEW_VERSION"
git push

# 5. Sync to local plugins (after successful push)
LOCAL_PATH="$HOME/.claude/plugins/cache/android-dev-tools/android-dev-tools/$NEW_VERSION"
cp -r plugins/android-dev-tools/skills/* "$LOCAL_PATH/skills/"
cp plugins/android-dev-tools/.claude-plugin/plugin.json "$LOCAL_PATH/.claude-plugin/"
cp README.md README_CN.md "$LOCAL_PATH/"
echo "✅ Synced to local plugins: $LOCAL_PATH"
```

---

## Notes

1. Always run from the marketplace root directory
2. Ensure git is configured with push access
3. Keep README.md and README_CN.md synchronized
4. Version format: semver (major.minor.patch)
5. Local sync only happens after successful push
6. Local plugins path: `~/.claude/plugins/cache/android-dev-tools/`
7. If local sync fails, remote changes are already pushed (manual sync needed)
