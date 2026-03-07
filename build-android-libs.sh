#!/bin/bash
# Cross-compile SDL2, FreeType, and OpenAL Soft for Android
# Requires: cmake, ninja-build, wget/curl
# Usage: ANDROID_NDK=/path/to/ndk ./build-android-libs.sh

set -euo pipefail

. ~/.android/.paths

SDL2_VERSION="2.32.10"
SDL2_TARBALL="SDL2-${SDL2_VERSION}.tar.gz"
SDL2_URL="https://github.com/libsdl-org/SDL/releases/download/release-${SDL2_VERSION}/${SDL2_TARBALL}"
SDL2_DIR="SDL2-${SDL2_VERSION}"

FREETYPE_VERSION="2.13.3"
FREETYPE_TARBALL="freetype-${FREETYPE_VERSION}.tar.xz"
FREETYPE_URL="https://download.savannah.gnu.org/releases/freetype/${FREETYPE_TARBALL}"
FREETYPE_DIR="freetype-${FREETYPE_VERSION}"

OPENAL_VERSION="1.24.3"
OPENAL_TARBALL="openal-soft-${OPENAL_VERSION}.tar.bz2"
OPENAL_URL="https://openal-soft.org/openal-releases/${OPENAL_TARBALL}"
OPENAL_DIR="openal-soft-${OPENAL_VERSION}"

LUA_VERSION="5.1.5"
LUA_TARBALL="lua-${LUA_VERSION}.tar.gz"
LUA_URL="https://www.lua.org/ftp/${LUA_TARBALL}"
LUA_DIR="lua-${LUA_VERSION}"

ANDROID_NDK="${ANDROID_NDK:-${ANDROID_NDK_HOME}}"
ANDROID_API=21
ABIS="armeabi-v7a arm64-v8a x86_64"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CACHE_DIR="${SCRIPT_DIR}/.build-cache"
OUTPUT_DIR="${SCRIPT_DIR}/OpenRA.Platforms.Android/libs"

if [ ! -d "${ANDROID_NDK}" ]; then
	echo "ERROR: Android NDK not found at ${ANDROID_NDK}"
	echo "Set ANDROID_NDK to the correct path."
	exit 1
fi

# Check for required tools
for tool in cmake ninja; do
	if ! command -v "$tool" &>/dev/null; then
		echo "ERROR: ${tool} is required but not found in PATH."
		exit 1
	fi
done

mkdir -p "${CACHE_DIR}"

# Download SDL2 source if not cached
if [ ! -f "${CACHE_DIR}/${SDL2_TARBALL}" ]; then
	echo "Downloading SDL2 ${SDL2_VERSION}..."
	if command -v wget &>/dev/null; then
		wget -q --show-progress -O "${CACHE_DIR}/${SDL2_TARBALL}" "${SDL2_URL}"
	else
		curl -L -o "${CACHE_DIR}/${SDL2_TARBALL}" "${SDL2_URL}"
	fi
fi

# Extract if not already done
if [ ! -d "${CACHE_DIR}/${SDL2_DIR}" ]; then
	echo "Extracting SDL2 ${SDL2_VERSION}..."
	tar -xzf "${CACHE_DIR}/${SDL2_TARBALL}" -C "${CACHE_DIR}"
fi

# Download FreeType source if not cached
if [ ! -f "${CACHE_DIR}/${FREETYPE_TARBALL}" ]; then
	echo "Downloading FreeType ${FREETYPE_VERSION}..."
	if command -v wget &>/dev/null; then
		wget -q --show-progress -O "${CACHE_DIR}/${FREETYPE_TARBALL}" "${FREETYPE_URL}"
	else
		curl -L -o "${CACHE_DIR}/${FREETYPE_TARBALL}" "${FREETYPE_URL}"
	fi
fi

if [ ! -d "${CACHE_DIR}/${FREETYPE_DIR}" ]; then
	echo "Extracting FreeType ${FREETYPE_VERSION}..."
	tar -xf "${CACHE_DIR}/${FREETYPE_TARBALL}" -C "${CACHE_DIR}"
fi

