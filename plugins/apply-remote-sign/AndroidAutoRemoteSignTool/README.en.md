# Android Auto Remote Sign Tool

Android APK remote automatic signing tool, supporting automated build and signing for staging and production environments.

## Features

- One-click configuration for Android projects with remote signing
- **Dual DSL support**: Automatically detects and supports both Groovy DSL (`build.gradle`) and Kotlin DSL (`build.gradle.kts`)
- **V1+V2 signing**: Local digest computation (32 bytes) + remote signature + local APK assembly
- **Multi-module support**: Configure remote signing for additional modules (e.g., `app_d`, `app_link`) via `--modules` parameter
- **Multi-source Token**: Read `SIGN_TOKEN` from project root `.env`, parent directory `.env`, or system environment variables (multi-project sharing & CI/CD friendly)
- Automatic detection and configuration of JDK 11
- Support for separate staging and production environments
- Seamless integration with Android Studio and Gradle
- Efficient: only transmits digest and signature data (a few KB), not entire APK files

## Quick Start

### 1. Integrate into Your Android Project

> **Important**: Copy the entire `remote_sign/` folder to the root directory of your Android project.
>
> **Do not** copy individual files separately, as this will cause script path errors and malfunctions.

```bash
# Copy the remote_sign folder from this project to your Android project root
cp -r remote_sign /path/to/your/android/project/
```

Directory structure after copying:
```
your-android-project/
├── remote_sign/           # Copy the entire folder
│   ├── apply_remote_sign.py
│   ├── build.py
│   ├── sign_apk.py
│   └── README.md
├── app/
├── gradle/
└── ...
```

### 2. Run the Auto-Configuration Script

Execute from your Android project root directory:

```bash
# Configure the default app module
python remote_sign/apply_remote_sign.py

# Or specify project path with additional modules
python remote_sign/apply_remote_sign.py -p "/path/to/project" --modules app_d,app_link
```

This script will automatically:
- Detect project DSL type (Groovy or Kotlin)
- Create `.env.example` environment variable template
- Update `.gitignore` (protect sensitive information)
- Update `gradle.properties` (AGP configuration)
- Update `app/build.gradle` or `app/build.gradle.kts` (integrate V1+V2 signing tasks)
- Create `scripts/` directory and copy necessary scripts

> **Note:** The signing script requires the `requests` Python library:
> ```bash
> pip install requests
> ```

### 3. Configure Signing Token

Token lookup priority: project root `.env` > parent directory `.env` > system environment variable

**Method 1: Create .env in project root (Recommended)**
```bash
# Windows
copy .env.example .env

# macOS/Linux
cp .env.example .env

# Edit .env file and fill in your signing service token
# SIGN_TOKEN=your_actual_token_here
```

**Method 2: Create .env in parent directory (share Token across projects)**
```bash
# Create .env in the parent of your project root
echo "SIGN_TOKEN=your_actual_token_here" > ../.env
```

**Method 3: Using system environment variable (for CI/CD or terminal builds)**
```bash
# Linux/macOS
export SIGN_TOKEN=your_actual_token_here
# Add to ~/.zshrc or ~/.bashrc for persistence

# Windows
set SIGN_TOKEN=your_actual_token_here
```

> **Note:** macOS apps launched from Dock cannot read environment variables set in `.zshrc`. Use `.env` file or run `./gradlew` from terminal.

### 4. Build and Sign

#### Method 1: Using Python Script (Recommended)
```bash
python scripts/build.py assembleStageEnvDebug
```

#### Method 2: Using Gradle
```bash
# Windows
gradlew.bat assembleStageEnvDebug

# macOS/Linux
./gradlew assembleStageEnvDebug
```

#### Method 3: In Android Studio
Simply click Build or Run in Android Studio, signing will be automatic.

## Build Variants

| Variant | Description |
|---------|-------------|
| `assembleStageEnvDebug` | Staging + Debug |
| `assembleStageEnvRelease` | Staging + Release |
| `assembleReleaseEnvDebug` | Production + Debug |
| `assembleReleaseEnvRelease` | Production + Release |

## Output Location

Signed APK files are located at:
```
app/build/outputs/apk/<environment>/<build_type>/
```

Example:
```
app/build/outputs/apk/stageEnv/debug/VertuTheme_stageEnvDebug_v1.1.18_c50_xxx.apk
```

