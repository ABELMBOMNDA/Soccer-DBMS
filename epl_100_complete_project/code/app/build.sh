#!/usr/bin/env bash
set -e
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$ROOT_DIR/src"
RES_DIR="$ROOT_DIR/resources"
BIN_DIR="$ROOT_DIR/bin"
DIST_DIR="$ROOT_DIR/dist"
MANIFEST_FILE="$ROOT_DIR/manifest.mf"

rm -rf "$BIN_DIR" "$DIST_DIR"
mkdir -p "$BIN_DIR" "$DIST_DIR"

find "$SRC_DIR" -name "*.java" | sort > "$ROOT_DIR/sources.txt"
javac -d "$BIN_DIR" @"$ROOT_DIR/sources.txt"

if [ -d "$RES_DIR" ]; then
  cp -R "$RES_DIR"/. "$BIN_DIR"/
fi

jar cfm "$DIST_DIR/EPL_DBMS_App.jar" "$MANIFEST_FILE" -C "$BIN_DIR" .
cp "$ROOT_DIR/resources/db.properties.example" "$DIST_DIR/db.properties"

echo "Build completed."
echo "JAR created at: $DIST_DIR/EPL_DBMS_App.jar"
echo "Edit dist/db.properties before running the app."
