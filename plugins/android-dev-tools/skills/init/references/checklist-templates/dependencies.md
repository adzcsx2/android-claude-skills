# 依赖库清单模板

> 这是 init skill 使用的模板文件，用于生成 docs/checklist/dependencies.md

---

# 依赖库清单

> 本文档列出项目使用的第三方库，供 AI 开发时参考。

---

## 核心依赖

| 库 | 版本 | 用途 |
|------|------|------|
| Kotlin | {KOTLIN_VERSION} | 编程语言 |
| AndroidX Core | {VERSION} | Android 核心库 |
| AppCompat | {VERSION} | 兼容库 |
| Activity KTX | {VERSION} | Activity 扩展 |
| Fragment KTX | {VERSION} | Fragment 扩展 |

---

## 网络

| 库 | 版本 | 用途 |
|------|------|------|
| Retrofit | {VERSION} | REST API 客户端 |
| OkHttp | {VERSION} | HTTP 客户端 |
| Gson / Moshi | {VERSION} | JSON 序列化 |

---

## 异步

| 库 | 版本 | 用途 |
|------|------|------|
| Coroutines | {VERSION} | 协程 |
| Lifecycle Runtime | {VERSION} | 生命周期感知 |

---

## 数据库

| 库 | 版本 | 用途 |
|------|------|------|
| Room | {VERSION} | ORM 数据库 |
| MMKV | {VERSION} | 键值存储 |

---

## 图片加载

| 库 | 版本 | 用途 |
|------|------|------|
| Coil | {VERSION} | 图片加载（推荐） |
| Glide | {VERSION} | 图片加载（备选） |

---

## 依赖注入

| 库 | 版本 | 用途 |
|------|------|------|
| Koin | {VERSION} | 轻量级 DI 框架 |
| Hilt | {VERSION} | Google DI 框架 |

---

## UI 组件

| 库 | 版本 | 用途 |
|------|------|------|
| Material | {VERSION} | Material Design 组件 |
| ConstraintLayout | {VERSION} | 约束布局 |
| RecyclerView | {VERSION} | 列表视图 |
| SwipeRefreshLayout | {VERSION} | 下拉刷新 |
| ViewBinding | - | 视图绑定 |

---

## Jetpack Compose（如使用）

| 库 | 版本 | 用途 |
|------|------|------|
| Compose UI | {VERSION} | Compose UI |
| Compose Material | {VERSION} | Material 组件 |
| Compose Foundation | {VERSION} | 基础组件 |
| Activity Compose | {VERSION} | Activity 集成 |

---

## 测试

| 库 | 版本 | 用途 |
|------|------|------|
| JUnit | {VERSION} | 单元测试 |
| MockK | {VERSION} | Kotlin Mock 框架 |
| Coroutines Test | {VERSION} | 协程测试 |
| Espresso | {VERSION} | UI 测试 |

---

## 调试工具

| 库 | 版本 | 用途 |
|------|------|------|
| Timber | {VERSION} | 日志库 |
| LeakCanary | {VERSION} | 内存泄漏检测 |
| Chuck | {VERSION} | 网络请求调试 |

---

## 项目特定依赖

<!-- 根据项目实际情况添加 -->

| 库 | 版本 | 用途 |
|------|------|------|
| common-lib | {VERSION} | 公共库 |

---

## 版本升级注意事项

1. **Kotlin 版本** - 需与 AGP 版本兼容
2. **AGP 版本** - 需与 Gradle 版本兼容
3. **Retrofit** - 需与 OkHttp 版本兼容
4. **Room** - 需与 Kotlin 版本兼容

---

## 更新记录

| 日期 | 变更 | 更新人 |
|------|------|--------|
| YYYY-MM-DD | 初始化依赖清单 | AI |
