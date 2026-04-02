---
name: push
description: One-push release workflow: update version in docs, per-file commit, generate docs, push to remote with optional tag.
argument-hint: "[version] 例如 /push 1.2.2"
---

> **中文环境要求**
>
> 本技能运行在中文环境下，请遵循以下约定：
> - 面向用户的回复、注释、提示信息必须使用中文
> - AI 内部处理过程可以使用英文
> - 所有生成的文件必须使用 UTF-8 编码
>
> ---

# push Skill

一键发布工作流：更新文档版本号、逐文件提交、生成更新文档、推送到远程仓库。

## When to Use

- 开发完成，准备将暂存区代码推送到远程仓库
- 发版时需要更新文档版本号并创建 tag
- 需要自动生成提交信息并逐文件提交

## Example Prompts

- `/android-dev-tools:push` - 推送暂存区代码到远程
- `/android-dev-tools:push 1.2.2` - 更新文档版本号到 1.2.2，提交并打 tag

---

## Command Parameters

| Parameter | Description |
|-----------|-------------|
| No args | 逐文件提交暂存区代码，生成文档，推送到远程 |
| `X.Y.Z` | 额外将文档中的版本号更新为指定版本，并创建 tag |

---

## Execution Flow

### Step 0: Pre-flight Checks

在执行任何操作之前，验证环境是否满足要求：

```bash
# 1. 确认在 git 仓库中
git rev-parse --is-inside-work-tree

# 2. 确认 remote origin 存在
git remote get-url origin

# 3. 确认工作区干净（无未暂存的变更）
git diff --quiet

# 4. 确认暂存区有内容
git diff --cached --quiet
```

**检查结果处理**：

| 检查项 | 失败时 |
|--------|--------|
| 非 git 仓库 | 提示用户，退出 |
| 无 remote origin | 提示用户，退出 |
| 工作区不干净 | 提示用户先暂存或提交工作区变更，退出 |
| 暂存区为空 | 提示用户没有需要提交的更改，退出 |

### Step 1: Parse Arguments

从 `args` 中提取版本号（可选）。

**如果提供了版本号**，校验格式是否为 semver (`X.Y.Z`)：
- 格式不合法 → 提示用户并退出
- 格式合法 → 进入 Step 2

**如果未提供版本号** → 跳过 Step 2，直接进入 Step 3

### Step 2: Update Version in Documents (Only when version is provided)

扫描项目中的文档文件，将版本号更新为指定版本。

**重要：此步骤在 Step 3 之前执行，此步骤提交的文件不会出现在 Step 3 的暂存区扫描中。**

**需要检查并更新的文件（按优先级）**：

| 文件 | 更新内容 |
|------|----------|
| `README.md` | 版本号相关描述 |
| `README_EN.md` | 英文 README 中的版本号 |
| `docs/PROJECT_OVERVIEW.md` | 项目概览中的版本信息 |
| `docs/CHANGELOG.md` | 在顶部插入新版本记录 |
| `docs/.doc-metadata.json` | metadata 中的版本信息（如有） |
| 其他 `docs/*.md` | 任何包含旧版本号的文档 |

**版本号检测策略**：

1. 从 `README.md` 或 `docs/PROJECT_OVERVIEW.md` 中查找当前版本号
2. 使用 Grep 搜索文档中的旧版本号，**使用锚定模式**避免误匹配：
   - 匹配 `版本 X.Y.Z`、`version X.Y.Z`、`vX.Y.Z`、`版本：X.Y.Z` 等带上下文的模式
   - **不要**匹配 `minSdkVersion`、`compileSdk`、依赖库版本号等非项目版本号
   - **不要**匹配 `build.gradle`、`build.gradle.kts` 等构建配置文件
3. 搜索范围限制在 `*.md` 和 `docs/` 目录下的文件

**替换后验证**：
- 替换完成后，用 `git diff` 检查所有变更
- 向用户展示变更摘要，确认无误后提交
- 如果发现误替换，手动修正后再提交

**提交版本号变更**：
```bash
git add <changed doc files>
git commit -m "chore: bump version to X.Y.Z"
```

### Step 3: Per-File Commit for Staged Changes

**获取暂存区文件列表**：
```bash
git diff --cached --name-only
```

**对每个暂存文件生成独立 commit**。

