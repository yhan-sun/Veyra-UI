import 'package:flutter/widgets.dart';
import '../foundation/theme/theme.dart';
import '../foundation/shapes/squircle_border.dart';
import '../foundation/icons/icon.dart';
import '../foundation/icons/soflume_icons.dart';
import '../primitives/pressable.dart';
import '../primitives/focus_ring.dart';
import '../src/spinner.dart';

/// State machine phases for [SofMorphingButton].
enum SofMorphingState {
  idle,
  loading,
  success,
  error,
}

/// Brand Signature: A button that morphs seamlessly into a loading pill,
/// checkmark, or error badge with spring physics and zero visual jumps.
class SofMorphingButton extends StatelessWidget {
  const SofMorphingButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.state = SofMorphingState.idle,
    this.enabled = true,
    this.height = 46.0,
    this.width,
    this.borderRadius,
    this.focusNode,
    this.autofocus = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final SofMorphingState state;
  final bool enabled;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    final isIdle = state == SofMorphingState.idle;
    final isInteractive = enabled && isIdle && onPressed != null;

    final targetWidth = isIdle ? (width ?? 160.0) : height;
    final effectiveRadius = isIdle
        ? (borderRadius ?? radii.brMd)
        : BorderRadius.circular(height / 2);

    Color bgColor;
    Widget innerContent;

    switch (state) {
      case SofMorphingState.idle:
        bgColor = colors.accent;
        innerContent = DefaultTextStyle.merge(
          key: const ValueKey(SofMorphingState.idle),
          style: typography.body.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onAccent,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: child,
          ),
        );
        break;

      case SofMorphingState.loading:
        bgColor = colors.accent;
        innerContent = SofSpinner(
          key: const ValueKey(SofMorphingState.loading),
          color: colors.onAccent,
          size: 20,
          strokeWidth: 2.5,
        );
        break;

      case SofMorphingState.success:
        bgColor = colors.success;
        innerContent = SofIcon(
          key: const ValueKey(SofMorphingState.success),
          SofIcons.check,
          size: 20,
          color: colors.onSuccess,
        );
        break;

      case SofMorphingState.error:
        bgColor = colors.danger;
        innerContent = SofIcon(
          key: const ValueKey(SofMorphingState.error),
          SofIcons.x,
          size: 18,
          color: colors.onDanger,
        );
        break;
    }

    return SofPressable(
      onPressed: isInteractive ? onPressed : null,
      enabled: isInteractive,
      dimWhenDisabled: !enabled || (isIdle && onPressed == null),
      focusNode: focusNode,
      autofocus: autofocus,
      pressScale: 0.96,
      builder: (context, pressState) {
        return SofFocusRing(
          focused: pressState.isFocused,
          borderRadius: effectiveRadius,
          child: AnimatedContainer(
            duration: theme.motion.getEffectiveDuration(theme.motion.durationQuick),
            curve: theme.motion.getEffectiveCurve(theme.motion.springSnappy),
            width: targetWidth,
            height: height,
            padding: isIdle ? const EdgeInsets.symmetric(horizontal: 14) : EdgeInsets.zero,
            decoration: ShapeDecoration(
              color: pressState.isHovered && isInteractive
                  ? Color.lerp(bgColor, colors.contentPrimary, 0.08)!
                  : bgColor,
              shape: SofSquircleBorder(
                borderRadius: effectiveRadius,
              ),
              shadows: [
                BoxShadow(
                  color: bgColor.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
              child: innerContent,
            ),
          ),
        );
      },
    );
  }
}
