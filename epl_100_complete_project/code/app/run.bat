@echo off
set ROOT_DIR=%~dp0
set DIST_DIR=%ROOT_DIR%dist
set LIB_DIR=%ROOT_DIR%lib

if not exist "%DIST_DIR%\EPL_DBMS_App.jar" (
  echo JAR not found. Run build.bat first.
  exit /b 1
)

cd /d "%DIST_DIR%"
java -cp "EPL_DBMS_App.jar;%LIB_DIR%\*" com.epl.Main