## Signing Service Configuration

| Config | Value |
|--------|-------|
| Base API URL | `https://public-service.vertu.cn/android/apk` |
| V1 Sign Endpoint | `{base_url}/handleSignV1` |
| V2 Sign Endpoint | `{base_url}/handleSignV2` |
| Auth Method | Bearer Token |
| Signing Method | Local digest + Remote signature + Local assembly |

### Modifying Sign Service URL

- **Groovy DSL**: Edit `signApiUrl` in the flavor `ext` block of `app/build.gradle`
- **Kotlin DSL**: Edit the `signApiUrls` map at the bottom of `app/build.gradle.kts`

## Directory Structure

```
remote_sign/
├── apply_remote_sign.py    # Auto-configuration script (dispatcher, auto-detects DSL type)
├── apply_groovy_sign.py   # Groovy DSL (build.gradle) handler
├── apply_kts_sign.py      # Kotlin DSL (build.gradle.kts) handler
├── sign_apk.py            # APK V1+V2 remote signing script
├── sign_apk_old.py        # Old signing script (upload/download mode, kept for reference)
├── build.py               # Auto JDK configuration build script
└── config_tool.py         # GUI configuration tool
```

## Files Modified by Configuration Script

| File | Changes |
|------|---------|
| `.env.example` | Environment variable template (sign token config) |
| `.gitignore` | Add ignore rules for `.env` and other sensitive files |
| `gradle.properties` | Add AGP 7.0.x resource merge related config |
| `app/build.gradle` | Groovy DSL: Integrate remote V1+V2 signing tasks |
| `app/build.gradle.kts` | Kotlin DSL: Integrate remote V1+V2 signing tasks |
| `<module>/build.gradle(.kts)` | Additional modules specified via `--modules` (optional) |

## FAQ

### Q: Why can't I copy files separately?
A: Scripts use relative paths to reference other files. Copying individually will cause path errors. Please always keep the `remote_sign/` folder intact.

### Q: What JDK version is required?
A: JDK 11 is required. The `build.py` script will automatically detect and configure it - no manual setup needed.

### Q: What to do if signing fails?
A: Please check:
1. `SIGN_TOKEN` in `.env` file is correct
2. Network can access the signing service
3. Check error messages in build logs

## Changelog

### v2.1 (2026-02-27)
- Fixed `Unresolved reference: io` compile error caused by missing `java.io.File` / `java.io.IOException` imports in generated Kotlin DSL code
- Fixed `Cannot add a SigningConfig with name 'debug'` error by using `getByName("debug")` instead of `create("debug")` (AGP auto-creates the debug signing config)
- Added `_ensure_imports()` step to automatically inject required `import` statements at the top of target `.gradle.kts` files
- Replaced fully-qualified names with simple class names in template code for cleaner output

### v2.0 (2026-02-27)
- Added Kotlin DSL (`build.gradle.kts`) support with automatic DSL type detection
- Split into independent modules: `apply_groovy_sign.py` (Groovy) and `apply_kts_sign.py` (Kotlin)
- `apply_remote_sign.py` now acts as a dispatcher, auto-detecting `.gradle` / `.gradle.kts`
- Kotlin DSL supports `create("flavor")` syntax, `signingConfigs.getByName()`, etc.
- Compatible with AGP 8.x modern DSL (`lint {}`, `packaging {}`, `extra["key"]`)
- Existing Groovy DSL functionality completely unaffected

### v1.7 (2026-02-27)
- SIGN_TOKEN lookup priority: project root `.env` > parent directory `.env` > system environment variable
- Support parent directory `.env` for sharing Token across multiple projects
- Detailed logging at each lookup step for easy troubleshooting
- Updated post-configuration instructions with three Token configuration methods

### v1.6 (2026-02-27)
- Added system environment variable support for `SIGN_TOKEN`
- CI/CD friendly: no need to create `.env` file when using environment variables
- Improved Token source logging (shows source without printing the actual value)

### v1.5 (2026-02-26)
- Added `--modules` / `-m` parameter to configure remote signing for additional modules (e.g., `app_d`, `app_link`)
- Default behavior unchanged — only the `app` module is configured when `--modules` is not specified
- GUI config tool now supports extra modules input
- Failure in one module does not block configuration of other modules

## License

MIT License
