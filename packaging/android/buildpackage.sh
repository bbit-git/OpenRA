#!/bin/bash
# OpenRA packaging script for Android (fat APK or AAB)
# Usage: buildpackage.sh [outputdir]
#
# Environment variables:
#   ANDROID_SDK            - path to Android SDK  (default: ~/Android/Sdk)
#   ANDROID_NDK            - path to Android NDK  (default: ~/Android/Ndk)
#   JAVA_HOME              - path to JDK          (default: /usr/lib/jvm/java-17-openjdk-amd64)
#   ANDROID_PACKAGE_FORMAT - apk (default) or aab
#   BUILD_NUMBER           - integer versionCode for CI; derived from date if unset
#   KEYSTORE_FILE          - path to release keystore (release signing)
#   KEYSTORE_PASSWORD      - keystore password
#   KEY_ALIAS              - key alias inside keystore
#   KEY_PASSWORD           - key password
#
# Alternatively, place signing credentials in OpenRA.Platforms.Android/signing.properties
# (see packaging/android/README.md).

set -o errexit -o pipefail || exit $?

HERE="$(cd "$(dirname "$0")" && pwd)"
SRCDIR="$(cd "${HERE}/../.." && pwd)"
ANDROID_CSPROJ="${SRCDIR}/OpenRA.Platforms.Android/OpenRA.Platforms.Android.csproj"

OUTPUTDIR="${1:-${SRCDIR}/dist}"
ANDROID_SDK="${ANDROID_SDK:-${HOME}/Android/Sdk}"
ANDROID_NDK="${ANDROID_NDK:-${HOME}/Android/Ndk}"
JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-17-openjdk-amd64}"
ANDROID_PACKAGE_FORMAT="${ANDROID_PACKAGE_FORMAT:-apk}"
CONFIGURATION="${CONFIGURATION:-Release}"

###############################################################################
# Prerequisites
###############################################################################

require_cmd() {
	command -v "$1" >/dev/null 2>&1 || { echo >&2 "ERROR: '$1' not found. $2"; exit 1; }
}

require_cmd dotnet "Install .NET 8 SDK."
require_cmd cmake  "Install cmake (apt install cmake)."
require_cmd ninja  "Install ninja-build (apt install ninja-build)."

[ -d "${ANDROID_SDK}" ] || { echo >&2 "ERROR: ANDROID_SDK='${ANDROID_SDK}' does not exist."; exit 1; }
[ -d "${ANDROID_NDK}" ] || { echo >&2 "ERROR: ANDROID_NDK='${ANDROID_NDK}' does not exist."; exit 1; }
[ -f "${JAVA_HOME}/bin/javac" ] || { echo >&2 "ERROR: JAVA_HOME='${JAVA_HOME}' does not contain bin/javac."; exit 1; }

###############################################################################
# Native library versions and URLs
###############################################################################

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

ANDROID_API=21
ABIS="armeabi-v7a arm64-v8a x86_64"
CACHE_DIR="${SRCDIR}/.build-cache"
OUTPUT_DIR="${SRCDIR}/OpenRA.Platforms.Android/libs"

###############################################################################
# Check whether native libraries need (re)building
###############################################################################

NEED_NATIVE=false
for ABI in ${ABIS}; do
	for LIB in libSDL2.so libfreetype6.so libsoft_oal.so liblua51.so; do
		[ -f "${OUTPUT_DIR}/${ABI}/${LIB}" ] || NEED_NATIVE=true
	done
done

###############################################################################
# Build native libraries (SDL2, FreeType, OpenAL Soft, Lua)
###############################################################################

download_file() {
	local url="$1" dest="$2"
	if command -v wget &>/dev/null; then
		wget -q --show-progress -O "${dest}" "${url}"
	else
		curl -L -o "${dest}" "${url}"
	fi
}

