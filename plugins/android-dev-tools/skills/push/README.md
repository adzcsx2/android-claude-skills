# push

一键发布工作流：更新文档版本号、逐文件提交、生成更新文档、推送到远程仓库，支持可选 Tag 创建。

---

## 功能

- 自动检测暂存区变更，为每个文件生成独立的中文 commit message
- 支持指定版本号参数，自动更新文档中的版本号并创建 Git Tag
- 执行前进行完整的环境预检（git 仓库、remote origin、工作区状态、暂存区内容）
- 版本号检测策略：锚定模式匹配，避免误匹配构建配置中的版本号
- 集成 update-docs skill 自动生成项目更新文档
- Push 失败自动重试，冲突无法解决时交给用户处理

## 用法

```bash
# 推送暂存区代码到远程
/android-dev-tools:push

# 更新文档版本号到 1.2.2，提交并打 tag
/android-dev-tools:push 1.2.2
```

> 本文档由 SKILL.md 自动生成，请勿手动编辑。如需更新，修改 SKILL.md 后运行 `/android-dev-tools:update-remote-plugins`。
