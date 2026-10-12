@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║     欧加振动增强 LSPosed 模块 - 智能编译助手              ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

REM ============================================================
REM 步骤 1: 检测 Java 环境
REM ============================================================
echo [步骤 1/5] 检测 Java 环境...
where java >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ✗ 未检测到 Java JDK
    echo.
    echo 请先安装 JDK 17 或更高版本
    echo 下载地址: https://adoptium.net/
    echo.
    pause
    exit /b 1
)

java -version 2>&1 | findstr /i "version" >nul
if %ERRORLEVEL% EQU 0 (
    echo ✓ Java 环境已就绪
) else (
    echo ✗ Java 版本检测失败
    pause
    exit /b 1
)

REM ============================================================
REM 步骤 2: 检测 Android Studio / Android SDK
REM ============================================================
echo.
echo [步骤 2/5] 检测 Android SDK...

set "SDK_FOUND=0"

REM 检查常见的 SDK 位置
if exist "%LOCALAPPDATA%\Android\Sdk\platforms" (
    set "ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk"
    set "SDK_FOUND=1"
    echo ✓ 找到 Android SDK: !ANDROID_HOME!
) else if exist "%USERPROFILE%\AppData\Local\Android\Sdk\platforms" (
    set "ANDROID_HOME=%USERPROFILE%\AppData\Local\Android\Sdk"
    set "SDK_FOUND=1"
    echo ✓ 找到 Android SDK: !ANDROID_HOME!
) else (
    echo ✗ 未找到 Android SDK
    echo.
    echo 你有两个选择:
    echo   1. 安装 Android Studio (推荐, 包含完整 SDK)
    echo      下载: https://developer.android.com/studio
    echo.
    echo   2. 只安装 Android SDK Command Line Tools
    echo      下载: https://developer.android.com/studio#command-tools
    echo.
    echo 安装后请重新运行此脚本
    pause
    exit /b 1
)

set "ANDROID_SDK_ROOT=%ANDROID_HOME%"

REM ============================================================
REM 步骤 3: 检查网络连接
REM ============================================================
echo.
echo [步骤 3/5] 检查网络连接...
ping -n 1 services.gradle.org >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo ✓ 网络连接正常
    set "NETWORK_OK=1"
) else (
    echo ⚠ 无法连接到 Gradle 服务器
    echo   如果有代理, 请在 gradle.properties 中配置
    set "NETWORK_OK=0"
)

REM ============================================================
REM 步骤 4: 初始化 Gradle Wrapper (如果需要)
REM ============================================================
echo.
echo [步骤 4/5] 准备编译环境...

if not exist "gradlew.bat" (
    echo   正在初始化 Gradle Wrapper...
    where gradle >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        gradle wrapper --gradle-version 8.1 --no-daemon
        echo ✓ Gradle Wrapper 初始化完成
    ) else (
        echo   ⚠ 系统未安装 Gradle
        echo   尝试使用 Android Studio 的 Gradle...

        if exist "%ANDROID_HOME%\..\gradle" (
            for /d %%G in ("%ANDROID_HOME%\..\gradle\gradle-*") do (
                set "GRADLE_HOME=%%G"
                goto :found_gradle
            )
        )

        :found_gradle
        if defined GRADLE_HOME (
            "!GRADLE_HOME!\bin\gradle.bat" wrapper --gradle-version 8.1 --no-daemon
            echo ✓ 已使用 Android Studio 的 Gradle 初始化
        ) else (
            echo   ✗ 无法初始化 Gradle Wrapper
            echo.
            echo   建议: 使用 Android Studio 打开项目编译
            echo   或手动安装 Gradle: https://gradle.org/install/
            pause
            exit /b 1
        )
    )
)

REM ============================================================
REM 步骤 5: 开始编译
REM ============================================================
echo.
echo [步骤 5/5] 开始编译 APK...
echo.
echo ────────────────────────────────────────────────────────────
echo.

call gradlew.bat clean assembleRelease --no-daemon

echo.
echo ────────────────────────────────────────────────────────────
echo.

REM ============================================================
REM 检查编译结果
REM ============================================================
if exist "app\build\outputs\apk\release\app-release.apk" (
    echo ╔═══════════════════════════════════════════════════════════╗
    echo ║                    ✓ 编译成功！                           ║
    echo ╚═══════════════════════════════════════════════════════════╝
    echo.
    echo APK 位置:
    echo %CD%\app\build\outputs\apk\release\app-release.apk
    echo.

    REM 获取文件大小
    for %%A in ("app\build\outputs\apk\release\app-release.apk") do (
        set "SIZE=%%~zA"
        set /a SIZE_KB=!SIZE! / 1024
        echo 文件大小: !SIZE_KB! KB
    )

    echo.
    echo 下一步:
    echo   1. 将 app-release.apk 传到手机
    echo   2. 在 LSPosed Manager 中安装
    echo   3. 勾选要作用的应用 (推荐: 系统框架 + 系统界面)
    echo   4. 重启手机生效
    echo.

    REM 尝试打开输出目录
    start "" "app\build\outputs\apk\release\"

) else if exist "app\build\outputs\apk\release\app-release-unsigned.apk" (
    echo ╔═══════════════════════════════════════════════════════════╗
    echo ║              ✓ 编译成功 (未签名版本)                     ║
    echo ╚═══════════════════════════════════════════════════════════╝
    echo.
    echo APK 位置:
    echo %CD%\app\build\outputs\apk\release\app-release-unsigned.apk
    echo.
    echo ⚠ 注意: 此 APK 未签名
    echo   LSPosed 可以直接安装未签名的模块
    echo   如果需要签名, 可以使用 Android Studio 或 apksigner
    echo.

    start "" "app\build\outputs\apk\release\"

) else (
    echo ╔═══════════════════════════════════════════════════════════╗
    echo ║                    ✗ 编译失败                            ║
    echo ╚═══════════════════════════════════════════════════════════╝
    echo.
    echo 可能的原因:
    echo   1. 网络问题导致依赖下载失败
    echo   2. Android SDK 配置不完整
    echo   3. Gradle 版本不兼容
    echo.
    echo 建议的解决方案:
    echo.
    echo 【方案 A】使用 Android Studio (最简单)
    echo   1. 打开 Android Studio
    echo   2. File → Open → 选择此文件夹
    echo   3. 等待 Gradle 同步完成
    echo   4. Build → Build APK
    echo.
    echo 【方案 B】使用 GitHub Actions (在线编译)
    echo   查看: 在线编译指南.md
    echo.
    echo 【方案 C】配置网络代理
    echo   在 gradle.properties 中添加:
    echo   systemProp.http.proxyHost=代理地址
    echo   systemProp.http.proxyPort=代理端口
    echo   systemProp.https.proxyHost=代理地址
    echo   systemProp.https.proxyPort=代理端口
    echo.
)

echo.
pause
