# 模块功能清单模板

> 这是 init skill 使用的模板文件，用于生成 docs/checklist/modules.md

---

# 模块功能清单

> 本文档列出项目所有模块的功能，供 AI 开发时参考。在实现新功能前，请先检查是否已有现成的实现。

---

## 使用说明

1. 在编写新代码前，先查阅本文档检查是否有现成实现
2. 如果功能已存在，直接使用现有模块
3. 如果功能不存在，实现后请更新本文档

---

## common-core

核心抽象层，提供基础接口和工具。

### 状态管理

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| UI 状态封装 | `UIState<T>` | 统一 UI 状态封装，包含 Loading/Success/Error |
| 状态流 | `StateFlow<UIState<T>>` | 响应式状态流 |

### 协程工具

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| IO 调度 | `withIO { }` | 切换到 IO 线程执行 |
| 主线程调度 | `withMain { }` | 切换到主线程执行 |

### 日志

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| 调试日志 | `Logger.d(tag, message)` | Debug 级别日志 |
| 错误日志 | `Logger.e(tag, message, throwable)` | Error 级别日志 |

---

## common-network

网络请求模块。

### Retrofit 工厂

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| 创建服务 | `RetrofitFactory.createService(baseUrl)` | 创建 Retrofit API 服务 |
| 带拦截器 | `RetrofitFactory.createService(baseUrl, interceptors)` | 自定义拦截器 |

### 拦截器

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| 日志拦截 | `LoggingInterceptor` | 打印请求/响应日志 |
| 头部拦截 | `HeaderInterceptor` | 添加通用请求头 |
| Token 拦截 | `TokenInterceptor` | 自动添加 Token |

---

## common-utils

工具类模块。

### 存储工具

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| 键值存储 | `MMKVUtils.put(key, value)` | MMKV 存储 |
| 读取存储 | `MMKVUtils.get<T>(key, default)` | 读取 MMKV |

### UI 工具

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| Toast | `ToastUtils.show(message)` | 显示 Toast |
| 状态栏 | `StatusBarHelper.setStatusBarColor()` | 设置状态栏颜色 |
| 权限 | `LivePermissions.request()` | 运行时权限请求 |

### 扩展函数

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| View 可见性 | `View.visible()`, `View.gone()` | 快速设置可见性 |
| 字符串判空 | `String?.isNotNullOrEmpty()` | 安全判空 |

---

## common-image

图片加载模块。

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| 加载图片 | `ImageView.loadImage(url)` | 加载网络图片 |
| 加载圆形 | `ImageView.loadCircle(url)` | 加载圆形图片 |
| 加载圆角 | `ImageView.loadRound(url, radius)` | 加载圆角图片 |

---

## common-ui

UI 组件模块。

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| Base Activity | `BaseActivity` | Activity 基类 |
| Base Fragment | `BaseFragment` | Fragment 基类 |
| Base ViewModel | `BaseViewModel` | ViewModel 基类 |
| 列表适配器 | `BaseListAdapter` | 通用列表适配器 |

---

## 添加新模块

当添加新模块时，请按以下格式更新本文档：

```markdown
## {模块名称}

{模块描述}

### {子功能}

| 功能 | 类/方法 | 说明 |
|------|---------|------|
| ... | ... | ... |
```

---

## 更新记录

| 日期 | 变更 | 更新人 |
|------|------|--------|
| YYYY-MM-DD | 初始化模块清单 | AI |
