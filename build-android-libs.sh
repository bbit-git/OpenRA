#!/bin/bash
# Cross-compile SDL2 and FreeType for Android (arm64-v8a + x86_64)
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

ANDROID_NDK="${ANDROID_NDK}"
ANDROID_API=21
ABIS="arm64-v8a x86_64"

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
done

echo "Done. SDL2 ${SDL2_VERSION} + FreeType ${FREETYPE_VERSION} libraries built for: ${ABIS}"
