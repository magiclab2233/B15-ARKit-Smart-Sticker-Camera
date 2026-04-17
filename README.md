# B15-萌颜趣拍：ARKit智能贴纸相机

## 项目简介

萌颜趣拍是一款基于 Apple ARKit 实时人脸追踪技术的 iOS 萌拍相机应用。用户在自拍时可以通过点击鼻子自动添加趣味贴纸，并一键保存照片到本地相册。

项目旨在解决传统相机功能单一、缺乏趣味互动，以及第三方萌拍 App 广告繁多、性能不佳等问题，为用户提供无广告、高性能、本地化的贴纸拍照工具，适用于日常自拍娱乐、节日活动、儿童萌趣照片拍摄、线上社交内容创作以及教育场景中人脸识别和增强现实教学。

## 功能特点

- **实时人脸识别与跟踪**：使用 ARKit 提供的 `ARFaceTrackingConfiguration`，实时捕捉用户面部特征，实现 3D 几何脸部模型叠加。
- **鼻子贴图**：用户点击鼻子，可以切换不同的鼻子贴纸，实时预览趣味效果。
- **拍照保存到相册**：支持一键保存当前贴图状态，拍摄照片保存到 iOS 相册，方便分享到社交媒体。
- **流畅的 AR 渲染体验**：基于 SceneKit 实现高质量 3D 贴纸渲染，贴合面部轮廓，随表情实时变形。

## 技术架构与实现原理

### 整体架构

```
iPhone 前置摄像头 → ARSession(ARFaceTrackingConfiguration) → ARSCNView → SceneKit 渲染 → 鼻子贴纸叠加
```

### 核心技术

- **ARKit**：苹果增强现实框架，提供高精度的面部追踪与 3D 几何网格生成。
- **SceneKit**：3D 场景渲染引擎，用于将贴纸纹理贴合到 `ARSCNFaceGeometry` 上。
- **ARSCNFaceGeometry**：根据用户面部形状动态生成的 3D 几何体，确保贴纸完美贴合鼻子区域。
- **点击交互**：通过手势识别实现点击鼻子切换贴纸的交互效果。
- **AVFoundation / Photos**：拍照截图与相册保存。

### 关键源码说明

- `ViewController.swift`：主界面控制器，管理 ARSession 生命周期、贴纸切换逻辑与拍照功能。
- `FaceNode.swift`：面部节点模型，定义如何将鼻子贴纸纹理应用到面部几何体上。
- `AppDelegate.swift`：应用生命周期管理。

## 项目目录结构

```
B15-萌颜趣拍：ARKit智能贴纸相机/
├── IOS-Swift-ARkitFaceTrackingNose01.xcodeproj/     # Xcode 工程文件
├── IOS-Swift-ARkitFaceTrackingNose01/
│   ├── AppDelegate.swift
│   ├── ViewController.swift
│   ├── FaceNode.swift
│   ├── Info.plist
│   ├── Assets.xcassets/
│   └── Base.lproj/
│       ├── LaunchScreen.storyboard
│       └── Main.storyboard
└── README.md
```

## 安装与运行说明

### 环境要求

- macOS 系统 + Mac 电脑
- iPhone / iPad（支持 Face ID 或前置深感摄像头，iOS 15+）及数据线
- Apple ID（建议注册免费开发者账号）
- Xcode（最新版，通过 App Store 安装）

### 安装步骤

1. 克隆项目到本地：
   ```bash
   git clone https://github.com/magiclab2233/B15-ARKit-Smart-Sticker-Camera.git
   cd B15-ARKit-Smart-Sticker-Camera
   ```

2. 打开 Xcode 工程：
   ```bash
   open IOS-Swift-ARkitFaceTrackingNose01.xcodeproj
   ```

3. Xcode 签名配置：
   - 选择工程文件 → 修改 Bundle Identifier
   - 勾选 "Automatically manage signing"
   - Team 中选择个人 Apple ID 对应的免费开发者证书

4. 连接 iPhone，选择设备后点击运行按钮。

### 首次运行注意事项

- **开启开发者模式**：设置 → 隐私与安全 → 开发者模式 → 打开（需重启）。
- **信任开发者证书**：设置 → 通用 → VPN 与设备管理 → 选择个人证书 → 点击信任。
- **ARKit 面部追踪需要 TrueDepth 摄像头**，请在 iPhone X 及以上机型运行。

## 使用场景

- **日常自拍娱乐**：为自拍增添趣味元素，分享到朋友圈或社交平台。
- **节日活动/儿童摄影**：拍摄萌趣照片，记录欢乐时光。
- **线上社交内容创作**：快速生成带有 AR 特效的创意图片或视频。
- **AR 教学演示**：作为 iOS ARKit 人脸识别与增强现实技术的入门教学案例。

## 许可证/声明

本项目基于 ARKit 与 SceneKit 开发，部分示例代码遵循苹果官方 Sample Code 许可协议。项目仅供学习、教学演示与课程设计使用，涉及的贴纸素材版权归原作者所有。
