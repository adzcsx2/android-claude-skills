# adt:update-remote-plugins

审计并生成每个 skill 的 README.md，同步 marketplace.json、plugin.json 和 README 文件，然后提交推送到远程仓库，并同步到本地 Claude Code 插件目录。

---

## 功能

- 拉取远程最新代码，避免冲突
- 扫描所有 skill 目录，检测 SKILL.md 变更
- 审计并生成每个 skill 目录的 README.md（从 SKILL.md 自动提取）
- 根据变更类型自动确定版本升级幅度（patch/minor/major）
- 更新 plugin.json 和 marketplace.json 版本号
- 同步中英文 README 文件的 Skills 表格
- 提交并推送到远程仓库（含重试逻辑）
- 同步到本地 cache 目录（通过 cp）和 marketplace 目录（通过 git pull，必须是 git 仓库）
- 首次安装时注册 3 个配置文件（settings.json、known_marketplaces.json、installed_plugins.json）
- 验证 installed_plugins.json 版本一致性

## 用法

```
/adt:update-remote-plugins
```

在修改了 `plugins/` 目录下的任何 skill 后运行，用于发布新版本或同步文档。

> 本文档由 SKILL.md 自动生成，请勿手动编辑。如需更新，修改 SKILL.md 后运行 `/adt:update-remote-plugins`。