# Download OpenAL Soft source if not cached
if [ ! -f "${CACHE_DIR}/${OPENAL_TARBALL}" ]; then
	echo "Downloading OpenAL Soft ${OPENAL_VERSION}..."
	if command -v wget &>/dev/null; then
		wget -q --show-progress -O "${CACHE_DIR}/${OPENAL_TARBALL}" "${OPENAL_URL}"
	else
		curl -L -o "${CACHE_DIR}/${OPENAL_TARBALL}" "${OPENAL_URL}"
	fi
fi

if [ ! -d "${CACHE_DIR}/${OPENAL_DIR}" ]; then
	echo "Extracting OpenAL Soft ${OPENAL_VERSION}..."
	tar -xf "${CACHE_DIR}/${OPENAL_TARBALL}" -C "${CACHE_DIR}"
fi

# Download Lua source if not cached
if [ ! -f "${CACHE_DIR}/${LUA_TARBALL}" ]; then
	echo "Downloading Lua ${LUA_VERSION}..."
	if command -v wget &>/dev/null; then
		wget -q --show-progress -O "${CACHE_DIR}/${LUA_TARBALL}" "${LUA_URL}"
	else
		curl -L -o "${CACHE_DIR}/${LUA_TARBALL}" "${LUA_URL}"
	fi
fi

if [ ! -d "${CACHE_DIR}/${LUA_DIR}" ]; then
	echo "Extracting Lua ${LUA_VERSION}..."
	tar -xzf "${CACHE_DIR}/${LUA_TARBALL}" -C "${CACHE_DIR}"
fi

