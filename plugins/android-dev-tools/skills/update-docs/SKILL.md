---
name: update-docs
description: Auto-generate Chinese technical documentation for Android projects. Analyzes structure, generates interfaces, navigation, components, notifications, and API docs. Also migrates root md files to docs/ and updates README with quick links.
---

# update-docs Skill

Android 项目文档自动生成工具。分析项目结构，生成中文技术文档，支持增量更新。

## When to Use

- Generating project documentation for Android apps
- Creating interface documentation with control analysis
- Documenting navigation flows and Activity-Fragment relationships
- Listing Android four components (Activity, Service, Receiver, Provider)
- Documenting notification channels and API endpoints
- Migrating root directory md files to docs/ for centralized management
- Updating README with categorized doc quick links

## Example Prompts

- "/update-docs"
- "Generate documentation for my Android project"
- "Update project docs with --force"
- "Only generate interface documentation"

---

## Command Parameters

| Parameter | Description |
|-----------|-------------|
| No args | Incremental update of all docs |
| `--force` | Force regenerate all docs |
| `--dry-run` | Analyze only, don't generate files |
| `interfaces` | Generate interface docs only |
| `navigation` | Generate navigation docs only |
| `components` | Generate four components docs only |
| `notifications` | Generate notification docs only |
| `api` | Generate API docs only |

---

## Execution Flow

### 1. Verify Project Type

Check for these files:
- `settings.gradle` or `settings.gradle.kts`
- `build.gradle` or `build.gradle.kts`
- `app/src/main/AndroidManifest.xml`

Exit if not an Android project.

### 2. Load/Create Metadata

Check `docs/.doc-metadata.json`:

```json
{
  "version": "1.2",
  "projectType": "android",
  "lastUpdate": "2026-03-04T10:30:00Z",
  "lastCommit": "abc1234def5678",
  "documents": {
    "PROJECT_OVERVIEW.md": {
      "updatedAt": "2026-03-04T10:30:00Z",
      "sourceFiles": ["build.gradle", "settings.gradle"],
      "lastCommit": "abc1234"
    }
  },
  "updateHistory": [
    {
      "date": "2026-03-04",
      "type": "incremental",
      "diffFile": "update-list/update-2026-03-04.md",
      "summary": "更新接口文档、导航文档",
      "documentsUpdated": ["INTERFACES.md", "NAVIGATION.md"],
      "commits": [
        {
          "hash": "abc1234",
          "message": "修复铸造失败重试逻辑与Toast文案",
          "files": ["CastDialog.kt", "WCController.kt"]
        },
        {
          "hash": "def5678",
          "message": "重构图片加载,提高加载效率",
          "files": ["ImageUrlEx.kt", "AlbumActivity.kt"]
        }
      ],
      "filesMigrated": {
        "深色模式适配.md": "docs/features/dark-mode.md"
      }
    }
  ],
  "stats": {
    "totalUpdates": 15,
    "firstUpdate": "2026-01-01",
    "lastUpdate": "2026-03-04"
  }
}
```

**Metadata Fields:**
- `version`: Metadata schema version
- `updateHistory`: Array of update records (most recent first)
- `stats`: Aggregate statistics

### 3. Analyze Git Changes (Primary Source)

**IMPORTANT: Git log is the primary source of truth for change detection.**

```bash
# Get commits since last update (from metadata)
git log --since="2026-03-01" --oneline --no-merges

# Get changed files in recent commits
git diff HEAD~5 --name-only

# Get detailed commit info with file changes
git log -5 --pretty=format:"%h|%s|%ad" --date=short --no-merges

# Get diff stats for specific files
git diff HEAD~5 --stat -- "*.kt" "*.java"
```

**Git-based Change Detection:**
1. Read `docs/.doc-metadata.json` to get `lastUpdate` date
2. Run `git log --since="{lastUpdate}" --oneline --no-merges` to get new commits
3. For each commit, get changed files: `git diff-tree --no-commit-id --name-only -r {commit}`
4. Map changed files to affected documents (see mapping table below)
5. Store commit messages for update summary generation

