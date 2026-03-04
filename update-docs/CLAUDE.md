# update-docs Skill

Android 项目文档自动生成工具。分析项目结构，生成中文技术文档，支持增量更新。

## 触发方式

当用户输入 `/update-docs` 或请求生成项目文档时，按照以下流程执行。

## 命令参数

| 参数 | 说明 |
|------|------|
| 无参数 | 增量更新所有文档 |
| `--force` | 强制重新生成所有文档 |
| `--dry-run` | 仅分析不生成文件，预览将要更新的内容 |
| `interfaces` | 仅生成界面文档 |
| `navigation` | 仅生成导航文档 |
| `components` | 仅生成四大组件文档 |
| `notifications` | 仅生成通知文档 |
| `api` | 仅生成 API 文档 |

## 执行流程

### 1. 验证项目类型

检查以下文件是否存在：
- `settings.gradle` 或 `settings.gradle.kts`
- `build.gradle` 或 `build.gradle.kts`
- `app/src/main/AndroidManifest.xml`

如果不是 Android 项目，提示用户并退出。

### 2. 加载/创建元数据

检查 `docs/.doc-metadata.json`：

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

### 3. 判断需要更新的文档

```bash
# macOS 获取文件修改时间
stat -f %m "filePath"

# Linux 获取文件修改时间
stat -c %Y "filePath"
```

如果 `--force` 为 true，标记所有文档需要更新。
如果源文件修改时间 > 文档更新时间，标记需要更新。

### 4. 分析项目

#### 4.1 分析 AndroidManifest.xml
提取：applicationId, versionCode, versionName, 四大组件列表, 权限列表

#### 4.2 分析 build.gradle
提取：compileSdkVersion, buildTypes, productFlavors, dependencies

#### 4.3 分析 Activity/Fragment
使用 Glob 查找：`**/*Activity.java`, `**/*Activity.kt`, `**/*Fragment.java`, `**/*Fragment.kt`

分析内容：
- setContentView() 或 binding 获取布局文件
- startActivity() 分析跳转关系
- FragmentTransaction 分析 Fragment 切换
- findViewById() 获取控件

#### 4.4 分析布局文件
使用 Glob 查找：`**/res/layout/*.xml`

提取所有 `android:id` 控件，记录类型和 ID。

#### 4.5 分析通知配置
使用 Grep 搜索：`NotificationChannel`, `NotificationManager`

#### 4.6 分析 API 接口
使用 Grep 搜索：`@GET`, `@POST`, `@PUT`, `@DELETE`

### 5. 生成文档

所有文档放在 `docs/` 目录下：

| 文档 | 内容 |
|------|------|
| PROJECT_OVERVIEW.md | 项目概览 |
| INTERFACES.md | 界面文档（控件分析、功能说明） |
| NAVIGATION.md | 导航文档（Activity-Fragment 关系、跳转关系） |
| COMPONENTS.md | 四大组件文档 |
| NOTIFICATIONS.md | 通知文档 |
| BUILD_VARIANTS.md | 构建变体文档 |
| DEPENDENCIES.md | 依赖库文档 |
| API.md | API 接口文档（URL 和方法） |
| CHANGELOG.md | 文档更新日志 |

同时在项目根目录生成 `README.md` 包含文档索引和构建变体说明。

### 6. 更新元数据

更新 `docs/.doc-metadata.json` 中的时间戳，追加更新记录到 `CHANGELOG.md`。

## 文档模板

### PROJECT_OVERVIEW.md
```markdown
# 项目概览

## 基本信息

| 属性 | 值 |
|-----|-----|
| 项目名称 | {projectName} |
| 应用ID | {applicationId} |
| 版本号 | {versionName} ({versionCode}) |
| 最低SDK | {minSdkVersion} |
| 目标SDK | {targetSdkVersion} |

## 项目结构
{directoryStructure}

## 技术栈
{techStack}
```

### INTERFACES.md
```markdown
# 界面文档

## Activity 列表

### {ActivityName}

**文件路径**: `{file_path}`
**布局文件**: `{layout_file}`
**功能描述**: {description}

#### 控件列表

| 控件ID | 类型 | 功能说明 |
|--------|------|----------|
| {id} | {type} | {function} |

#### 包含的 Fragment
{fragment_list}

## Fragment 列表

### {FragmentName}

**文件路径**: `{file_path}`
**布局文件**: `{layout_file}`
**功能描述**: {description}

#### 控件列表

| 控件ID | 类型 | 功能说明 |
|--------|------|----------|
| {id} | {type} | {function} |
```

