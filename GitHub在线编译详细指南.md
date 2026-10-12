# GitHub Actions 在线编译 - 完整图文指南

## 🎯 为什么选择 GitHub Actions？

- ✅ **完全免费** - GitHub 提供免费的编译服务
- ✅ **无需本地环境** - 不需要安装 Android Studio 或 Gradle
- ✅ **自动化编译** - 上传代码后自动开始，3-5 分钟完成
- ✅ **绕过网络限制** - 在 GitHub 服务器上编译，不受本地网络影响

## 📋 准备工作

你需要：
- ✅ GitHub 账号（免费注册）
- ✅ Git 工具（或使用 GitHub 网页上传）

## 🚀 方法 1：使用 Git 命令行上传（推荐）

### 步骤 1：注册 GitHub 账号

访问: https://github.com/signup

### 步骤 2：创建新仓库

1. 登录 GitHub
2. 点击右上角 "+" → "New repository"
3. 填写信息：
   - Repository name: `OPlusVibratorBoost-LSPosed`
   - Description: `OPPO 振动增强 LSPosed 模块`
   - 选择 **Public**（必须选 Public 才能免费使用 Actions）
4. 点击 "Create repository"

### 步骤 3：上传代码

打开 **Git Bash**（或 CMD），执行：

```bash
# 进入项目目录
cd C:\Users\xilou\Desktop\LSPosed-Module

# 初始化 Git（如果还没有）
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: LSPosed vibration boost module"

# 关联远程仓库（替换成你的用户名）
git remote add origin https://github.com/你的用户名/OPlusVibratorBoost-LSPosed.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

### 步骤 4：等待自动编译

1. 上传完成后，访问你的仓库页面
2. 点击顶部的 **"Actions"** 标签
3. 你会看到一个正在运行的 workflow（黄色圆圈 🟡）
4. 等待 3-5 分钟，直到变成绿色对勾 ✅

### 步骤 5：下载编译好的 APK

1. 点击最新的 workflow run（绿色的那个）
2. 向下滚动到 **"Artifacts"** 区域
3. 点击 `OPlusVibratorBoost-LSPosed` 下载
4. 解压 ZIP 文件，得到 `app-release.apk`

## 📱 方法 2：使用网页直接上传（无需 Git）

如果不想用命令行，可以直接在网页上传：

### 步骤 1-2：同上（注册账号 + 创建仓库）

### 步骤 3：上传文件

1. 在仓库页面，点击 "uploading an existing file"
2. 将 `LSPosed-Module` 文件夹下的**所有文件和文件夹**拖入上传区
   - ⚠️ 注意：要上传文件夹内的内容，不是文件夹本身
   - 确保 `.github/workflows/build-apk.yml` 也被上传了

3. 在底部的 Commit changes 中：
   - 填写: `Initial commit`
   - 点击 "Commit changes"

### 步骤 4-5：同上（等待编译 + 下载 APK）

## 🔍 常见问题

### Q1: 上传后没有看到 Actions 自动运行？

**解决方案**:
1. 检查 `.github/workflows/build-apk.yml` 文件是否已上传
2. 进入仓库 Settings → Actions → General
3. 确保 "Allow all actions and reusable workflows" 已勾选

### Q2: Actions 运行失败了？

**解决方案**:
1. 点击失败的 workflow run
2. 点击 "build" 任务查看错误日志
3. 常见错误：
   - `Permission denied` → 仓库必须设为 Public
   - `No such file` → 检查文件是否完整上传

### Q3: 下载的是 ZIP 文件，里面没有 APK？

**解决方案**:
- Artifacts 下载的就是 ZIP 格式
- 解压后会得到 `app-release.apk` 或 `app-release-unsigned.apk`
- 两者都可以在 LSPosed 中安装

### Q4: 我没有 Git，怎么办？

**解决方案**:
使用方法 2（网页上传），完全不需要 Git！

## ⚡ 快速命令（复制粘贴版）

如果你已经有 GitHub 账号和仓库，直接复制这些命令：

```bash
cd C:\Users\xilou\Desktop\LSPosed-Module
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/你的用户名/OPlusVibratorBoost-LSPosed.git
git branch -M main
git push -u origin main
```

## 📸 预期结果

编译成功后，你会看到：

```
✓ Checkout code
✓ Set up JDK 17
✓ Grant execute permission for gradlew
✓ Build with Gradle
✓ Upload APK
```

然后在 Artifacts 里下载 APK 即可！

## 💡 提示

- 首次编译可能需要 5-10 分钟（下载依赖）
- 后续编译只需 2-3 分钟（有缓存）
- 编译是在 GitHub 服务器上进行的，完全不受本地网络影响
- 可以随时修改代码，推送后自动重新编译

## ✨ 优势总结

相比本地编译：
- ❌ 本地编译：需要下载 2GB+ 的 Android SDK 和依赖
- ❌ 本地编译：受网络环境限制
- ❌ 本地编译：需要配置复杂的开发环境

- ✅ GitHub Actions：完全免费
- ✅ GitHub Actions：无需本地环境
- ✅ GitHub Actions：自动化，一键编译
- ✅ GitHub Actions：稳定可靠

---

**强烈推荐使用 GitHub Actions！**

这是目前最简单、最可靠的编译方案，特别是对于网络环境受限的情况。
