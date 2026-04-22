@echo off
set ROOT_DIR=%~dp0
set SRC_DIR=%ROOT_DIR%src
set RES_DIR=%ROOT_DIR%resources
set BIN_DIR=%ROOT_DIR%bin
set DIST_DIR=%ROOT_DIR%dist
set MANIFEST_FILE=%ROOT_DIR%manifest.mf

if exist "%BIN_DIR%" rmdir /s /q "%BIN_DIR%"
if exist "%DIST_DIR%" rmdir /s /q "%DIST_DIR%"

mkdir "%BIN_DIR%"
mkdir "%DIST_DIR%"

dir /s /b "%SRC_DIR%\*.java" > "%ROOT_DIR%sources.txt"
javac -d "%BIN_DIR%" @"%ROOT_DIR%sources.txt"

xcopy "%RES_DIR%\*" "%BIN_DIR%\" /E /I /Y > nul

jar cfm "%DIST_DIR%\EPL_DBMS_App.jar" "%MANIFEST_FILE%" -C "%BIN_DIR%" .
copy "%ROOT_DIR%resources\db.properties.example" "%DIST_DIR%\db.properties" > nul

echo Build completed.
echo JAR created at: %DIST_DIR%\EPL_DBMS_App.jar
echo Edit dist\db.properties before running the app.
