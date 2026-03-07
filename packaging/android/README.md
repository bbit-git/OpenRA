# Android packaging

Produces a signed fat APK (all ABIs) or an AAB for Play Store distribution.

## Prerequisites

| Tool | Minimum version | Notes |
|---|---|---|
| .NET SDK | 8.0 | `dotnet` in PATH |
| Android SDK | API 34 | `ANDROID_SDK` env var |
| Android NDK | r26+ | `ANDROID_NDK` env var |
| JDK | 17 | `JAVA_HOME` env var |
| cmake | 3.22+ | for native library cross-compile |
| ninja-build | any | for native library cross-compile |
| wget or curl | any | for downloading source tarballs |

The script downloads and cross-compiles SDL2, FreeType, OpenAL Soft, and Lua
from source on the first run. Tarballs are cached in `.build-cache/` at the
repo root and are not re-downloaded on subsequent runs.

## Quick start

```sh
# Fat APK (sideloading / F-Droid)
packaging/android/buildpackage.sh

# AAB (Play Store)
ANDROID_PACKAGE_FORMAT=aab packaging/android/buildpackage.sh

# Custom output directory
packaging/android/buildpackage.sh /path/to/dist
```

Output is written to `dist/` (or the directory you pass) with a SHA-256
checksum printed on completion.

## Release signing

### Option A — properties file (local builds)

Create `OpenRA.Platforms.Android/signing.properties` (git-ignored):

```properties
KEYSTORE_FILE=/path/to/release.keystore
KEYSTORE_PASSWORD=changeme
KEY_ALIAS=net.openra.android
KEY_PASSWORD=changeme
```

The script loads this file automatically if present.

### Option B — environment variables (CI)

```sh
export KEYSTORE_FILE=/path/to/release.keystore
export KEYSTORE_PASSWORD=...
export KEY_ALIAS=net.openra.android
export KEY_PASSWORD=...
packaging/android/buildpackage.sh
```

### Creating a keystore

```sh
keytool -genkeypair -v \
  -keystore release.keystore \
  -alias net.openra.android \
  -keyalg RSA -keysize 4096 \
  -validity 10000
```

Store the keystore and its passwords securely. Without the keystore, Play Store
updates cannot be published.

## Version numbers

`AndroidVersionName` is derived from the `VERSION` file (base version before
the first `-`).

`AndroidVersionCode` defaults to `yyMMddHH` (UTC build time). In CI, set
`BUILD_NUMBER` to a monotonically increasing integer:

```sh
BUILD_NUMBER=1042 packaging/android/buildpackage.sh
```

## Environment variable reference

| Variable | Default | Description |
|---|---|---|
| `ANDROID_SDK` | `~/Android/Sdk` | Android SDK root |
| `ANDROID_NDK` | `~/Android/Ndk` | Android NDK root |
| `JAVA_HOME` | `/usr/lib/jvm/java-17-openjdk-amd64` | JDK root |
| `ANDROID_PACKAGE_FORMAT` | `apk` | `apk` or `aab` |
| `CONFIGURATION` | `Release` | MSBuild configuration |
| `BUILD_NUMBER` | *(date-derived)* | Integer versionCode |
| `KEYSTORE_FILE` | *(unset — debug signing)* | Release keystore path |
| `KEYSTORE_PASSWORD` | — | Keystore password |
| `KEY_ALIAS` | — | Key alias |
| `KEY_PASSWORD` | — | Key password |

