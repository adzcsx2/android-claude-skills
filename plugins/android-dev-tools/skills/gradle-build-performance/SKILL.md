---
name: gradle-build-performance
description: Debug and optimize Android/Gradle build performance. Use when builds are slow, investigating CI/CD performance, analyzing build scans, or identifying compilation bottlenecks.
---

# Gradle Build Performance

## When to Use

- Build times are slow (clean or incremental)
- Investigating build performance regressions
- Analyzing Gradle Build Scans
- Identifying configuration vs execution bottlenecks
- Optimizing CI/CD build times
- Enabling Gradle Configuration Cache
- Reducing unnecessary recompilation
- Debugging kapt/KSP annotation processing

## Example Prompts

- "My builds are slow, how can I speed them up?"
- "How do I analyze a Gradle build scan?"
- "Why is configuration taking so long?"
- "Why does my project always recompile everything?"
- "How do I enable configuration cache?"
- "Why is kapt so slow?"

---

## Diagnostic Workflow

### Step 1: Analyze Project Configuration

Read and analyze the following files:
- `gradle.properties` - Gradle configuration
- `build.gradle` / `build.gradle.kts` - Root build file
- `app/build.gradle` / `app/build.gradle.kts` - App module
- `settings.gradle` / `settings.gradle.kts` - Settings
- `gradle/wrapper/gradle-wrapper.properties` - Gradle version

### Step 2: Check Configuration Status

Create a diagnostic table comparing current vs optimal:

| # | Optimization | Current Status | Issue | Risk |
|---|--------------|----------------|-------|------|
| 1 | Configuration Cache | ❌/✅ | ... | Low |
| 2 | Build Cache | ❌/✅ | ... | None |
| 3 | Parallel Execution | ❌/✅ | ... | None |
| 4 | JVM Heap | ⚠️/✅ | ... | None |
| 5 | Non-Transitive R | ❌/✅ | ... | - |
| 6 | Kapt → KSP | ❌/✅ | ... | Medium |
| 7 | Dynamic Dependencies | ⚠️/✅ | ... | Low |
| 8 | Repository Order | ❌/✅ | ... | - |

### Step 3: Propose Risk-Level Plans

**Plan A: Zero Risk (Configuration Only)**
- Only modify `gradle.properties`
- No code changes, no version upgrades
- Expected improvement: 20-40%

**Plan B: Low Risk (Configuration + Dependency Fixes)**
- Plan A + fix dependency issues
- Unify library versions, remove dynamic versions
- Expected improvement: 25-45%

**Plan C: Medium Risk (Plan B + KSP Migration)**
- Plan B + migrate kapt to KSP
- Requires testing annotation processing
- Expected improvement: 40-60%

### Step 4: Wait for User Confirmation

**CRITICAL**: Present the plan and WAIT for user approval before making any changes.

---

## Quick Diagnostics

### Generate Build Scan

```bash
./gradlew assembleDebug --scan
```

### Profile Build Locally

```bash
./gradlew assembleDebug --profile
# Opens report in build/reports/profile/
```

### Build Timing Summary

```bash
./gradlew assembleDebug --info | grep -E "^\:.*"
# Or view in Android Studio: Build > Analyze APK Build
```

---

## Build Phases

| Phase | What Happens | Common Issues |
|-------|--------------|---------------|
| **Initialization** | `settings.gradle` evaluated | Too many `include()` statements |
| **Configuration** | All `build.gradle` files evaluated | Expensive plugins, eager task creation |
| **Execution** | Tasks run based on inputs/outputs | Cache misses, non-incremental tasks |

### Identify the Bottleneck

```
Build scan → Performance → Build timeline
```

- **Long configuration phase**: Focus on plugin and buildscript optimization
- **Long execution phase**: Focus on task caching and parallelization
- **Dependency resolution slow**: Focus on repository configuration

---

## Common Issues Detection

### 1. Dynamic Version Dependencies

**Detection**: Search for `latest.release`, `+`, or `x.x.+` in dependencies

```groovy
// BAD: Forces resolution every build
implementation 'com.example:lib:latest.release'
implementation 'com.example:lib:+'
implementation 'com.example:lib:1.0.+'

// GOOD: Fixed version
implementation 'com.example:lib:1.2.3'
```

### 2. Version Inconsistencies

**Detection**: Same library with different versions