### NAVIGATION.md
```markdown
# 导航文档

## Activity 导航图

### {ActivityName}

#### 包含的 Fragment
| Fragment | 描述 |
|----------|------|
| {fragment_name} | {description} |

#### 按钮跳转关系
| 触发控件 | 目标 Activity | 跳转方式 |
|----------|---------------|----------|
| {button_id} | {target_activity} | startActivity |

#### Fragment 切换关系
| 触发控件 | 源 Fragment | 目标 Fragment |
|----------|-------------|---------------|
| {control_id} | {source} | {target} |

## 导航流程图

MainActivity
├── ChatNewFragment
│   └── [消息点击] -> MessageActivity
└── ProfileFragment
    └── [设置点击] -> SettingActivity
```

### COMPONENTS.md
```markdown
# 四大组件文档

## Activity 列表

| Activity | 启动模式 | 导出 | 功能描述 |
|----------|----------|------|----------|
| {name} | {launchMode} | {exported} | {description} |

## Service 列表

| Service | 导出 | 功能描述 |
|---------|------|----------|
| {name} | {exported} | {description} |

## BroadcastReceiver 列表

| Receiver | 导出 | 监听Action | 功能描述 |
|----------|------|------------|----------|
| {name} | {exported} | {actions} | {description} |

## ContentProvider 列表

| Provider | 导出 | Authority | 功能描述 |
|----------|------|-----------|----------|
| {name} | {exported} | {authority} | {description} |
```

### NOTIFICATIONS.md
```markdown
# 通知文档

## 通知渠道配置

| 渠道ID | 渠道名称 | 重要性 | 描述 |
|--------|----------|--------|------|
| {channel_id} | {channel_name} | {importance} | {description} |

## 通知类型

| 通知类型 | 渠道 | 触发场景 | 描述 |
|----------|------|----------|------|
| {type} | {channel} | {trigger} | {description} |
```

### BUILD_VARIANTS.md
```markdown
# 构建变体

## Build Types

| 类型 | 混淆 | 签名 | 调试 |
|-----|------|------|------|
| debug | 否 | Debug | 是 |
| release | 是 | Release | 否 |

## Product Flavors
{flavorDetails}

## 构建命令

./gradlew assembleDebug
./gradlew assembleRelease
./gradlew assemble{Flavor}Debug
```

### DEPENDENCIES.md
```markdown
# 依赖库

## AndroidX 依赖

| 库名 | 版本 | 用途 |
|-----|------|------|
| {library} | {version} | {purpose} |

## 第三方库

| 库名 | 版本 | 用途 |
|-----|------|------|
| {library} | {version} | {purpose} |
```

### API.md
```markdown
# API 接口文档

## 接口列表

### 用户模块

| 接口URL | 方法 | 描述 |
|---------|------|------|
| {url} | {method} | {description} |

### 消息模块

| 接口URL | 方法 | 描述 |
|---------|------|------|
| {url} | {method} | {description} |
```

### CHANGELOG.md
```markdown
# 文档更新日志

## {date}

### 更新内容
{updateItems}

### 变更文件
- {changedFiles}
```

## 分析模式

### Activity 跳转检测
```
startActivity\(new Intent\(.*?,\s*(\w+Activity)\.class\)\)
ActivityUtil\.next\(.*?,\s*(\w+Activity)\.class\)
(\w+Activity)\.start\(
```

### Fragment 切换检测
```
beginTransaction\(\)[\s\S]*?replace\((\w+),\s*(\w+Fragment)
viewPager\.setCurrentItem\((\d+)\)
```

### 控件检测
```
findViewById\(R\.id\.(\w+)\)
binding\.(\w+)
android:onClick="(\w+)"
```

### 通知渠道检测
```
NotificationChannel\(["']([^"']+)["'],\s*["']([^"']+)["']
```

### API 接口检测
```
@GET\(["']([^"']+)["']\)
@POST\(["']([^"']+)["']\)
["'](https?://[^"']+)["']
["'](\/api\/[^"']+)["']
```

## 控件类型映射

| XML 标签 | 类型 | 分类 |
|----------|------|------|
| TextView | TextView | 显示类 |
| EditText | EditText | 输入类 |
| Button | Button | 交互类 |
| ImageButton | ImageButton | 交互类 |
| ImageView | ImageView | 显示类 |
| RecyclerView | RecyclerView | 容器类 |
| ViewPager2 | ViewPager2 | 容器类 |
| CheckBox | CheckBox | 输入类 |
| Switch | Switch | 输入类 |

## 功能描述推断

- LoginActivity → 用户登录界面
- MainActivity → 应用主界面
- SettingActivity → 设置界面
- MessageActivity → 消息详情界面
- ChatActivity → 聊天界面

## 注意事项

1. 所有文档使用**中文**编写
2. 时间格式使用 ISO 8601 标准
3. 元数据文件 `.doc-metadata.json` 添加到 .gitignore
4. 每次更新记录到 CHANGELOG.md
