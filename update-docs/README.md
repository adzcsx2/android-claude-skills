# update-docs Skill

Android 项目文档自动生成工具。分析项目结构，生成中文技术文档，支持增量更新。

## 触发命令

- `/update-docs` - 增量更新所有文档
- `/update-docs --force` - 强制重新生成所有文档
- `/update-docs --dry-run` - 仅分析不生成文件，预览将要更新的内容
- `/update-docs interfaces` - 仅生成界面文档
- `/update-docs navigation` - 仅生成导航文档
- `/update-docs components` - 仅生成四大组件文档
- `/update-docs notifications` - 仅生成通知文档
- `/update-docs api` - 仅生成 API 文档

## 输出位置

所有文档生成在项目根目录的 `docs/` 文件夹下。

## 生成的文档列表

| 文档 | 描述 |
|------|------|
| PROJECT_OVERVIEW.md | 项目概览（基本信息、架构、技术栈） |
| INTERFACES.md | 界面文档（控件分析、功能说明） |
| NAVIGATION.md | 导航文档（Activity-Fragment 关系、跳转关系） |
| COMPONENTS.md | 四大组件文档 |
| NOTIFICATIONS.md | 通知文档（渠道配置、通知类型） |
| BUILD_VARIANTS.md | 构建变体文档 |
| DEPENDENCIES.md | 依赖库文档 |
| API.md | API 接口文档（URL 和方法） |
| CHANGELOG.md | 文档更新日志 |
| README.md | 根目录文档索引 |

## 使用示例

```bash
# 首次生成所有文档
/update-docs

# 强制重新生成所有文档
/update-docs --force

# 仅更新界面文档
/update-docs interfaces

# 预览将要更新的文档
/update-docs --dry-run
```

---

详细配置请参考 [SKILL.md](./templates/SKILL.md)
