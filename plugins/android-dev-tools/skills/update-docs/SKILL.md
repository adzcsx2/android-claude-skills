---
name: update-docs
description: Auto-generate Chinese technical documentation for Android projects. Analyzes structure, generates interfaces, navigation, components, notifications, and API docs.
---

# update-docs Skill

Android 项目文档自动生成工具。分析项目结构，生成中文技术文档，支持增量更新。

## When to Use

- Generating project documentation for Android apps
- Creating interface documentation with control analysis
- Documenting navigation flows and Activity-Fragment relationships
- Listing Android four components (Activity, Service, Receiver, Provider)
- Documenting notification channels and API endpoints

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
  "version": "1.0",
  "projectType": "android",
  "lastUpdate": "2026-03-04T10:30:00Z",
  "documents": {
    "PROJECT_OVERVIEW.md": {
      "updatedAt": "2026-03-04T10:30:00Z",
      "sourceFiles": ["build.gradle", "settings.gradle"]
    }
  }
}
```

### 3. Determine Docs to Update

```bash
# macOS file modification time
stat -f %m "filePath"

# Linux file modification time
stat -c %Y "filePath"
```

If `--force` is true, mark all docs for update.
If source file mod time > doc update time, mark for update.

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

### 5. Generate Documents

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

Also generate `README.md` at project root with doc index.

### 6. Update Metadata

Update timestamps in `docs/.doc-metadata.json`, append update records to `CHANGELOG.md`.

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