**File to Document Mapping:**
| Source File Pattern | Affected Documents |
|---------------------|-------------------|
| `**/*Activity.kt`, `**/*Activity.java` | INTERFACES.md, NAVIGATION.md |
| `**/*Fragment.kt`, `**/*Fragment.java` | INTERFACES.md, NAVIGATION.md |
| `**/res/layout/*.xml` | INTERFACES.md |
| `**/http/*Api.kt`, `**/api/*.kt` | API.md |
| `AndroidManifest.xml` | COMPONENTS.md, NAVIGATION.md |
| `build.gradle`, `build.gradle.kts` | BUILD_VARIANTS.md, DEPENDENCIES.md |
| `**/notification/*`, `*Notification*.kt` | NOTIFICATIONS.md |

### 3.5. Fallback: File Modification Time

If git is not available or no commits found, fall back to file modification time:

```bash
# macOS file modification time
stat -f %m "filePath"

# Linux file modification time
stat -c %Y "filePath"
```

If `--force` is true, mark all docs for update.

### 4. Analyze Project

#### 4.1 Analyze AndroidManifest.xml
Extract: applicationId, versionCode, versionName, four components list, permissions list

#### 4.2 Analyze build.gradle
Extract: compileSdkVersion, buildTypes, productFlavors, dependencies

#### 4.3 Analyze Activity/Fragment
Use Glob to find: `**/*Activity.java`, `**/*Activity.kt`, `**/*Fragment.java`, `**/*Fragment.kt`

Analyze:
- setContentView() or binding for layout file
- startActivity() for navigation
- FragmentTransaction for Fragment switching
- findViewById() for controls

#### 4.4 Analyze Layout Files
Use Glob: `**/res/layout/*.xml`

Extract all `android:id` controls, record type and ID.

#### 4.5 Analyze Notification Config
Use Grep: `NotificationChannel`, `NotificationManager`

#### 4.6 Analyze API Interfaces
Use Grep: `@GET`, `@POST`, `@PUT`, `@DELETE`

### 5. Migrate Root MD Files to docs/

Scan root directory for markdown files (excluding README.md):

```bash
ls -1 *.md 2>/dev/null | grep -v "README.md"
```

For each root md file:

1. **Analyze content** - Determine category based on content:
   - API/接口相关 → `docs/api/`
   - 功能/特性相关 → `docs/features/`
   - 开发规范 → `docs/development/`
   - 架构相关 → `docs/architecture/`
   - 其他 → `docs/`

2. **Check for duplicates** - If similar file exists in docs/:
   - Compare content detail level
   - Keep more detailed version
   - Merge if complementary

3. **Move file** - Copy content to docs/ and delete root file:
   ```
   Root: 深色模式代码适配文档.md
   → docs/features/dark-mode.md
   ```

4. **Record migration** in metadata:
   ```json
   {
     "migratedFiles": {
       "深色模式代码适配文档.md": "docs/features/dark-mode.md"
     }
   }
   ```

### 6. Generate Documents

All docs go in `docs/` directory:

