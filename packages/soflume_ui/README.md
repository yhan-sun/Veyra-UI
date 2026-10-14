# Soflume UI (柔光美学)

<p align="center">
  <strong>A futuristic, premium Flutter cross-platform UI component library and design system inspired by Soft Lumen aesthetics.</strong>
</p>

<p align="center">
  <a href="https://github.com/yhan-sun/Veyra-UI/actions"><img src="https://img.shields.io/badge/build-passing-brightgreen.svg" alt="Build Status"></a>
  <a href="https://yhan-sun.github.io/Veyra-UI/"><img src="https://img.shields.io/badge/showcase-live%20demo-blue.svg" alt="Live Showcase"></a>
  <a href="https://github.com/yhan-sun/Veyra-UI/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/flutter-%3E%3D3.10.0-blue.svg" alt="Flutter"></a>
</p>

---

## 🌟 Philosophy: Soft Lumen (柔光美学)

Soflume UI is an independent Flutter design system built from the ground up for modern cross-platform applications across iOS, Android, macOS, Windows, Linux, and Web.

Rather than wrapping standard Material 3 or Cupertino widgets, Soflume UI synthesizes the best design principles from flagship smartphone operating systems:
- **vivo OriginOS**: Continuous curvature, optical transparency, dynamic materials, and realistic spring mechanics.
- **Huawei HarmonyOS**: Spatial order, serene layouts, cross-device consistency, and tactile density.
- **OPPO ColorOS**: Exquisite lighting, refined micro-interactions, and smooth state morphing.
- **Xiaomi HyperOS**: Dynamic capsules, floating surfaces, and system-level fluid feedback.
- **Apple iOS / macOS**: Flawless keyboard accessibility, WCAG contrast compliance, and typography hierarchy.

### Core Visual Tenets
- **Curvature**: True superellipse squircles ($n \approx 4.0$) avoiding harsh corner discontinuities.
- **Luminosity**: Multi-layered frosted glass surfaces, subtle depth blur, and luminous glow accents.
- **Fluid Motion**: Damped harmonic oscillator spring curves (`SofSpringCurve`) with interruptible gestures.
- **Zero Emoji**: 100% precision 24x24 SVG vector icons (`SofIcons`) optimized for subpixel sharpness.
- **Accessibility**: Real WCAG 2.1 AA/AAA relative luminance contrast calculations with automatic high-contrast selection.

---

## 🚀 Getting Started

### 1. Installation

Add `soflume_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  soflume_ui:
    git:
      url: https://github.com/yhan-sun/Veyra-UI.git
      path: packages/soflume_ui
```

### 2. Wrap with `SoflumeApp`

`SoflumeApp` automatically sets up the root `Navigator`, `Overlay` queue, theme inheritance, keyboard shortcuts, and typography:

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
    return SoflumeApp(
      title: 'My Soflume App',
      theme: SoflumeThemeData.light(),
      home: const HomeScreen(),
    );
  }
}
```

---

## 🧩 Components Overview

| Category | Components | Description |
|---|---|---|
| **Inputs & Controls** | `SofButton`, `SofIconButton`, `SofTextField`, `SofSelect`, `SofToggle`, `SofCheckbox`, `SofRadio`, `SofSegmentedControl`, `SofSlider` | Form inputs with squircle borders, focus rings, and spring transitions. |
| **Containers & Cards** | `SofCard`, `SofListTile`, `SofSurface` | Multi-tier translucent surfaces (`canvas`, `surface`, `floating`, `frost`). |
| **Feedback & Badges** | `SofBadge`, `SofChip`, `SofProgress`, `SofSkeleton`, `SofAlert` | Non-blocking micro-feedback, shimmer skeletons, and semantic badges. |
| **Navigation** | `SofTabs`, `SofBreadcrumb`, `SofFloatingNavigation` | Responsive navigation with sliding selection pills. |
| **Overlays & Modals** | `showSofDialog`, `showSofSheet`, `showSofToast`, `SofPopover` | Modals with keyboard ESC dismiss, barrier accessibility, and queueing. |
| **Signature Items** | `SofMorphingButton`, `SofLiveCapsule`, `SofAdaptiveTile`, `SofFluidSheet` | Dynamic status capsules, multi-state morphing, and draggable sheets. |

---

## 💡 Quick Code Examples

### Button & Micro-Interactions
```dart
SofButton(
  variant: SofButtonVariant.filled,
  leading: const SofIcon(SofIcons.zap, size: 16),
  onPressed: () => print('Activated'),
  child: const Text('Get Started'),
)
```

### Dropdown Select
```dart
SofSelect<String>(
  label: 'Engine Architecture',
  value: selectedValue,
  items: const [
    SofSelectItem(value: 'flutter', label: 'Flutter Impeller', icon: SofIcon(SofIcons.zap, size: 16)),
    SofSelectItem(value: 'native', label: 'Platform Native', icon: SofIcon(SofIcons.cpu, size: 16)),
  ],
  onChanged: (val) => setState(() => selectedValue = val),
)
```

### Contextual Popover
```dart
SofPopover(
  placement: SofPopoverPlacement.bottom,
  content: const Text('Contextual action details'),
  child: SofButton(
    variant: SofButtonVariant.subtle,
    child: const Text('Open Options'),
  ),
)
```

### Modal Dialog
```dart
showSofDialog(
  context: context,
  builder: (ctx) => SofDialog(
    title: const Text('Confirm Action'),
    actions: [
      SofButton(variant: SofButtonVariant.ghost, onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      SofButton(variant: SofButtonVariant.filled, onPressed: () => Navigator.pop(ctx), child: const Text('Confirm')),
    ],
    child: const Text('This action will synchronize changes across all devices.'),
  ),
);
```

---

## 🎨 Theme & Token Customization

```dart
// Custom Accent Theme
final customTheme = SoflumeThemeData.light(
  customAccent: const Color(0xFF10B981), // Emerald
  density: SoflumeDensity.comfortable,
);

// Toggle Dark Mode
final darkTheme = SoflumeThemeData.dark();
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
