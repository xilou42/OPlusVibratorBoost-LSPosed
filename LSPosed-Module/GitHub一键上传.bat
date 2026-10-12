@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║   GitHub Actions 自动编译 - 一键上传脚本                 ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

cd /d "%~dp0"

REM 检查 Git 状态
git status >nul 2>&1
if errorlevel 1 (
    echo ✗ 当前目录不是 Git 仓库
    echo.
    pause
    exit /b 1
)

echo ════════════════════════════════════════════════════════════
echo   准备上传到 GitHub
echo ════════════════════════════════════════════════════════════
echo.

REM 检查是否已配置远程仓库
git remote get-url origin >nul 2>&1
if not errorlevel 1 (
    echo 检测到已配置的远程仓库:
    git remote get-url origin
    echo.
    echo 要使用现有配置吗？
    echo   [1] 使用现有配置继续上传
    echo   [2] 重新配置
    echo   [0] 取消
    echo.
    set /p use_existing="请选择 (0-2): "

    if "!use_existing!"=="1" goto push
    if "!use_existing!"=="0" exit /b 0

    echo.
    echo 删除现有远程配置...
    git remote remove origin
)

echo.
echo ════════════════════════════════════════════════════════════
echo   第 1 步: GitHub 账号信息
echo ════════════════════════════════════════════════════════════
echo.
echo 如果还没有 GitHub 账号，请先访问:
echo   https://github.com/signup
echo.

set /p github_user="请输入你的 GitHub 用户名: "

if "!github_user!"=="" (
    echo.
    echo ✗ 用户名不能为空
    pause
    exit /b 1
)

echo.
echo ════════════════════════════════════════════════════════════
echo   第 2 步: 创建 GitHub 仓库
echo ════════════════════════════════════════════════════════════
echo.
echo 请按以下步骤操作:
echo.
echo   1. 访问: https://github.com/new
echo   2. Repository name: OPlusVibratorBoost-LSPosed
echo   3. 选择 Public (必须，才能免费使用 Actions)
echo   4. 不要勾选 "Add a README"
echo   5. 点击 "Create repository"
echo.
echo 完成后按任意键继续...
pause >nul

echo.
echo ════════════════════════════════════════════════════════════
echo   第 3 步: 配置远程仓库
echo ════════════════════════════════════════════════════════════
echo.

set "repo_url=https://github.com/!github_user!/OPlusVibratorBoost-LSPosed.git"
echo 远程仓库地址: !repo_url!
echo.

git remote add origin "!repo_url!"
if errorlevel 1 (
    echo ✗ 配置远程仓库失败
    pause
    exit /b 1
)

echo ✓ 远程仓库配置成功
echo.

:push
echo ════════════════════════════════════════════════════════════
echo   第 4 步: 上传代码到 GitHub
echo ════════════════════════════════════════════════════════════
echo.
echo 正在上传...
echo.

git branch -M main
git push -u origin main

if errorlevel 1 (
    echo.
    echo ╔═══════════════════════════════════════════════════════════╗
    echo ║   ✗ 上传失败                                              ║
    echo ╚═══════════════════════════════════════════════════════════╝
    echo.
    echo 可能的原因:
    echo   • GitHub 仓库不存在
    echo   • 用户名错误
    echo   • 网络连接问题
    echo   • 需要 GitHub 身份验证
    echo.
    echo 解决方案:
    echo   1. 检查仓库是否已创建
    echo   2. 确认用户名是否正确
    echo   3. 如需身份验证，按提示输入 Personal Access Token
    echo.
    echo 创建 Token:
    echo   https://github.com/settings/tokens/new
    echo   • Note: LSPosed Module Build
    echo   • Expiration: 90 days
    echo   • 勾选: repo (完整权限)
    echo.
    pause
    exit /b 1
)

echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║               ✓✓✓ 上传成功！✓✓✓                          ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

echo ════════════════════════════════════════════════════════════
echo   第 5 步: 等待自动编译
echo ════════════════════════════════════════════════════════════
echo.

git remote get-url origin >temp_url.txt
set /p remote_url=<temp_url.txt
del temp_url.txt

REM 从 URL 中提取用户名和仓库名
for /f "tokens=4,5 delims=/:." %%a in ("!remote_url!") do (
    set "extracted_user=%%a"
    set "extracted_repo=%%b"
)

if not defined extracted_user set "extracted_user=!github_user!"
if not defined extracted_repo set "extracted_repo=OPlusVibratorBoost-LSPosed"

set "actions_url=https://github.com/!extracted_user!/!extracted_repo!/actions"

echo GitHub Actions 正在自动编译，预计 3-5 分钟...
echo.
echo 查看编译进度:
echo   !actions_url!
echo.
echo 编译完成后:
echo   1. 点击最新的 workflow run (绿色 ✓)
echo   2. 向下滚动到 "Artifacts" 区域
echo   3. 点击下载 "OPlusVibratorBoost-LSPosed"
echo   4. 解压 ZIP 得到 APK
echo.

REM 询问是否打开浏览器
echo 要现在打开 GitHub Actions 页面吗？
echo   [1] 是，打开浏览器
echo   [0] 不，稍后手动访问
echo.
set /p open_browser="请选择 (0/1): "

if "!open_browser!"=="1" (
    start "" "!actions_url!"
    echo.
    echo ✓ 已在浏览器中打开
)

echo.
echo ════════════════════════════════════════════════════════════
echo   完成！
echo ════════════════════════════════════════════════════════════
echo.
echo 下一步:
echo   • 等待 GitHub Actions 编译完成 (刷新页面查看)
echo   • 看到绿色 ✓ 后下载 APK
echo   • 安装到 LSPosed Manager
echo.
pause
