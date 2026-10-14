# Changelog

All notable changes to the `soflume_ui` package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-10-14

### Added
- **Design Tokens**:
  - `SoflumeColors`: Light and dark palette with semantic color roles, luminous accents, and real WCAG 2.1 relative luminance contrast calculation (`contrastRatio`, `computeContrastColor`).
  - `SoflumeRadii`: Continuous curvature radius scale (`sm`, `md`, `lg`, `xl`, `xxl`, `full`).
  - `SoflumeSpacing`: Standard 4pt/8pt optical spacing system.
  - `SoflumeTypography`: Harmonized optical hierarchy using system fonts with relative scaling.
  - `SoflumeMotion`: Natural spring physics parameters (`springGentle`, `springBouncy`, `springSettle`) and duration scales.
  - `SoflumeDensity`: Responsive layout density presets (`compact`, `comfortable`, `spacious`).
  - `SoflumeBreakpoints`: Screen breakpoint adaptive utilities.
- **Shapes & Vector Icons**:
  - `SofSquircleBorder`: True superellipse outer curvature border with configurable smoothness ($n \approx 4.0$).
  - `SofIcon` & `SofIcons`: Comprehensive 24x24 SVG vector icon system with strict zero-emoji policy.
- **Primitives**:
  - `SofSurface`: Translucent frosted glass and solid surface containers with multi-layer blur.
  - `SofPressable`: Haptic and spring scale-down micro-interaction primitive.
  - `SofFocusRing`: Accessible WCAG high-visibility focus indicator ring.
- **Input & Controls**:
  - `SofButton` & `SofIconButton`: Filled, Subtle, Outlined, and Ghost variants with loading and disabled states.
  - `SofTextField`: Squircle input field with errorText, helperText, prefix, suffix, and controller safety.
  - `SofSelect`: Dropdown select component with squircle overlay, icon support, and keyboard navigation.
  - `SofToggle`: Realistic spring stretch switch with Luminous glow mode.
  - `SofCheckbox`: Smooth spring checked state with tristate support.
  - `SofRadio`: Radio button control with squircle focus feedback.
  - `SofSegmentedControl`: Sliding pill segmented selector.
  - `SofSlider`: Continuous slider with Luminous gradient track.
- **Containers & Feedback**:
  - `SofCard`: Elevated content card with surface tiers.
  - `SofListTile`: Interactive settings and list item with chevron and trailing widgets.
  - `SofBadge`: Semantic status indicator badges.
  - `SofChip`: Filter and tag chips with selection states.
  - `SofProgress`: Linear and circular progress indicators.
  - `SofSkeleton`: Shimmer placeholder for content loading.
  - `SofAlert`: Semantic contextual alert banner.
- **Navigation**:
  - `SofTabs`: Tab bar with animated sliding indicator.
  - `SofBreadcrumb`: Hierarchical path navigation.
  - `SofFloatingNavigation`: Floating capsule navigation bar.
- **Overlays**:
  - `showSofDialog`: Modal dialog with spring entrance, backdrop blur, ESC key dismiss, and PopScope integration.
  - `showSofSheet`: Bottom sheet with pull-down gesture handle and keyboard dismiss.
  - `showSofToast`: Overlay queueing toast notifications.
  - `SofPopover`: Positioned contextual floating popover with auto-clamping.
- **Display**:
  - `SofAvatar`: Image and fallback text avatar with status indicator.
  - `SofEmptyState`: Polished vector illustration empty state display.
- **Signature Components**:
  - `SofMorphingButton`: Multi-state morphing action button (idle, loading, success, error).
  - `SofLiveCapsule`: Expandable dynamic status capsule.
  - `SofAdaptiveTile`: Metric tile with typography emphasis.
  - `SofFluidSheet`: Gesture-driven, interruptible multi-stage snapping bottom sheet.
