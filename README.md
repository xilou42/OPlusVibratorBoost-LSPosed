# 欧加真马达振动增强【LSPosed 版】

## 📱 适配设备

- **平台**：联发科天玑 9500 (MT6993)
- **马达**：艾为 AW86927 (device_id: 816)
- **设备**：OPPO Find X9 Pro (OP5E11L1)
- **通用**：支持所有 Android 设备（无需特定驱动）

## ✨ 特性

- ✅ **通用兼容**：基于 Android VibratorManager API，适配所有平台
- ✅ **无需 Root 修改**：不触碰系统分区，绕过 SELinux/erofs 限制
- ✅ **自动增强 2 倍**：拦截所有振动请求，自动放大强度参数
- ✅ **零配置**：安装后在 LSPosed 中激活即可生效

## 📦 安装步骤

### 前置要求

1. 已安装 **LSPosed** 或 **EdXposed** 框架
2. 手机已 Root（KernelSU / Magisk / APatch）

### 安装流程

1. **编译 APK**：
   ```bash
   ./gradlew assembleRelease
   ```
   APK 位于：`app/build/outputs/apk/release/app-release.apk`

2. **安装模块**：
   - 复制 APK 到手机
   - 安装 APK

3. **在 LSPosed 中激活**：
   - 打开 LSPosed Manager
   - 进入「模块」→「欧加振动增强」
   - 勾选「系统框架 (android)」
   - 勾选「系统界面 (com.android.systemui)」
   - 重启手机

4. **验证效果**：
   - 打开「设置」→「声音与振动」
   - 测试键盘、通知、触摸反馈
   - 振动强度应明显增强

## 🔧 工作原理

### Hook 机制

模块通过 Xposed 框架 Hook 以下 Android API：

1. **`Vibrator.vibrate(VibrationEffect)`**
   - 拦截振动请求
   - 提取 `VibrationEffect` 对象
   - 修改振幅参数并放大 2 倍

2. **`VibrationEffect.createOneShot(long, int)`**
   - 拦截单次振动创建
   - 将振幅参数 `amplitude` 乘以 2
   - 限制最大值为 255

3. **`VibrationEffect.createWaveform(long[], int[], int)`**
   - 拦截波形振动创建
   - 遍历振幅数组 `amplitudes[]`
   - 每个元素乘以 2 并限制最大值

### 优势

相比传统 Root 模块：

| 方案 | SELinux | erofs | 平台兼容 | 配置 |
|------|---------|-------|----------|------|
| **LSPosed Hook** | ✅ 绕过 | ✅ 绕过 | ✅ 全平台 | ✅ 零配置 |
| Root 脚本修改 | ❌ 阻止写入 | ❌ 只读分区 | ❌ 平台特定 | ❌ 需适配 |
| 二进制补丁 | ❌ 阻止加载 | ❌ 无法覆盖 | ❌ 设备特定 | ❌ 需提取 |

## ⚠️ 注意事项

1. **不要进行马达校准**：增强后的振动可能超出校准预期
2. **电池续航**：振动强度增加会略微增加耗电
3. **兼容性**：部分第三方应用可能有自己的振动实现，不受 Hook 影响

## 🐛 故障排查

### 模块激活但无效果

1. 检查 LSPosed 日志：
   ```
   Hooking package: android
   Successfully hooked Vibrator.vibrate()
   Successfully hooked VibrationEffect creation methods
   ```

2. 确认作用域：
   - 必须勾选「系统框架 (android)」
   - 建议勾选「系统界面 (com.android.systemui)」

3. 重启手机生效

### 振动过强

修改 `XposedEntry.java` 中的增强倍数：
```java
private static final float BOOST_MULTIPLIER = 1.5f;  // 降低到 1.5 倍
```

重新编译安装。

## 📄 许可

基于原版「欧加真马达振动增强【复生版】1.36」改编  
原作者：慨miru  
LSPosed 适配：慨miru + LSPosed 适配

## 🔗 相关项目

- [LSPosed Framework](https://github.com/LSPosed/LSPosed)
- [Xposed API](https://api.xposed.info/)
