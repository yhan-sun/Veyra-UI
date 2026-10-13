import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';
import '../../primitives/pressable.dart';
import '../../primitives/focus_ring.dart';
import 'button.dart';

/// Shape of the icon button.
enum SofIconButtonShape {
  /// Continuous curvature squircle.
  squircle,

  /// Pure circle.
  circle,
}

/// A compact, tactile icon button in the Soft Lumen style.
class SofIconButton extends StatelessWidget {
  const SofIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.variant = SofButtonVariant.ghost,
    this.size = SofButtonSize.medium,
    this.shape = SofIconButtonShape.squircle,
    this.enabled = true,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final SofButtonVariant variant;
  final SofButtonSize size;
  final SofIconButtonShape shape;
  final bool enabled;
  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final radii = theme.radii;
    final density = theme.density;

    final dimension = (size == SofButtonSize.small
            ? 34.0
            : size == SofButtonSize.large
                ? 48.0
                : 40.0) *
        density.verticalFactor;

    final isInteractive = enabled && onPressed != null;

    final effectiveRadius = shape == SofIconButtonShape.circle
        ? radii.brPill
        : (size == SofButtonSize.small ? radii.brSm : radii.brMd);

    return SofPressable(
      onPressed: isInteractive ? onPressed : null,
      enabled: isInteractive,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: tooltip,
      pressScale: 0.94,
      builder: (context, state) {
        Color bgColor;
        Color iconColor;
        BorderSide borderSide = BorderSide.none;

        switch (variant) {
          case SofButtonVariant.filled:
            bgColor = state.isHovered
                ? Color.lerp(colors.accent, colors.contentPrimary, 0.08)!
                : colors.accent;
            iconColor = colors.onAccent;
            break;

          case SofButtonVariant.subtle:
            bgColor = state.isHovered
                ? colors.accent.withValues(alpha: 0.22)
                : colors.accentSubtle;
            iconColor = colors.accent;
            break;

          case SofButtonVariant.outlined:
            bgColor = state.isHovered
                ? colors.surfaceMuted
                : const Color(0x00000000);
            iconColor = colors.contentPrimary;
            borderSide = BorderSide(
              color: state.isHovered ? colors.accent : colors.outlineSubtle,
              width: 1.2,
            );
            break;

          case SofButtonVariant.ghost:
            bgColor = state.isHovered
                ? colors.surfaceMuted
                : const Color(0x00000000);
            iconColor = colors.contentPrimary;
            break;

          case SofButtonVariant.danger:
            bgColor = state.isHovered
                ? Color.lerp(colors.danger, const Color(0xFF000000), 0.12)!
                : colors.danger;
            iconColor = const Color(0xFFFFFFFF);
            break;
        }

        final container = AnimatedContainer(
          duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
          width: dimension,
          height: dimension,
          decoration: ShapeDecoration(
            color: bgColor,
            shape: SofSquircleBorder(
              borderRadius: effectiveRadius,
              side: borderSide,
            ),
          ),
          alignment: Alignment.center,
          child: IconTheme(
            data: IconThemeData(
              color: iconColor,
              size: size.iconSize,
            ),
            child: icon,
          ),
        );

        return SofFocusRing(
          focused: state.isFocused,
          borderRadius: effectiveRadius,
          child: container,
        );
      },
    );
  }
}