```groovy
// BAD: Inconsistent versions
implementation 'com.squareup.okhttp3:okhttp:4.12.0'
implementation 'com.squareup.okhttp3:logging-interceptor:4.11.0'

// GOOD: Unified version
implementation 'com.squareup.okhttp3:okhttp:4.12.0'
implementation 'com.squareup.okhttp3:logging-interceptor:4.12.0'
```

### 3. Parallel Execution Disabled

**Detection**: `org.gradle.parallel` is commented or set to false

```properties
# BAD: Parallel disabled
# org.gradle.parallel=true

# GOOD: Parallel enabled
org.gradle.parallel=true
```

### 4. Insufficient JVM Memory

**Detection**: JVM heap < 3GB for medium/large projects

```properties
# BAD: Too small for modern projects
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8

# GOOD: Adequate memory with GC optimization
org.gradle.jvmargs=-Xmx4096m -XX:+UseParallelGC -Dfile.encoding=UTF-8
```

### 5. Build Cache Disabled

**Detection**: `org.gradle.caching` not set or set to false

```properties
# GOOD: Enable build cache
org.gradle.caching=true
```

### 6. Kapt Incremental Disabled

**Detection**: Using kapt without incremental settings

```properties
# GOOD: Enable incremental kapt
kapt.incremental.apt=true
kapt.use.worker.api=true
```

---

## 12 Optimization Patterns

### 1. Enable Configuration Cache

Caches configuration phase across builds (AGP 8.0+):

```properties
# gradle.properties
org.gradle.configuration-cache=true
org.gradle.configuration-cache.problems=warn
```

### 2. Enable Build Cache

Reuses task outputs across builds and machines:

```properties
# gradle.properties
org.gradle.caching=true
```

### 3. Enable Parallel Execution

Build independent modules simultaneously:

```properties
# gradle.properties
org.gradle.parallel=true
```

### 4. Increase JVM Heap

Allocate more memory for large projects:

```properties
# gradle.properties
org.gradle.jvmargs=-Xmx4g -XX:+UseParallelGC
```

### 5. Use Non-Transitive R Classes

Reduces R class size and compilation (AGP 8.0+ default):

```properties
# gradle.properties
android.nonTransitiveRClass=true
```

### 6. Migrate kapt to KSP

KSP is 2x faster than kapt for Kotlin:

```groovy
// Before (slow) - Groovy DSL
kapt 'com.google.dagger:hilt-compiler:2.51.1'

// After (fast) - Groovy DSL
ksp 'com.google.dagger:hilt-compiler:2.51.1'
```

```kotlin
// Before (slow) - Kotlin DSL
kapt("com.google.dagger:hilt-compiler:2.51.1")

// After (fast) - Kotlin DSL
ksp("com.google.dagger:hilt-compiler:2.51.1")
```

### 7. Avoid Dynamic Dependencies

Pin dependency versions:

```groovy
// BAD: Forces resolution every build
implementation "com.example:lib:+"
implementation "com.example:lib:1.0.+"

// GOOD: Fixed version
implementation "com.example:lib:1.2.3"
```

### 8. Optimize Repository Order

Put most-used repositories first:

```groovy
// settings.gradle (Groovy DSL)
dependencyResolutionManagement {
    repositories {
        google()      // First: Android dependencies
        mavenCentral() // Second: Most libraries
        // Third-party repos last
        maven { url 'https://jitpack.io' }
    }
}
```

### 9. Use includeBuild for Local Modules

Composite builds are faster than `project()` for large monorepos:

```groovy
// settings.gradle (Groovy DSL)
includeBuild("shared-library") {
    dependencySubstitution {
        substitute(module("com.example:shared")).using(project(":"))
    }
}
```

### 10. Enable Incremental Annotation Processing

```properties
# gradle.properties
kapt.incremental.apt=true
kapt.use.worker.api=true
```

### 11. Avoid Configuration-Time I/O

Don't read files or make network calls during configuration:

```groovy
// BAD: Runs during configuration
def version = file("version.txt").text

// GOOD: Defer to execution (Groovy DSL)
def version = providers.fileContents(layout.projectDirectory.file("version.txt")).asText
```

### 12. Use Lazy Task Configuration

Avoid `create()`, use `register()`:

```groovy
// BAD: Eagerly configured
tasks.create("myTask") { ... }

// GOOD: Lazily configured
tasks.register("myTask") { ... }
```

---

## Recommended gradle.properties Template

