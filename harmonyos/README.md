# 一键取件 · 鸿蒙版

工程面向 HarmonyOS 5.0（API 12）及以上版本的手机。点桌面图标会尝试打开鸿蒙版拼多多的身份码页面。跳转失败时，可复制驿站链接到微信会话打开。

## 真机安装

1. 把工程解压到纯英文路径，例如 `D:/Harmony/QuickPickup`，用 DevEco Studio 打开该目录。
2. 在鸿蒙手机上打开开发者模式和 USB 调试，连接电脑。
3. 进入 `File → Project Structure → Project → Signing Configs`，启用自动签名。按提示登录华为开发者账号并完成签名后，点击 `Run` 安装。[华为调试签名说明](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-signing-auto/)

## 真机验收

在手机上登录拼多多，从桌面点「一键取件」，确认显示的是身份码页面，再用驿站机器扫码完成出库。
