import 'package:flutter/widgets.dart';
import '../components/button/button.dart';
import '../foundation/tokens/colors.dart';

/// Resolved foreground, background, and border styling for button variants.
class SofButtonPalette {
  const SofButtonPalette({
    required this.background,
    required this.foreground,
    required this.borderSide,
  });

  final Color background;
  final Color foreground;
  final BorderSide borderSide;

  static SofButtonPalette resolve({
    required SofButtonVariant variant,
    required SoflumeColors colors,
    required bool isHovered,
  }) {
    switch (variant) {
      case SofButtonVariant.filled:
        return SofButtonPalette(
          background: isHovered
              ? Color.lerp(colors.accent, colors.contentPrimary, 0.08)!
              : colors.accent,
          foreground: colors.onAccent,
          borderSide: BorderSide.none,
        );

      case SofButtonVariant.subtle:
        return SofButtonPalette(
          background: isHovered
              ? colors.accent.withValues(alpha: 0.22)
              : colors.accentSubtle,
          foreground: colors.onAccentSubtle,
          borderSide: BorderSide.none,
        );

      case SofButtonVariant.outlined:
        return SofButtonPalette(
          background: isHovered ? colors.surfaceMuted : const Color(0x00000000),
          foreground: colors.contentPrimary,
          borderSide: BorderSide(
            color: isHovered ? colors.accent : colors.outlineSubtle,
            width: 1.2,
          ),
        );

      case SofButtonVariant.ghost:
        return SofButtonPalette(
          background: isHovered ? colors.surfaceMuted : const Color(0x00000000),
          foreground: colors.contentPrimary,
          borderSide: BorderSide.none,
        );

      case SofButtonVariant.danger:
        final bg = isHovered
            ? Color.lerp(colors.danger, const Color(0xFF000000), 0.12)!
            : colors.danger;
        return SofButtonPalette(
          background: bg,
          foreground: SoflumeColors.computeContrastColor(bg),
          borderSide: BorderSide.none,
        );
    }
  }
}
