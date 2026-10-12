@echo off
setlocal

echo ================================================
echo   欧加振动增强 LSPosed 模块编译脚本
echo ================================================
echo.

REM 检查是否安装了 JDK
where java >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 未检测到 Java JDK
    echo 请先安装 JDK 17 或更高版本
    echo 下载地址: https://adoptium.net/
    pause
    exit /b 1
)

echo [✓] Java 环境检测通过
java -version
echo.

REM 检查是否存在 gradlew
if not exist "gradlew.bat" (
    echo [提示] 初始化 Gradle Wrapper...
    gradle wrapper --gradle-version 8.1
)

echo [开始编译] 请稍候...
echo.

call gradlew.bat assembleRelease

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ================================================
    echo [✓] 编译成功！
    echo ================================================
    echo.
    echo APK 位置:
    echo app\build\outputs\apk\release\app-release.apk
    echo.
    echo 可以复制到手机安装了！
    echo ================================================

    REM 尝试打开输出目录
    if exist "app\build\outputs\apk\release\" (
        start "" "app\build\outputs\apk\release\"
    )
) else (
    echo.
    echo ================================================
    echo [✗] 编译失败
    echo ================================================
    echo.
    echo 可能的原因：
    echo 1. 未安装 Android SDK
    echo 2. 网络问题导致依赖下载失败
    echo.
    echo 建议：使用 Android Studio 打开项目编译
    echo 或参考"在线编译指南.md"使用 GitHub Actions
    echo ================================================
)

echo.
pause
