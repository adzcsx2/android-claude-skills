# push

一键发布工作流：自动暂存所有变更、拉取最新代码、逐文件提交、生成更新文档、推送到远程仓库，支持可选 Tag 创建。

---

## 功能

- 自动 `git add` 所有工作区变更，无需手动暂存
- 每次提交前自动 `git pull` 拉取最新代码
- 简单冲突自动解决（一方删除、空白差异等），复杂冲突暂停提示用户
- 为每个文件生成独立的中文 commit message
- 支持指定版本号参数，自动更新文档版本号并创建 Git Tag
- 集成 update-docs skill 自动生成项目更新文档
- Push 失败自动重试，冲突无法解决时交给用户

## 用法

```bash
# 自动暂存所有变更，逐文件提交，推送到远程
/android-dev-tools:push

# 更新文档版本号到 1.2.2，提交并打 tag
/android-dev-tools:push 1.2.2
```

所有 git 命令均在用户当前工作目录执行。

> 本文档由 SKILL.md 自动生成，请勿手动编辑。如需更新，修改 SKILL.md 后运行 `/android-dev-tools:update-remote-plugins`。