if [ "${NEED_NATIVE}" = true ]; then
	echo "==> Building native libraries for Android..."
	mkdir -p "${CACHE_DIR}"

	# SDL2
	[ -f "${CACHE_DIR}/${SDL2_TARBALL}" ] || { echo "Downloading SDL2 ${SDL2_VERSION}..."; download_file "${SDL2_URL}" "${CACHE_DIR}/${SDL2_TARBALL}"; }
	[ -d "${CACHE_DIR}/${SDL2_DIR}" ]     || { echo "Extracting SDL2..."; tar -xzf "${CACHE_DIR}/${SDL2_TARBALL}" -C "${CACHE_DIR}"; }

	# FreeType
	[ -f "${CACHE_DIR}/${FREETYPE_TARBALL}" ] || { echo "Downloading FreeType ${FREETYPE_VERSION}..."; download_file "${FREETYPE_URL}" "${CACHE_DIR}/${FREETYPE_TARBALL}"; }
	[ -d "${CACHE_DIR}/${FREETYPE_DIR}" ]     || { echo "Extracting FreeType..."; tar -xf "${CACHE_DIR}/${FREETYPE_TARBALL}" -C "${CACHE_DIR}"; }

	# OpenAL Soft
	[ -f "${CACHE_DIR}/${OPENAL_TARBALL}" ] || { echo "Downloading OpenAL Soft ${OPENAL_VERSION}..."; download_file "${OPENAL_URL}" "${CACHE_DIR}/${OPENAL_TARBALL}"; }
	[ -d "${CACHE_DIR}/${OPENAL_DIR}" ]     || { echo "Extracting OpenAL Soft..."; tar -xf "${CACHE_DIR}/${OPENAL_TARBALL}" -C "${CACHE_DIR}"; }

	# Lua
	[ -f "${CACHE_DIR}/${LUA_TARBALL}" ] || { echo "Downloading Lua ${LUA_VERSION}..."; download_file "${LUA_URL}" "${CACHE_DIR}/${LUA_TARBALL}"; }
	[ -d "${CACHE_DIR}/${LUA_DIR}" ]     || { echo "Extracting Lua..."; tar -xzf "${CACHE_DIR}/${LUA_TARBALL}" -C "${CACHE_DIR}"; }

	for ABI in ${ABIS}; do
		mkdir -p "${OUTPUT_DIR}/${ABI}"

		# SDL2
		echo "Building SDL2 for ${ABI}..."
		BUILD_DIR="${CACHE_DIR}/build-${ABI}"
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
		SDL_SO="$(find "${BUILD_DIR}" -maxdepth 3 -name "libSDL2.so" -print -quit)"
		[ -n "${SDL_SO}" ] || { echo >&2 "ERROR: libSDL2.so not found"; exit 1; }
		cp "${SDL_SO}" "${OUTPUT_DIR}/${ABI}/libSDL2.so"
		echo "  -> ${OUTPUT_DIR}/${ABI}/libSDL2.so"

		# FreeType
		echo "Building FreeType for ${ABI}..."
		FT_BUILD="${CACHE_DIR}/freetype-build-${ABI}"
		rm -rf "${FT_BUILD}"
		cmake -S "${CACHE_DIR}/${FREETYPE_DIR}" -B "${FT_BUILD}" \
			-G Ninja \
			-DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \
			-DANDROID_NDK="${ANDROID_NDK}" \
			-DANDROID_ABI="${ABI}" \
			-DANDROID_PLATFORM="android-${ANDROID_API}" \
			-DCMAKE_BUILD_TYPE=Release \
			-DBUILD_SHARED_LIBS=ON \
			-DFT_DISABLE_ZLIB=ON -DFT_DISABLE_BZIP2=ON \
			-DFT_DISABLE_PNG=ON  -DFT_DISABLE_HARFBUZZ=ON \
			-DFT_DISABLE_BROTLI=ON
		cmake --build "${FT_BUILD}" -j "$(nproc)"
		FT_SO="$(find "${FT_BUILD}" -maxdepth 3 -name "libfreetype.so" -print -quit)"
		[ -n "${FT_SO}" ] || { echo >&2 "ERROR: libfreetype.so not found"; exit 1; }
		cp "${FT_SO}" "${OUTPUT_DIR}/${ABI}/libfreetype6.so"
		echo "  -> ${OUTPUT_DIR}/${ABI}/libfreetype6.so"

		# OpenAL Soft
		echo "Building OpenAL Soft for ${ABI}..."
		OAL_BUILD="${CACHE_DIR}/openal-build-${ABI}"
		rm -rf "${OAL_BUILD}"
		cmake -S "${CACHE_DIR}/${OPENAL_DIR}" -B "${OAL_BUILD}" \
			-G Ninja \
			-DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \
			-DANDROID_NDK="${ANDROID_NDK}" \
			-DANDROID_ABI="${ABI}" \
			-DANDROID_PLATFORM="android-${ANDROID_API}" \
			-DCMAKE_BUILD_TYPE=Release \
			-DBUILD_SHARED_LIBS=ON \
			-DALSOFT_UTILS=OFF -DALSOFT_EXAMPLES=OFF -DALSOFT_TESTS=OFF \
			-DALSOFT_BACKEND_OPENSL=ON -DALSOFT_BACKEND_WAVE=OFF \
			-DALSOFT_REQUIRE_OPENSL=ON
		cmake --build "${OAL_BUILD}" -j "$(nproc)"
		OAL_SO="$(find "${OAL_BUILD}" -maxdepth 3 -name "libopenal.so" -print -quit)"
		[ -n "${OAL_SO}" ] || { echo >&2 "ERROR: libopenal.so not found"; exit 1; }
		cp "${OAL_SO}" "${OUTPUT_DIR}/${ABI}/libsoft_oal.so"
		echo "  -> ${OUTPUT_DIR}/${ABI}/libsoft_oal.so"

		# Lua 5.1
		echo "Building Lua ${LUA_VERSION} for ${ABI}..."
		case "${ABI}" in
			armeabi-v7a) LUA_TARGET=armv7a-linux-androideabi ;;
			arm64-v8a)   LUA_TARGET=aarch64-linux-android ;;
			x86_64)      LUA_TARGET=x86_64-linux-android ;;
		esac
		LUA_CC="${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/${LUA_TARGET}${ANDROID_API}-clang"
		LUA_SRC="${CACHE_DIR}/${LUA_DIR}/src"
		LUA_OBJ="${CACHE_DIR}/lua-obj-${ABI}"
		rm -rf "${LUA_OBJ}"
		mkdir -p "${LUA_OBJ}"
		LUA_SRCS="lapi.c lcode.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c \
			lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c ltm.c \
			lundump.c lvm.c lzio.c \
			lauxlib.c lbaselib.c ldblib.c liolib.c lmathlib.c loslib.c \
			ltablib.c lstrlib.c loadlib.c linit.c"
		for f in ${LUA_SRCS}; do
			"${LUA_CC}" -O2 -fPIC -DLUA_USE_POSIX -DLUA_USE_DLOPEN \
				-c "${LUA_SRC}/${f}" -o "${LUA_OBJ}/${f%.c}.o"
		done
		"${LUA_CC}" -shared -o "${LUA_OBJ}/liblua51.so" "${LUA_OBJ}"/*.o -lm -ldl
		cp "${LUA_OBJ}/liblua51.so" "${OUTPUT_DIR}/${ABI}/liblua51.so"
		echo "  -> ${OUTPUT_DIR}/${ABI}/liblua51.so"

		# Strip debug symbols from all native libs
		LLVM_STRIP="${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip"
		for so in "${OUTPUT_DIR}/${ABI}"/*.so; do
			"${LLVM_STRIP}" --strip-unneeded "${so}"
		done
		echo "  Stripped all .so files for ${ABI}"
	done

	echo "==> Native libraries built."
fi

###############################################################################
# sdl2.jar
###############################################################################

echo "==> Recompiling sdl2.jar from Java sources..."
JAVA_BUILD_TMP="$(mktemp -d)"
trap 'rm -rf "${JAVA_BUILD_TMP}"' EXIT

ANDROID_JAR="$(ls -d "${ANDROID_SDK}/platforms/android-"*/android.jar 2>/dev/null | tail -1)"
[ -f "${ANDROID_JAR}" ] || { echo >&2 "ERROR: android.jar not found under ${ANDROID_SDK}/platforms/."; exit 1; }

