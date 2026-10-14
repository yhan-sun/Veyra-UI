# Contributing to Soflume UI

Thank you for your interest in contributing to **Soflume UI**!

Soflume UI is an open-source, flagship-grade Flutter design system and component library built with an emphasis on craftsmanship, continuous curvature, smooth spring physics, and accessibility.

## 🛠 Development Workflow

### Prerequisites
- Flutter SDK `>=3.27.0`
- Dart SDK `>=3.6.0 <4.0.0`

### Repository Structure
```
Veyra-UI/
├── packages/
│   └── soflume_ui/         # The core package published to pub.dev
│       ├── lib/
│       │   ├── foundation/ # Design Tokens, Shapes, Motion, Icons, Theme
│       │   ├── primitives/ # Surface, Pressable, FocusRing
│       │   ├── components/ # Production components
│       │   └── signature/  # Signature brand components
│       └── test/           # Unit & Widget test suite
└── example/                # Showcase web & mobile interactive app
```

### Running Tests
Before submitting any code changes, ensure all tests pass:

```bash
cd packages/soflume_ui
flutter test
```

### Static Analysis
Ensure there are zero warnings and zero linter errors:

```bash
flutter analyze
```

---

## 📐 Design Guidelines & Code Rules

1. **Zero Emoji Policy**:
   Emojis are strictly prohibited across all components and showcases. All icons must use SVG vectors via `SofIcon` and `SofIcons`.

2. **Continuous Curvature**:
   Always use `SofSquircleBorder` or `SoflumeRadii` rather than naive circular `BorderRadius` for card and dialog surfaces.

3. **Motion Consistency**:
   Use `SoflumeMotion` spring curves (`springGentle`, `springBouncy`, `springSettle`) and durations rather than hardcoded `Curves.easeIn` or `Duration(seconds: ...)`. Always respect `getEffectiveDuration()` to support system Reduce Motion accessibility settings.

4. **WCAG Accessibility**:
   Ensure all foreground-to-background text pairs have at least a 4.5:1 contrast ratio (AA standard). Use `SoflumeColors.computeContrastColor` or `contrastRatio`.

5. **Keyboard & Overlay Management**:
   Modals and popovers must support `Escape` key dismissal and `PopScope` integration. Do not mutate Navigator state uncontrollably.

---

## 📬 Pull Request Process

1. Create a feature branch from `main`:
   ```bash
   git checkout -b feature/my-new-component
   ```
2. Write clean code with thorough `///` docstrings on all public APIs.
3. Add unit and widget tests in `test/`.
4. Run `flutter analyze` and `flutter test`.
5. Open a Pull Request with a clear description and screenshots/recordings of visual components.
