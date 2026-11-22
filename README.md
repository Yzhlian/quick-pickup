# 快捷取件码

在手机桌面点一下，尝试打开拼多多身份码。到驿站后，把手机上的身份码对准出库设备。快捷入口省去了用手机扫描驿站贴纸的步骤，身份码由拼多多显示。

| 平台 | 用法 | 验证状态 |
| --- | --- | --- |
| iPhone | 用系统「快捷指令」添加主屏幕图标 | 已在用户手机上试通 |
| Android 6.0 及以上 | 安装 APK，点桌面的「一键取件」 | 已在用户手机上试通 |
| HarmonyOS 5.0 及以上 | 用 DevEco Studio 对工程自动签名后安装 | 已编译，待真机验证 |

## iPhone

1. 安装并登录拼多多。在「快捷指令」中新建「一键取件」，添加「URL」动作，粘贴下方地址。
2. 添加「打开 URL」动作。运行一次，确认显示身份码。
3. 选择「添加到主屏幕」。以后点桌面图标即可打开入口。[Apple 主屏幕设置说明](https://support.apple.com/en-lamr/guide/shortcuts/apd735880972/ios)

```text
pinduoduo://com.xunmeng.pinduoduo/mdkd/package?tab=ID_CODE&entry_source=11
```

此地址也用于开源项目 [PickTool 的 iOS 配置](https://github.com/yimeifun/PickTool/blob/main/ios/%E5%BF%AB%E6%8D%B7%E6%8C%87%E4%BB%A4%E9%85%8D%E7%BD%AE.md#拼多多身份码)。

## Android

1. 从 [下载页](https://github.com/Yzhlian/quick-pickup/releases/latest) 下载 `pickup-android.apk`，传到手机安装。
2. 登录拼多多，点桌面图标「一键取件」。桌面没自动显示图标时，可从应用列表拖到桌面。
3. 如果跳转失败，可在提示框复制驿站链接，再到微信会话中粘贴并打开。

源码在 [android/](android/)。在 Windows 上安装 JDK、Android SDK Platform 36 和 Build Tools 36.0.0 后，可以构建体验包。

```powershell
cd android
./build.ps1 -AndroidSdk 'C:/Path/To/Android/Sdk'
```

产物位于 `android/dist/pickup-android.apk`。构建脚本在本机保存调试密钥。同一个应用的覆盖安装需要保持签名一致。

## HarmonyOS

从 [下载页](https://github.com/Yzhlian/quick-pickup/releases/latest) 下载 `pickup-harmonyos-project.zip`，解压到英文路径，例如 `D:/Harmony/QuickPickup`。用 DevEco Studio 打开工程，连接开启 USB 调试的手机，在 `Project Structure → Project → Signing Configs` 启用自动签名，再点击 `Run`。[华为调试签名说明](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-signing-auto/)

下载页中的 `pickup-harmonyos-unsigned.hap` 是已编译的未签名包，真机安装需要调试签名。鸿蒙版会尝试打开拼多多身份码，跳转失败时可复制微信驿站链接。手机上的出码效果和驿站扫码结果仍需实测。[鸿蒙工程说明](harmonyos/README.md)

## 驿站入口

如果只打开拼多多首页，或没有显示身份码，可以在微信会话里打开[照片上的驿站入口](https://mdkd.pinduoduo.com/weixin/package?tab=ID_CODE)。应用发布方可能调整跳转地址或登录流程，遇到这种情况可先用微信入口取件。
