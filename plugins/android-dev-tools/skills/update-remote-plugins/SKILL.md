---
name: update-remote-plugins
description: Sync marketplace.json, plugin.json, and README files, then commit and push to remote. Also syncs changes to local Claude Code plugins directory.
---

# Update Remote Plugins

Sync marketplace.json with plugins directory, update both English and Chinese README files, then commit and push to remote. Finally, sync to local Claude Code plugins directory.

## When to Use

- After modifying any skill in `plugins/` directory
- To release a new version of the plugin
- To sync English and Chinese documentation
- After adding new skills or updating existing ones

## Trigger

```
/android-dev-tools:update-remote-plugins
```

---

## Workflow

### 1. Pull Latest Changes

**ALWAYS start by pulling latest changes** to avoid conflicts:

```bash
git fetch origin
git pull --rebase
```

If pull fails due to uncommitted changes:
```bash
git stash
git pull --rebase
# After resolving any conflicts, restore stash if needed
```

### 2. Scan Skills Directory

List all skills in the plugin:
```bash
ls -1 plugins/android-dev-tools/skills/
```

For each skill, read its SKILL.md to get name and description.

### 3. Detect Changes

Check if any file changed since last commit:
```bash
git diff HEAD --name-only -- plugins/
```

If changes detected, determine version bump:
- **Bug fix / minor update** → patch (+0.0.1): 1.0.0 → 1.0.1
- **New skill / feature** → minor (+0.1.0): 1.0.0 → 1.1.0
- **Breaking change** → major (+1.0.0): 1.0.0 → 2.0.0

### 4. Update Configuration Files

**plugin.json** - Update version and description in `plugins/android-dev-tools/.claude-plugin/plugin.json`

**marketplace.json** - Update version in `.claude-plugin/marketplace.json`

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
- Update repository structure section

### 6. Commit and Push (Robust)

Stage and commit changes:
```bash
git add .claude-plugin/marketplace.json README.md README_CN.md plugins/android-dev-tools/
git commit -m "feat: Update plugin to v{version} - {changes summary}"
```

Push with retry logic:
```bash
# Try push, if fails due to remote changes, pull and retry
git push || {
  git pull --rebase
  # Resolve conflicts if any
  git rebase --continue  # or --abort if needed
  git push
}
```

### 7. Sync Local Plugins (CRITICAL)

**ALWAYS sync to local after successful push** - This ensures new Claude Code windows can use the updated plugin.

```bash
# Determine target path
VERSION=$(cat plugins/android-dev-tools/.claude-plugin/plugin.json | grep '"version"' | head -1 | cut -d'"' -f4)
LOCAL_PATH="$HOME/.claude/plugins/cache/android-dev-tools/android-dev-tools/$VERSION"

# Create directories
mkdir -p "$LOCAL_PATH/skills" "$LOCAL_PATH/.claude-plugin"

# Copy all files
cp -r plugins/android-dev-tools/skills/* "$LOCAL_PATH/skills/"
cp plugins/android-dev-tools/.claude-plugin/plugin.json "$LOCAL_PATH/.claude-plugin/"
cp README.md README_CN.md "$LOCAL_PATH/"

# Verify
echo "✅ Synced to local: $LOCAL_PATH"
ls -1 "$LOCAL_PATH/skills/"
```

---

## README Sync Rules

When syncing README.md and README_CN.md:

1. **Structure must match** - Same sections in same order
2. **Skills table** - Update both English and Chinese versions
3. **New skills** - Add to both files with translated description
4. **Removed skills** - Remove from both files
5. **Version number** - Update in both files
6. **Repository structure** - Update to show all skill directories

---

## Troubleshooting

### Issue 1: Push Rejected (Remote Has New Commits)

**Symptoms:**
```
! [rejected] main -> main (fetch first)
error: failed to push some refs
```

**Solution:**
```bash
git stash  # Save any uncommitted changes
git pull --rebase
# Resolve conflicts if any
git rebase --continue
git push
git stash pop  # Restore saved changes
```

### Issue 2: Merge Conflicts During Rebase