# Build for each ABI
for ABI in ${ABIS}; do
  BUILD_DIR="${CACHE_DIR}/build-${ABI}"
  echo "Building SDL2 for ${ABI}..."

  rm -rf "${BUILD_DIR}"
  cmake -S "${CACHE_DIR}/${SDL2_DIR}" -B "${BUILD_DIR}" \
    -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \
    -DANDROID_NDK="${ANDROID_NDK}" \
    -DANDROID_ABI="${ABI}" \
    -DANDROID_PLATFORM="android-${ANDROID_API}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DSDL_SHARED=ON -DSDL_STATIC=OFF -DSDL_TEST=OFF

  cmake --build "${BUILD_DIR}" -j "$(nproc)"

  mkdir -p "${OUTPUT_DIR}/${ABI}"

  # lib location can vary slightly; this finds it reliably:
  SDL_SO_PATH="$(find "${BUILD_DIR}" -maxdepth 3 -name "libSDL2.so" -print -quit)"
  if [ -z "${SDL_SO_PATH}" ]; then
    echo "ERROR: libSDL2.so not found under ${BUILD_DIR}"
    exit 1
  fi

  cp "${SDL_SO_PATH}" "${OUTPUT_DIR}/${ABI}/libSDL2.so"
  echo "  -> ${OUTPUT_DIR}/${ABI}/libSDL2.so"

  # Build FreeType
  FT_BUILD_DIR="${CACHE_DIR}/freetype-build-${ABI}"
  echo "Building FreeType for ${ABI}..."

  rm -rf "${FT_BUILD_DIR}"
  cmake -S "${CACHE_DIR}/${FREETYPE_DIR}" -B "${FT_BUILD_DIR}" \
    -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \
    -DANDROID_NDK="${ANDROID_NDK}" \
    -DANDROID_ABI="${ABI}" \
    -DANDROID_PLATFORM="android-${ANDROID_API}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DFT_DISABLE_ZLIB=ON \
    -DFT_DISABLE_BZIP2=ON \
    -DFT_DISABLE_PNG=ON \
    -DFT_DISABLE_HARFBUZZ=ON \
    -DFT_DISABLE_BROTLI=ON

  cmake --build "${FT_BUILD_DIR}" -j "$(nproc)"

  FT_SO_PATH="$(find "${FT_BUILD_DIR}" -maxdepth 3 -name "libfreetype.so" -print -quit)"
  if [ -z "${FT_SO_PATH}" ]; then
    echo "ERROR: libfreetype.so not found under ${FT_BUILD_DIR}"
    exit 1
  fi

  # OpenRA P/Invokes "freetype6" which .NET maps to "libfreetype6.so"
  cp "${FT_SO_PATH}" "${OUTPUT_DIR}/${ABI}/libfreetype6.so"
  echo "  -> ${OUTPUT_DIR}/${ABI}/libfreetype6.so"

  # Build OpenAL Soft
  OAL_BUILD_DIR="${CACHE_DIR}/openal-build-${ABI}"
  echo "Building OpenAL Soft for ${ABI}..."

  rm -rf "${OAL_BUILD_DIR}"
  cmake -S "${CACHE_DIR}/${OPENAL_DIR}" -B "${OAL_BUILD_DIR}" \
    -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \
    -DANDROID_NDK="${ANDROID_NDK}" \
    -DANDROID_ABI="${ABI}" \
    -DANDROID_PLATFORM="android-${ANDROID_API}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DALSOFT_UTILS=OFF \
    -DALSOFT_EXAMPLES=OFF \
    -DALSOFT_TESTS=OFF \
    -DALSOFT_BACKEND_OPENSL=ON \
    -DALSOFT_BACKEND_WAVE=OFF \
    -DALSOFT_REQUIRE_OPENSL=ON

  cmake --build "${OAL_BUILD_DIR}" -j "$(nproc)"

  OAL_SO_PATH="$(find "${OAL_BUILD_DIR}" -maxdepth 3 -name "libopenal.so" -print -quit)"
  if [ -z "${OAL_SO_PATH}" ]; then
    echo "ERROR: libopenal.so not found under ${OAL_BUILD_DIR}"
    exit 1
  fi

  # OpenRA P/Invokes "soft_oal" which .NET maps to "libsoft_oal.so"
  cp "${OAL_SO_PATH}" "${OUTPUT_DIR}/${ABI}/libsoft_oal.so"
  echo "  -> ${OUTPUT_DIR}/${ABI}/libsoft_oal.so"

  # Build Lua 5.1 (no cmake — compile C sources directly with NDK)
  echo "Building Lua ${LUA_VERSION} for ${ABI}..."

  case "${ABI}" in
    armeabi-v7a) LUA_TARGET=armv7a-linux-androideabi ;;
    arm64-v8a) LUA_TARGET=aarch64-linux-android ;;
    x86_64)    LUA_TARGET=x86_64-linux-android ;;
  esac

  LUA_CC="${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/${LUA_TARGET}${ANDROID_API}-clang"
  LUA_SRC="${CACHE_DIR}/${LUA_DIR}/src"

  LUA_CORE_SRCS="lapi.c lcode.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c \
    lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c \
    lundump.c lvm.c lzio.c"
  LUA_LIB_SRCS="lauxlib.c lbaselib.c ldblib.c liolib.c lmathlib.c loslib.c \
    ltablib.c lstrlib.c loadlib.c linit.c"

  LUA_OBJ_DIR="${CACHE_DIR}/lua-obj-${ABI}"
  rm -rf "${LUA_OBJ_DIR}"
  mkdir -p "${LUA_OBJ_DIR}"

  for f in ${LUA_CORE_SRCS} ${LUA_LIB_SRCS}; do
    "${LUA_CC}" -O2 -fPIC -DLUA_USE_POSIX -DLUA_USE_DLOPEN -c "${LUA_SRC}/${f}" -o "${LUA_OBJ_DIR}/${f%.c}.o"
  done

  "${LUA_CC}" -shared -o "${LUA_OBJ_DIR}/liblua51.so" "${LUA_OBJ_DIR}"/*.o -lm -ldl

  cp "${LUA_OBJ_DIR}/liblua51.so" "${OUTPUT_DIR}/${ABI}/liblua51.so"
  echo "  -> ${OUTPUT_DIR}/${ABI}/liblua51.so"
done

echo "Done. SDL2 ${SDL2_VERSION} + FreeType ${FREETYPE_VERSION} + OpenAL Soft ${OPENAL_VERSION} + Lua ${LUA_VERSION} libraries built for: ${ABIS}"
