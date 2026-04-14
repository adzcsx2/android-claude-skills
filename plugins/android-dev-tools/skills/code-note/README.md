# adt:code-note

为 Android 项目的 Kotlin/Java 源文件添加中文注释，支持类、方法、成员变量和关键逻辑块，注释简洁但全面。

---

## 功能

- 为类、成员变量、方法和关键逻辑块添加中文注释
- 自动定位目标文件，支持 .kt 和 .java 扩展名
- 使用 KDoc 格式编写方法文档，单行注释标注关键逻辑
- 只添加注释，不修改代码逻辑
- 按优先级标注：公共方法/复杂逻辑 > 类成员/私有方法 > 自解释代码

## 用法

```bash
/code-note AlbumActivity
/code-note LoginActivity.kt
```

参数为要添加注释的文件名，支持带或不带扩展名。如匹配到多个文件，会列出供选择。

> 本文档由 SKILL.md 自动生成，请勿手动编辑。如需更新，修改 SKILL.md 后运行 `/adt:update-remote-plugins`。
