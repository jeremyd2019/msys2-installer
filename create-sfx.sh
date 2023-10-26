#!/bin/bash
# usage: ./create-sfx.sh /some/path/to/msys64 installer.exe

set -e

# Download and extract https://github.com/mcmilk/7-Zip-zstd
NAME="7z22.01-zstd-x64"
CHECKSUM="d542d78397bbed8e77c221f36cad461a0d83f1263b993a7048e81df40f403fb8"
DIR="$( cd "$( dirname "$0" )" && pwd )"
mkdir -p "$DIR/_cache"
BASE="$DIR/_cache/$NAME"
if [ ! -f "$BASE.exe" ]; then
    curl --fail -L "https://github.com/mcmilk/7-Zip-zstd/releases/download/v22.01-v1.5.5-R3/$NAME.exe" -o "$BASE.exe"
fi
echo "$CHECKSUM $BASE.exe" | sha256sum --quiet --check
if [ ! -d "$BASE" ]; then
    7z e -o"$BASE" "$DIR/_cache/$NAME.exe"
fi

NAME="7z22.01-zstd-x32"
CHECKSUM="cc1b8c360656df516684c61da2b23e2185e27c23d255fd3db6a792373dcc1ba3"
DIR="$( cd "$( dirname "$0" )" && pwd )"
mkdir -p "$DIR/_cache"
BASE32="$DIR/_cache/$NAME"
if [ ! -f "$BASE32.exe" ]; then
    curl --fail -L "https://github.com/mcmilk/7-Zip-zstd/releases/download/v22.01-v1.5.5-R3/$NAME.exe" -o "$BASE32.exe"
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