"${JAVA_HOME}/bin/javac" -source 11 -target 11 \
	-classpath "${ANDROID_JAR}" \
	-d "${JAVA_BUILD_TMP}" \
	$(find "${SRCDIR}/OpenRA.Platforms.Android/java" -name "*.java") \
	2>&1 | grep -v '^\(warning\|Note\)' || true

"${JAVA_HOME}/bin/jar" cf "${SRCDIR}/OpenRA.Platforms.Android/sdl2.jar" -C "${JAVA_BUILD_TMP}" .

###############################################################################
# Signing
###############################################################################

SIGNING_PROPS="${SRCDIR}/OpenRA.Platforms.Android/signing.properties"
if [ -f "${SIGNING_PROPS}" ]; then
	echo "Loading signing credentials from signing.properties..."
	KEYSTORE_FILE="${KEYSTORE_FILE:-$(grep '^KEYSTORE_FILE=' "${SIGNING_PROPS}" | cut -d= -f2-)}"
	KEYSTORE_PASSWORD="${KEYSTORE_PASSWORD:-$(grep '^KEYSTORE_PASSWORD=' "${SIGNING_PROPS}" | cut -d= -f2-)}"
	KEY_ALIAS="${KEY_ALIAS:-$(grep '^KEY_ALIAS=' "${SIGNING_PROPS}" | cut -d= -f2-)}"
	KEY_PASSWORD="${KEY_PASSWORD:-$(grep '^KEY_PASSWORD=' "${SIGNING_PROPS}" | cut -d= -f2-)}"
