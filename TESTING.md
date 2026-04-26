# StatusInsights Client — 测试说明

本文档说明如何在各支持平台上构建并测试 **StatusInsights Client**。

---

## 目录

1. [环境准备](#环境准备)
2. [通用测试步骤](#通用测试步骤)
3. [Windows](#windows)
4. [Linux](#linux)
5. [macOS](#macos)
6. [Android](#android)
7. [iOS](#ios)
8. [功能验证清单](#功能验证清单)

---

## 环境准备

所有平台均需要先安装 Flutter SDK（版本 ≥ 3.22.0）并配置好 Dart。

```bash
# 验证 Flutter 安装及已连接设备
flutter doctor -v
```

确保 `flutter doctor` 中对应平台的检查项全部通过（显示 ✓）后再继续。

安装项目依赖：

```bash
cd StatusInsights-Client
flutter pub get
```

---

## 通用测试步骤

以下步骤适用于所有平台，在进行平台专项测试之前请先执行。

### 1. 静态分析

```bash
flutter analyze
```

所有文件应无错误（error），警告（warning）可酌情修复。

### 2. 单元测试

```bash
flutter test
```

### 3. 热重载调试运行

```bash
# 列出可用设备/模拟器
flutter devices

# 在指定设备上运行（将 <device-id> 替换为实际 ID）
flutter run -d <device-id>
```

---

## Windows

### 环境要求

| 工具 | 说明 |
|------|------|
| Windows 10 / 11 (64-bit) | 构建和运行环境 |
| Visual Studio 2022 | 需勾选「使用 C++ 的桌面开发」工作负载 |
| PowerShell 5.1+ | 用于获取前台窗口标题（系统自带，通常无需额外安装） |

### 运行步骤

```bash
# 调试模式运行
flutter run -d windows

# 构建 Release 版本
flutter build windows --release
# 产物位于：build\windows\x64\runner\Release\
```

### Windows 专项验证

- **前台窗口标题检测**：启动自动上报后，切换到其他应用窗口（如记事本、浏览器），等待最多 20 秒，确认「当前窗口」字段更新为该窗口标题。
- **高 DPI 显示**：在 150% / 200% 缩放比例的屏幕上运行，界面应等比缩放，无文字截断。
- **深色模式**：切换系统主题（设置 → 颜色 → 深色），应用应自动跟随。

---

## Linux

### 环境要求

| 工具 | 说明 |
|------|------|
| Ubuntu 22.04 / Debian 12 或同等发行版 | 推荐构建环境 |
| `clang`, `cmake`, `ninja-build` | C++ 构建工具 |
| `libgtk-3-dev`, `pkg-config` | GTK 开发库 |
| `xdotool`（可选，推荐安装） | X11 下获取前台窗口标题 |

```bash
# Debian / Ubuntu 安装依赖
sudo apt-get install -y clang cmake ninja-build libgtk-3-dev pkg-config xdotool
```

### 运行步骤

```bash
# 调试模式运行
flutter run -d linux

# 构建 Release 版本
flutter build linux --release
# 产物位于：build/linux/x64/release/bundle/
```

### Linux 专项验证

- **前台窗口标题检测（X11）**：确认已安装 `xdotool`，启动上报后切换窗口，标题应正常更新。
- **Wayland 环境**：在纯 Wayland 会话中，`xdotool` 不可用，「当前窗口」字段应显示为空或「未检测到」，应用不应崩溃。
- **中文字体**：确保系统已安装中文字体（如 `fonts-noto-cjk`），中文界面文字应正常显示无乱码。

---

## macOS

### 环境要求

| 工具 | 说明 |
|------|------|
| macOS 10.14 (Mojave) 或更高版本 | 运行环境 |
| Xcode 14 或更高版本 | 包含 Command Line Tools |
| CocoaPods | Flutter 插件依赖管理 |

```bash
sudo gem install cocoapods
```

### 运行步骤

```bash
# 调试模式运行
flutter run -d macos

# 构建 Release 版本
flutter build macos --release
# 产物位于：build/macos/Build/Products/Release/StatusInsights Client.app
```

### macOS 专项验证

- **沙盒网络权限**：`DebugProfile.entitlements` 和 `Release.entitlements` 已包含 `com.apple.security.network.client`，确认可正常连接服务器（注册、上报不报权限错误）。
- **前台窗口标题检测**：macOS 13+ 需在「系统设置 → 隐私与安全性 → 辅助功能」中授权应用，否则 `osascript` 调用将失败，此时「当前窗口」应显示为空而非崩溃。
- **深色模式**：在系统偏好设置中切换外观，应用主题应自动跟随。

---

## Android

### 环境要求

| 工具 | 说明 |
|------|------|
| Android Studio | 含 Android SDK（API 21+） |
| 真机或模拟器 | API 21（Android 5.0）及以上 |
| USB 调试已开启 | 真机测试时需要 |

### 运行步骤

```bash
# 启动 Android 模拟器（或连接真机）
flutter devices   # 确认设备已列出

# 调试模式运行
flutter run -d <android-device-id>

# 构建 APK（Debug）
flutter build apk --debug

# 构建 APK（Release，需配置签名）
flutter build apk --release
# 产物位于：build/app/outputs/flutter-apk/app-release.apk
```

### Android 专项验证

- **窗口标题不可用**：Android 无法获取前台窗口标题，「当前窗口」字段应始终为空，不应显示错误。
- **设备类型识别**：在「设备信息」卡片中，「设备类型」应显示 `🤖 Android`。
- **网络请求**：`AndroidManifest.xml` 已包含 `INTERNET` 权限，注册与状态上报应正常工作。
- **横竖屏旋转**：旋转设备后界面应正确布局，不出现内容溢出。

---

## iOS

### 环境要求

| 工具 | 说明 |
|------|------|
| macOS + Xcode 14+ | iOS 构建必须在 macOS 上进行 |
| iOS 模拟器或真机 | iOS 12.0 及以上 |
| Apple 开发者账号（真机部署） | 免费账号可在真机调试 |
| CocoaPods | 依赖管理 |

```bash
# 在项目 ios 目录安装 Pod（首次或依赖变更后执行）
cd ios && pod install && cd ..
```

### 运行步骤

```bash
# 调试模式运行（模拟器或真机）
flutter run -d <ios-device-id>

# 构建 Runner.app（Debug）
flutter build ios --debug --no-codesign

# 构建 Release（需配置证书）
flutter build ios --release
```

### iOS 专项验证

- **窗口标题不可用**：与 Android 相同，「当前窗口」字段应为空。
- **设备类型识别**：「设备类型」应显示 `📱 iOS`。
- **网络请求（ATS）**：若服务器使用 HTTP（非 HTTPS），需在 `Info.plist` 中添加 `NSAppTransportSecurity` 例外，或使用 HTTPS 服务器。
- **iPad 横屏**：应用支持横竖屏，在 iPad 上布局应正常适配。

---

## 功能验证清单

完成平台构建后，按照以下流程逐项验证核心功能：

| # | 测试项 | 预期结果 |
|---|--------|----------|
| 1 | 首次启动，检查「设备 GUID」 | 自动生成一个 UUID v4，重启后保持不变 |
| 2 | 服务器地址未填写时，尝试注册 | 「注册设备」按钮置灰，顶部显示服务器未配置提示 |
| 3 | 填写正确的 StatusInsights 服务器地址并保存 | 显示「服务器地址已更新」提示 |
| 4 | 点击「注册设备」 | 成功：显示绿色「设备注册成功」横幅，状态徽章变为「已注册」 |
| 5 | 点击「开始上报」 | 状态指示灯变绿，「上次上报」时间开始更新（约 20 秒内） |
| 6 | 桌面平台：切换前台窗口 | 「当前窗口」字段在下次上报时更新为新窗口标题 |
| 7 | 输入自定义个人状态并点击「提交状态」 | 显示「状态提交成功」，状态历史中出现新条目 |
| 8 | 点击「设备 GUID」 | 显示「已复制到剪贴板」提示，剪贴板内容为 GUID |
| 9 | 点击「停止上报」 | 状态指示灯变灰，上报停止 |
| 10 | 点击「取消注册」，在确认对话框中确认 | 状态徽章变为「未注册」，自动上报已停止 |
| 11 | 切换系统语言至中文 | 所有界面文本显示为中文 |
| 12 | 切换系统语言至日文 | 所有界面文本显示为日文 |

---

## 常见问题

**Q：`flutter doctor` 提示找不到 Visual Studio / Xcode？**  
A：按照 [Flutter 官方文档](https://docs.flutter.dev/get-started/install) 完成对应平台的工具链安装。

**Q：Linux 下前台窗口标题始终为空？**  
A：执行 `which xdotool` 确认是否已安装，或执行 `xdotool getactivewindow` 手动验证。Wayland 环境不支持此功能，属于预期行为。

**Q：macOS 上 `osascript` 返回权限错误？**  
A：在「系统设置 → 隐私与安全性 → 辅助功能」中将本应用（或终端）加入允许列表。

**Q：Android / iOS 上状态上报无响应？**  
A：检查服务器地址是否以 `https://` 开头（iOS ATS 要求），以及网络连接是否正常。
