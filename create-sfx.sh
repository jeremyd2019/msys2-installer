#!/bin/bash
# usage: ./create-sfx.sh /some/path/to/msys64 installer.exe

set -e

# Download and extract https://github.com/mcmilk/7-Zip-zstd
NAME="7z21.03-zstd-x64"
CHECKSUM="531b20dfb03d8f30f61ae56a181610bbb6f3cf7cc71dac1d8f95511289de76f3"
DIR="$( cd "$( dirname "$0" )" && pwd )"
mkdir -p "$DIR/_cache"
BASE="$DIR/_cache/$NAME"
if [ ! -f "$BASE.exe" ]; then
    curl --fail -L "https://github.com/mcmilk/7-Zip-zstd/releases/download/v21.03-v1.5.0-R2/$NAME.exe" -o "$BASE.exe"
fi
echo "$CHECKSUM $BASE.exe" | sha256sum --quiet --check
if [ ! -d "$BASE" ]; then
    7z e -o"$BASE" "$DIR/_cache/$NAME.exe"
fi

NAME="7z21.03-zstd-x32"
CHECKSUM="79382f65a6903726157b385ae5e2baae7c9ca39eb157f1d08040ee112e99d8f1"
DIR="$( cd "$( dirname "$0" )" && pwd )"
mkdir -p "$DIR/_cache"
BASE32="$DIR/_cache/$NAME"
if [ ! -f "$BASE32.exe" ]; then
    curl --fail -L "https://github.com/mcmilk/7-Zip-zstd/releases/download/v21.03-v1.5.0-R2/$NAME.exe" -o "$BASE32.exe"
fi
echo "$CHECKSUM $BASE32.exe" | sha256sum --quiet --check
if [ ! -d "$BASE32" ]; then
    7z e -o"$BASE32" "$DIR/_cache/$NAME.exe"
fi

# Creat SFX installer
INPUT="$1"
OUTPUT="$2"
TEMP="$OUTPUT.payload"

rm -f "$TEMP"
"$BASE/7z" a "$TEMP" -ms1T -m0=zstd -mx22 "$INPUT"
cat "$BASE32/7zCon.sfx" "$TEMP" > "$OUTPUT"
rm "$TEMP"