```properties
# ============================================
# JVM Memory Configuration
# ============================================
org.gradle.jvmargs=-Xmx4096m -XX:+UseParallelGC -Dfile.encoding=UTF-8

# ============================================
# Parallel Compilation
# ============================================
org.gradle.parallel=true

# ============================================
# Build Cache
# ============================================
org.gradle.caching=true

# ============================================
# Daemon Configuration
# ============================================
org.gradle.daemon=true

# ============================================
# Configure on Demand
# ============================================
org.gradle.configureondemand=true

# ============================================
# AndroidX
# ============================================
android.useAndroidX=true
android.enableJetifier=true

# ============================================
# Kotlin Compilation Optimization
# ============================================
kotlin.code.style=official
kotlin.incremental=true
kotlin.incremental.java=true

# ============================================
# Kapt Incremental Compilation
# ============================================
kapt.incremental.apt=true
kapt.use.worker.api=true

# ============================================
# Android Specific Optimization
# ============================================
android.nonTransitiveRClass=true
```

---

## Common Bottleneck Analysis

### Slow Configuration Phase

**Symptoms**: Build scan shows long "Configuring build" time

**Causes & Fixes**:
| Cause | Fix |
|-------|-----|
| Eager task creation | Use `tasks.register()` instead of `tasks.create()` |
| buildSrc with many dependencies | Migrate to Convention Plugins with `includeBuild` |
| File I/O in build scripts | Use `providers.fileContents()` |
| Network calls in plugins | Cache results or use offline mode |

### Slow Compilation

**Symptoms**: `:app:compileDebugKotlin` takes too long

**Causes & Fixes**:
| Cause | Fix |
|-------|-----|
| Non-incremental changes | Avoid `build.gradle` changes that invalidate cache |
| Large modules | Break into smaller feature modules |
| Excessive kapt usage | Migrate to KSP |
| Kotlin compiler memory | Increase `kotlin.daemon.jvmargs` |

### Cache Misses

**Symptoms**: Tasks always rerun despite no changes

**Causes & Fixes**:
| Cause | Fix |
|-------|-----|
| Unstable task inputs | Use `@PathSensitive`, `@NormalizeLineEndings` |
| Absolute paths in outputs | Use relative paths |
| Missing `@CacheableTask` | Add annotation to custom tasks |
| Different JDK versions | Standardize JDK across environments |

---

## CI/CD Optimizations

### Remote Build Cache

```groovy
// settings.gradle (Groovy DSL)
buildCache {
    local { enabled = true }
    remote(HttpBuildCache) {
        url = 'https://cache.example.com/'
        push = System.getenv("CI") == "true"
        credentials {
            username = System.getenv("CACHE_USER")
            password = System.getenv("CACHE_PASS")
        }
    }
}
```

### Gradle Enterprise / Develocity

For advanced build analytics:

```groovy
// settings.gradle (Groovy DSL)
plugins {
    id "com.gradle.develocity" version "3.17"
}

develocity {
    buildScan {
        termsOfUseUrl = "https://gradle.com/help/legal-terms-of-use"
        termsOfUseAgree = "yes"
        publishing.onlyIf { System.getenv("CI") != null }
    }
}
```

### Skip Unnecessary Tasks in CI

```bash
# Skip tests for UI-only changes
./gradlew assembleDebug -x test -x lint

# Only run affected module tests
./gradlew :feature:login:test
```

---

## Android Studio Settings

### File → Settings → Build → Gradle

- **Gradle JDK**: Match your project's JDK
- **Build and run using**: Gradle (not IntelliJ)
- **Run tests using**: Gradle

### File → Settings → Build → Compiler

- **Compile independent modules in parallel**: ✅ Enabled
- **Configure on demand**: ❌ Disabled (deprecated)

---

## Verification Checklist

After optimizations, verify:

- [ ] Configuration cache enabled and working
- [ ] Build cache hit rate > 80% (check build scan)
- [ ] No dynamic dependency versions
- [ ] KSP used instead of kapt where possible
- [ ] Parallel execution enabled
- [ ] JVM memory tuned appropriately
- [ ] CI remote cache configured
- [ ] No configuration-time I/O
- [ ] All library versions unified

---

## References

- [Optimize Build Speed](https://developer.android.com/build/optimize-your-build)
- [Gradle Configuration Cache](https://docs.gradle.org/current/userguide/configuration_cache.html)
- [Gradle Build Cache](https://docs.gradle.org/current/userguide/build_cache.html)
- [Migrate from kapt to KSP](https://developer.android.com/build/migrate-to-ksp)
- [Gradle Build Scans](https://scans.gradle.com/)