执行逻辑（伪代码，非直接运行的脚本）：

1. 读取暂存区文件列表，按文件路径排序
2. 对每个文件：
   a. `git diff --cached -- <file>` 分析该文件的具体变更内容
   b. 根据变更内容生成 commit message（中文）
   c. `git reset HEAD -- <file>` 将文件从暂存区取出
   d. `git add <file>` 重新暂存该文件
   e. `git commit -m "<message>"` 提交
   f. **如果 commit 失败**（如 pre-commit hook 拒绝）→ 停止循环，保留当前状态，提示用户处理

**Commit message 生成规则**：

| 变更类型 | type | 示例 |
|----------|------|------|
| 新增功能/文件 | `feat` | `feat: 新增 UserViewModel 用户状态管理` |
| Bug 修复 | `fix` | `fix: 修复登录页面输入框焦点丢失问题` |
| 重构 | `refactor` | `refactor: 重构网络请求拦截器结构` |
| 文档 | `docs` | `docs: 更新 API 接口说明文档` |
| 配置/构建 | `chore` | `chore: 更新 Gradle 依赖版本` |
| 样式/资源 | `style` | `style: 更新登录页面布局样式` |

**Commit message 要求**：
- 使用中文描述
- 根据文件变更内容自动判断 type
- 描述要具体，包含文件中的关键变更点
- 保持简洁，一行描述清楚即可

### Step 4: Generate Update Documents

读取并执行 `update-docs` skill 的指令来生成项目更新文档：

1. 读取 `plugins/android-dev-tools/skills/update-docs/SKILL.md`
2. 按照 update-docs 的执行流程生成文档

文档生成完成后，检查是否有文档变更：

```bash
git diff --name-only -- docs/
```

如果有变更，提交：
```bash
git add docs/
git commit -m "docs: 更新项目文档"
```

如果文档没有变化，跳过此提交。

### Step 5: Push to Remote

**推送代码**：
```bash
git push origin HEAD
```

**如果推送失败**（远程有新提交），执行以下重试流程：

```bash
git pull --rebase
```

- **如果 rebase 无冲突** → 直接 `git push origin HEAD`
- **如果有冲突**：
  1. 读取冲突文件，尝试自动解决（保留双方变更）
  2. 如果能解决 → `git add <resolved files>` → `git rebase --continue` → `git push origin HEAD`
  3. **如果冲突无法自动解决** → 停止，提示用户手动处理冲突，执行 `/android-dev-tools:push` 重新推送

**创建 Tag（仅当提供了版本号时）**：

首先检查 tag 是否已存在：
```bash
git tag -l "vX.Y.Z"
```

- **tag 不存在** → 创建并推送：
  ```bash
  git tag "vX.Y.Z"
  git push origin "vX.Y.Z"
  ```
- **tag 已存在** → 提示用户，询问是否删除重建或跳过

Tag 命名格式：`v` + 版本号，例如 `v1.2.2`

---

## Expected Outcome

执行完成后，远程仓库应包含：
- N 个新 commit（每个文件一个 commit + 可选的版本号 commit + 可选的文档 commit）
- 可选：1 个新 tag（`vX.Y.Z`）

## Anti-Patterns

- **不要在暂存区包含多个相互依赖的文件时使用**：逐文件提交可能导致中间 commit 引用不存在的代码。如果文件之间有依赖关系，考虑在运行前先手动提交它们。
- **不要连续执行两次**：第二次执行时暂存区已为空，会直接退出。
- **不要在非 Android 项目中使用**：update-docs 步骤会校验项目类型，非 Android 项目会失败。

## Notes

1. 所有 commit message 使用中文
2. 逐文件提交时，按文件路径的字母顺序依次提交
3. 版本号仅更新文档中的记录，不修改项目构建文件（build.gradle 等）
4. 如果某个文件的变更只有代码格式化，commit message 中标注为 `style`
5. push 失败时自动重试一次，冲突无法解决时交给用户
6. 本 skill 不会修改 `build.gradle`、`build.gradle.kts` 等构建配置文件中的版本号
7. Tag 格式统一为 `v` + semver，例如 `v1.2.2`
8. Step 2 在 Step 3 之前执行，Step 2 提交的文件不会在 Step 3 中重复提交
