# Soflume UI (Soft Lumen Design System)

> **Soft to touch. Alive in motion.**  
> 现代化、高级、圆润、柔和、通透、灵动的 Flutter 跨平台设计系统与组件库。

[![CI Quality Gate](https://github.com/yhan-sun/Veyra-UI/actions/workflows/deploy.yml/badge.svg)](https://github.com/yhan-sun/Veyra-UI/actions/workflows/deploy.yml)
[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.27-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D3.6-blue.svg)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub Pages](https://img.shields.io/badge/Demo-GitHub%20Pages-success.svg)](https://yhan-sun.github.io/Veyra-UI/)

---

## 在线体验 (Live Web Demo)

Soflume UI 现已通过 GitHub Actions 自动化部署至 GitHub Pages：

**[https://yhan-sun.github.io/Veyra-UI/](https://yhan-sun.github.io/Veyra-UI/)**

包含：
- **全组件交互画廊 (Component Gallery)**：微交互、弹簧动效、代码示例（一键查看复制）。
- **实时设计系统与主题编辑器 (Design System & Theme Editor)**：实时调色盘、G2 连续超椭圆圆角阶梯、间距网格诊断。
- **4 大旗舰级原生实装 App**：
  1. **设置中心 (Settings App)**
  2. **柔光音乐播放器 (Music App)**
  3. **自适应文件管理器 (File Manager)**
  4. **数据与监控看板 (Analytics Dashboard)**

---

## 设计哲学与特点

Soflume UI 是一套面向移动端（iOS / Android）、平板、折叠屏与桌面端（macOS / Windows / Linux）的现代化 Flutter 组件库。吸收 **vivo OriginOS**（连续动画与自然光学）、**华为 HarmonyOS**（空间秩序与多终端协同）、**OPPO ColorOS**（精致光影与微交互）、**小米 HyperOS**（动态胶囊与灵动触感）以及 **Apple iOS / macOS**（交互一致性与可访问性）的设计精髓，形成独立且高度统一的 **Soft Lumen（柔光美学）** 视觉语言。

- **G2 连续曲率圆角 (Continuous Squircle)**：告别生硬圆角，提供真正物理级平滑过渡的高级超椭圆轮廓（`SofSquircleBorder`）。
- **物理弹簧微交互 (Harmonic Springs)**：全套弹簧力学阻尼曲线（`SofSpringCurve`），按下回弹自然，手势随时可中断。
- **全矢量光学 SVG 体系 (Optical Vector Icons)**：全库拒绝平台割裂的 Emoji，全内置 24x24 几何光学规范平滑端点 SVG 图标集（`SofIcon` & `SofIcons`）。
- **Soft Lumen 材质模型**：提供 `Solid`（高性能实色）、`Frost`（18σ 动态高斯半透雾化）、`Ambient`（柔光漫射渐变）与 `Floating`（多阶弥散阴影）四重材质。
- **多设备全场景自适应 (Responsive & Adaptive)**：内置 `Compact` (<600dp)、`Medium` (600–1023dp) 与 `Expanded` (>=1024dp) 断点及密度系统（`compact`, `comfortable`, `spacious`）。
- **高质感无障碍友好**：严格遵循 WCAG AA 文本对比度标准，全组件内置键盘焦点光晕（`SofFocusRing`）与屏幕阅读语义支持。

---

## 架构组织 (Monorepo)

```text
Veyra-UI/
├── tokens/
│   └── soflume_tokens.json          # 设计 Token 原始源（颜色、曲率、间距、动效）
├── packages/
│   └── soflume_ui/                  # 核心组件库 Package
│       ├── lib/
│       │   ├── foundation/          # Tokens, Theme, Shapes (Squircle), Motion, Layout, Vector Icons
│       │   ├── primitives/          # SofPressable, SofSurface, SofFocusRing
│       │   ├── components/          # Button, Toggle, Input, Card, Slider, Tabs, Dialog...
│       │   └── signature/           # FluidSheet, MorphingButton, LiveCapsule, AdaptiveTile...
│       └── test/                    # 完整单元测试与 Widget 测试 (100% 通过)
└── example/                         # 官方展示展馆 & 4 个完整实装业务 App
    ├── lib/
    │   ├── showcase/
    │   │   ├── gallery_screen.dart  # 全组件可交互 Playground
    │   │   └── theme_editor.dart    # 实时主题编辑器（调色盘/圆角/密度预览）
    │   └── apps/
    │       ├── settings_app.dart    # 1. 深度设置中心 (Settings App)
    │       ├── music_app.dart       # 2. 柔光音乐播放器 (Music App)
    │       ├── file_manager_app.dart# 3. 桌面自适应文件管理器 (File Manager)
    │       └── dashboard_app.dart   # 4. 实时数据与监控看板 (Analytics Dashboard)
    └── test/                        # 展馆端对端组件验证
```

---

## 快速上手

### 1. 添加依赖

在你的 `pubspec.yaml` 中引入：

```yaml
dependencies:
  flutter:
    sdk: flutter
  soflume_ui:
    path: path/to/packages/soflume_ui
```

### 2. 使用 SoflumeTheme

```dart
import 'package:flutter/widgets.dart';
import 'package:soflume_ui/soflume_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SoflumeTheme(
      data: SoflumeThemeData.light(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SofSurface(
          child: Center(
            child: SofButton(
              variant: SofButtonVariant.filled,
              leading: const SofIcon(SofIcons.zap, size: 18),
              onPressed: () {},
              child: const Text('开始体验 Soflume'),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 代表性组件与品牌特色

| 标志性组件 | 功能说明 |
|---|---|
| **SofFluidSheet** | 手势驱动、可随时中断并附带自然阻尼的流体底部抽屉。 |
| **SofMorphingButton** | 按钮 → 环形 Loading → 成功/失败勾选的同源无缝形变按钮。 |
| **SofLiveCapsule** | 动态任务与媒体播放悬浮胶囊，支持点击顺滑展开成交互卡片。 |
| **SofFloatingNavigation** | 悬浮磨砂玻璃交互底栏，带物理弹簧滑动指示气泡。 |
| **SofAdaptiveTile** | 带有动态柔光呼吸效果的多功能数据与流媒体磁贴。 |
| **SofLuminousSlider** | 带有跟随拇指位置发射柔光微晕（Soft Lumen Glow）的高级滑块。 |
| **SofIcon & SofIcons** | 原生光学级平滑端点 24x24 矢量 SVG 图标集，自动适配主题色与尺寸。 |

---

## 自动化测试与工程质量

在 `packages/soflume_ui` 与 `example` 目录下均已建立并通过严格测试门禁：

```bash
# 静态分析（包含 strict-casts / strict-inference / strict-raw-types）
flutter analyze

# 自动化单元测试与组件交互测试
flutter test
```