| Document | Content |
|----------|---------|
| PROJECT_OVERVIEW.md | Project overview |
| INTERFACES.md | Interface docs (control analysis, functionality) |
| NAVIGATION.md | Navigation docs (Activity-Fragment relationships) |
| COMPONENTS.md | Four components docs |
| NOTIFICATIONS.md | Notification docs |
| BUILD_VARIANTS.md | Build variants docs |
| DEPENDENCIES.md | Dependencies docs |
| API.md | API interface docs (URL and method) |
| CHANGELOG.md | Doc update changelog |
| UPDATE_INDEX.md | Update list index with links |
| update-list/*.md | Diff documents for each update |

### 6.5. Generate Update Diff Document

Generate a diff document in `docs/update-list/` for each update:

1. **Create update-list directory** if not exists:
```bash
mkdir -p docs/update-list
```

2. **Generate diff filename**:
- Format: `update-YYYY-MM-DD.md`
- If file exists for today, append timestamp: `update-YYYY-MM-DD-HHMM.md`

3. **Collect Git Commit Information (PRIMARY)**:
```bash
# Get commits since last update
git log --since="{lastUpdate}" --pretty=format:"%h|%s|%b|%ad" --date=short --no-merges

# Get changed files per commit
for commit in $(git log --since="{lastUpdate}" --format="%h" --no-merges); do
  echo "=== $commit ==="
  git diff-tree --no-commit-id --name-only -r $commit
done
```

4. **Generate Summary from Commits**:
- Extract commit messages as the primary source for "变更摘要"
- Group related commits by feature/module
- Use commit body for detailed descriptions if available

5. **Collect change information**:
- List all documents updated in this run
- Record change type (new/modified/deleted)
- Record trigger commits and source files

6. **Write diff document**:

```markdown
# 更新详情 - YYYY-MM-DD

## 更新概览
- **更新时间**: YYYY-MM-DD HH:MM:SS
- **更新类型**: 增量更新 / 全量更新
- **触发方式**: Git 提交分析 / 源文件变更检测 / --force 强制更新
- **提交范围**: abc1234..def5678 (N commits)

## Git 提交记录

| 提交 | 描述 | 变更文件 |
|------|------|----------|
| abc1234 | 修复铸造失败重试逻辑 | `CastDialog.kt`, `WCController.kt` |
| def5678 | 重构图片加载效率 | `ImageUrlEx.kt`, `AlbumActivity.kt` |

## 更新的文档

### {DOCUMENT_NAME}.md
- **变更类型**: 新增 / 修改
- **关联提交**: abc1234, def5678
- **触发源文件**:
  - `path/to/source/file.kt` (commit: abc1234)
  - `path/to/layout.xml` (commit: def5678)
- **变更摘要**: 从 commit message 提取的真实变更描述

## 迁移的文件
- `原文件名.md` → `docs/category/新文件名.md`

## 元数据变更
- `.doc-metadata.json` 更新时间戳和提交记录
```

### 6.6. Update UPDATE_INDEX.md

Maintain the update list index document:

1. **Create or update** `docs/UPDATE_INDEX.md`:

```markdown
# 文档更新记录

> 本文档由 update-docs 自动维护

[查看所有更新详情](update-list/)

---

## 更新历史

| 日期 | 类型 | 描述 | 详情 |
|------|------|------|------|
| YYYY-MM-DD | 增量 | 更新内容摘要 | [查看](update-list/update-YYYY-MM-DD.md) |
| ... | ... | ... | ... |

---

## 统计信息

- 总更新次数: N
- 最近更新: YYYY-MM-DD
```

2. **Insert new record** at the TOP of the history table

3. **Keep record limit**: Default 20 records, archive older ones if needed

4. **Update statistics** section

### 7. Update README with Doc Links

Update `README.md` at project root with categorized doc links and recent updates:

```markdown
## 文档导航

> 快速访问: [文档中心](docs/README.md) | [更新记录](docs/UPDATE_INDEX.md)

### 最近更新

| 日期 | 描述 |
|------|------|
| YYYY-MM-DD | 更新内容摘要 |
| YYYY-MM-DD | 更新内容摘要 |
| YYYY-MM-DD | 更新内容摘要 |

> 查看全部更新: [更新记录](docs/UPDATE_INDEX.md)

---

### 快速开始
| 文档 | 描述 |
|------|------|
| [环境配置](docs/getting-started/installation.md) | 开发环境配置与依赖安装 |
| [构建指南](docs/getting-started/building.md) | 构建命令与多环境配置 |

### 功能文档
| 文档 | 描述 |
|------|------|
| [深色模式适配](docs/features/dark-mode.md) | 深色模式代码适配指南 |
| [颜色映射规则](docs/features/color-mapping.md) | 深色模式颜色映射规则 |

### API 文档
| 文档 | 描述 |
|------|------|
| [接口文档](docs/api/endpoints.md) | 后端 API 接口汇总 |
```

**README Update Rules:**
1. **Doc navigation section**: Include links to docs/README.md and UPDATE_INDEX.md
2. **Recent updates section**: Show exactly 3 most recent updates with date and summary
3. **"View all" link**: Point to UPDATE_INDEX.md for complete history
4. **Use markers** for easy insertion:
```markdown
<!-- DOCS_NAV_START -->
... 文档导航内容 ...
<!-- DOCS_NAV_END -->
```
5. **If markers not found**: Insert after first `##` heading or at file beginning

**Link Format Rules:**
- Use relative paths: `docs/features/dark-mode.md`
- Group by category with clear headers
- Add description for each document

### 8. Update Metadata

Update `docs/.doc-metadata.json` with:

1. **Update timestamps** for modified documents
2. **Update lastCommit** to current HEAD:
```bash
git rev-parse HEAD
```
3. **Append to updateHistory** array with commit info:
```json
{
  "date": "2026-03-11",
  "type": "incremental",
  "diffFile": "update-list/update-2026-03-11.md",
  "summary": "从 commit messages 提取的摘要",
  "documentsUpdated": ["INTERFACES.md", "NAVIGATION.md"],
  "commits": [
    {
      "hash": "abc1234",
      "message": "修复铸造失败重试逻辑与Toast文案",
      "files": ["CastDialog.kt", "WCController.kt"]
    }
  ],
  "filesMigrated": {}
}
```
4. **Update stats** section:
```json
{
  "stats": {
    "totalUpdates": 16,
    "firstUpdate": "2026-01-01",
    "lastUpdate": "2026-03-11"
  }
}
```
5. **Append to CHANGELOG.md** with update summary derived from commits

---

## Analysis Patterns

### Activity Jump Detection
```
startActivity\(new Intent\(.*?,\s*(\w+Activity)\.class\)\)
ActivityUtil\.next\(.*?,\s*(\w+Activity)\.class\)
(\w+Activity)\.start\(
```

### Fragment Switch Detection
```
beginTransaction\(\)[\s\S]*?replace\((\w+),\s*(\w+Fragment)
viewPager\.setCurrentItem\((\d+)\)
```

### Control Detection
```
findViewById\(R\.id\.(\w+)\)
binding\.(\w+)
android:onClick="(\w+)"
```

### Notification Channel Detection
```
NotificationChannel\(["']([^"']+)["'],\s*["']([^"']+)["']
```

### API Interface Detection
```
@GET\(["']([^"']+)["']\)
@POST\(["']([^"']+)["']\)
["'](https?://[^"']+)["']
["'](\/api\/[^"']+)["']
```

---

## Control Type Mapping

| XML Tag | Type | Category |
|---------|------|----------|
| TextView | TextView | Display |
| EditText | EditText | Input |
| Button | Button | Interactive |
| ImageButton | ImageButton | Interactive |
| ImageView | ImageView | Display |
| RecyclerView | RecyclerView | Container |
| ViewPager2 | ViewPager2 | Container |
| CheckBox | CheckBox | Input |
| Switch | Switch | Input |

---

## Function Description Inference

- LoginActivity → User login interface
- MainActivity → App main interface
- SettingActivity → Settings interface
- MessageActivity → Message details interface
- ChatActivity → Chat interface

---

## Notes

1. All documents are written in **Chinese**
2. Time format uses ISO 8601 standard
3. Add `.doc-metadata.json` to .gitignore
4. Record each update in CHANGELOG.md
5. Root md files are migrated to docs/ and deleted from root
6. README.md is preserved and updated with doc links
7. Duplicate detection: keep more detailed version when merging
8. **Update list**: Each update generates a diff document in `docs/update-list/`
9. **UPDATE_INDEX.md**: Maintains update history with clickable links
10. **README integration**: Shows last 3 updates with link to full history
11. **Record limit**: UPDATE_INDEX.md keeps 20 records by default
12. **Same-day updates**: Append to existing file or create timestamped version
13. **Git-based detection**: Primary source of truth is git commits, not file modification time
14. **Commit messages**: Used as the source for "变更摘要" in update documents
15. **Commit tracking**: Each update record includes associated commit hashes and messages
