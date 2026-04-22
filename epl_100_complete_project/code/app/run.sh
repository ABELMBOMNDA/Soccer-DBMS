#!/usr/bin/env bash
set -e
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
DIST_DIR="$ROOT_DIR/dist"
LIB_DIR="$ROOT_DIR/lib"

if [ ! -f "$DIST_DIR/EPL_DBMS_App.jar" ]; then
  echo "JAR not found. Run build.sh first."
  exit 1
fi

cd "$DIST_DIR"
java -cp "EPL_DBMS_App.jar:$LIB_DIR/*" com.epl.Main