**Symptoms:**
```
CONFLICT (content): Merge conflict in <file>
```

**Solution:**
1. Read the conflicted file
2. Keep both changes (combine HEAD and incoming)
3. Remove conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
4. Stage resolved files: `git add <file>`
5. Continue: `git rebase --continue`

### Issue 3: SSH Connection Failed

**Symptoms:**
```
Connection closed by <ip> port 22
fatal: Could not read from remote repository
```

**Solution:**
Simply retry the push:
```bash
git push
```

### Issue 4: New Window Missing Updated Plugin

**Cause:** Local plugins directory not synced after push

**Solution:** Run Step 7 (Sync Local Plugins) manually:
```bash
VERSION="2.2.0"  # Replace with actual version
LOCAL_PATH="$HOME/.claude/plugins/cache/android-dev-tools/android-dev-tools/$VERSION"
mkdir -p "$LOCAL_PATH/skills" "$LOCAL_PATH/.claude-plugin"
cp -r plugins/android-dev-tools/skills/* "$LOCAL_PATH/skills/"
cp plugins/android-dev-tools/.claude-plugin/plugin.json "$LOCAL_PATH/.claude-plugin/"
cp README.md README_CN.md "$LOCAL_PATH/"
```

### Issue 5: Stash Conflicts After Rebase

**Symptoms:**
```
CONFLICT (content): Merge conflict in <file>
Auto-merging <file>
```

**Solution:**
If stash conflicts are not critical, drop the stash:
```bash
git checkout --theirs <conflicted-file>
git stash drop
```

---

## Known Issues Archive

### 2024-03: Git Rebase Conflicts During Plugin Sync

**Problem:** When adding `android-fold-adapter` skill, remote had new commits (v2.0.4). Local push was rejected, and rebase caused conflicts in marketplace.json, plugin.json, and README files.

**Root Cause:**
- Did not pull before starting work
- Remote and local both modified same files

**Fix Applied:**
1. `git pull --rebase`
2. Manually resolve conflicts by combining changes
3. `git rebase --continue`
4. `git push`

**Prevention:** Always run `git pull --rebase` before starting plugin updates.

---

## Complete Example Execution

```bash
# 1. Pull latest (ALWAYS FIRST)
git pull --rebase

# 2. Check for changes
CHANGES=$(git diff HEAD --name-only -- plugins/)

# 3. If changes exist, update version and files
if [ -n "$CHANGES" ]; then
  # Read current version and bump
  CURRENT=$(cat plugins/android-dev-tools/.claude-plugin/plugin.json | grep '"version"' | head -1 | cut -d'"' -f4)
  # ... bump version logic ...

  # Update README files
  # Sync skills table between README.md and README_CN.md
fi

# 4. Commit and push
git add .claude-plugin/marketplace.json README.md README_CN.md plugins/android-dev-tools/
git commit -m "feat: Update plugin to v$NEW_VERSION"

# Push with retry
git push || {
  git pull --rebase
  git push
}

# 5. Sync to local (ALWAYS AFTER PUSH)
LOCAL_PATH="$HOME/.claude/plugins/cache/android-dev-tools/android-dev-tools/$NEW_VERSION"
mkdir -p "$LOCAL_PATH/skills" "$LOCAL_PATH/.claude-plugin"
cp -r plugins/android-dev-tools/skills/* "$LOCAL_PATH/skills/"
cp plugins/android-dev-tools/.claude-plugin/plugin.json "$LOCAL_PATH/.claude-plugin/"
cp README.md README_CN.md "$LOCAL_PATH/"
echo "✅ Synced to local plugins: $LOCAL_PATH"
```

---

## Notes

1. **ALWAYS pull first** - Avoid conflicts by syncing with remote before starting
2. **ALWAYS sync to local** - New Claude Code windows need the updated plugin
3. Run from the marketplace root directory
4. Ensure git is configured with push access
5. Keep README.md and README_CN.md synchronized
6. Version format: semver (major.minor.patch)
7. Local plugins path: `~/.claude/plugins/cache/android-dev-tools/`
8. If push fails, pull and retry before giving up