fi

SIGN_ARGS=()
if [ -n "${KEYSTORE_FILE:-}" ]; then
	[ -f "${KEYSTORE_FILE}" ] || { echo >&2 "ERROR: KEYSTORE_FILE='${KEYSTORE_FILE}' not found."; exit 1; }
	SIGN_ARGS+=(
		"-p:AndroidKeyStore=true"
		"-p:AndroidSigningKeyStore=${KEYSTORE_FILE}"
		"-p:AndroidSigningStorePass=${KEYSTORE_PASSWORD}"
		"-p:AndroidSigningKeyAlias=${KEY_ALIAS}"
		"-p:AndroidSigningKeyPass=${KEY_PASSWORD}"
	)
	echo "Release signing enabled (keystore: ${KEYSTORE_FILE})."
else
	echo "No keystore configured — using debug signing."
fi

###############################################################################
# Version
###############################################################################

VERSION_NAME="$(head -1 "${SRCDIR}/VERSION" | tr -d '[:space:]' | cut -d'-' -f1)"
VERSION_ARGS=("-p:AndroidVersionName=${VERSION_NAME}")
if [ -n "${BUILD_NUMBER:-}" ]; then
	VERSION_ARGS+=("-p:AndroidVersionCode=${BUILD_NUMBER}")
fi

###############################################################################
# dotnet build
###############################################################################

echo "==> Building OpenRA Android ${ANDROID_PACKAGE_FORMAT} (${CONFIGURATION})..."
echo "    ABIs   : armeabi-v7a arm64-v8a x86_64"
echo "    Version: ${VERSION_NAME}"

dotnet build "${ANDROID_CSPROJ}" \
	-c "${CONFIGURATION}" \
	-p:AndroidBuild=true \
	-p:AndroidPackageFormat="${ANDROID_PACKAGE_FORMAT}" \
	-p:AndroidSdkDirectory="${ANDROID_SDK}" \
	-p:AndroidNdkDirectory="${ANDROID_NDK}" \
	-p:JavaSdkDirectory="${JAVA_HOME}" \
	-p:AcceptAndroidSDKLicenses=True \
	"${VERSION_ARGS[@]}" \
	"${SIGN_ARGS[@]}"

###############################################################################
# Collect artifact
###############################################################################

mkdir -p "${OUTPUTDIR}"

if [ "${ANDROID_PACKAGE_FORMAT}" = "aab" ]; then
	EXT="aab"
else
	EXT="apk"
fi

ARTIFACT="${SRCDIR}/OpenRA.Platforms.Android/obj/bin/net8.0-android34.0/com.bigbangit.openra.android-Signed.${EXT}"
if [ ! -f "${ARTIFACT}" ]; then
	echo >&2 "ERROR: artifact not found at ${ARTIFACT}"
	exit 1
fi

DEST="${OUTPUTDIR}/OpenRA-Android-${VERSION_NAME}.${EXT}"
cp "${ARTIFACT}" "${DEST}"

echo ""
echo "==> Artifact: ${DEST}"
sha256sum "${DEST}"
