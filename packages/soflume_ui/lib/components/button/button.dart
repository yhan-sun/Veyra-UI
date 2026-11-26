import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';
import '../../primitives/pressable.dart';
import '../../primitives/focus_ring.dart';
import '../../src/button_style.dart';
import '../../src/spinner.dart';

/// Visual style variant for [SofButton].
enum SofButtonVariant {
  /// Solid brand accent fill with high-contrast text.
  filled,

  /// Soft luminous translucent accent background.
  subtle,

  /// Clean hairline border with transparent background.
  outlined,

  /// Borderless with subtle hover sheen.
  ghost,

  /// High-priority danger/destructive action.
  danger,
}

/// Size classification for [SofButton].
enum SofButtonSize {
  /// Compact size (height ~34dp) for toolbars and compact dialogs.
  small(height: 34, horizontalPadding: 12, iconSize: 16),

  /// Standard balanced size (height ~42dp) for primary forms and actions.
  medium(height: 42, horizontalPadding: 18, iconSize: 18),

  /// Large prominent size (height ~50dp) for landing pages and checkout flows.
  large(height: 50, horizontalPadding: 24, iconSize: 20);

  const SofButtonSize({
    required this.height,
    required this.horizontalPadding,
    required this.iconSize,
  });

  final double height;
  final double horizontalPadding;
  final double iconSize;
}

/// Premium Soft Lumen button with spring touch feedback and continuous curvature.
class SofButton extends StatelessWidget {
  const SofButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = SofButtonVariant.filled,
    this.size = SofButtonSize.medium,
    this.leading,
    this.trailing,
    this.loading = false,
    this.enabled = true,
    this.fullWidth = false,
    this.borderRadius,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final SofButtonVariant variant;
  final SofButtonSize size;
  final Widget? leading;
  final Widget? trailing;
  final bool loading;
  final bool enabled;
  final bool fullWidth;
  final BorderRadius? borderRadius;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final radii = theme.radii;
    final typography = theme.typography;
    final density = theme.density;

    final isInteractive = enabled && !loading && onPressed != null;

    final effectiveRadius = borderRadius ??
        (size == SofButtonSize.small
            ? radii.brSm
            : size == SofButtonSize.large
                ? radii.brLg
                : radii.brMd);

    final effectiveHeight = size.height * density.verticalFactor;
    final effectiveHorizPadding = size.horizontalPadding * density.horizontalFactor;

    return SofPressable(
      onPressed: isInteractive ? onPressed : null,
      enabled: isInteractive,
      dimWhenDisabled: !loading,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      pressScale: 0.97,
      builder: (context, state) {
        final palette = SofButtonPalette.resolve(
          variant: variant,
          colors: colors,
          isHovered: state.isHovered,
        );
        final bgColor = palette.background;
        final textColor = palette.foreground;
        final borderSide = palette.borderSide;

        final textStyle = (size == SofButtonSize.small
                ? typography.label
                : typography.body.copyWith(fontWeight: FontWeight.w600))
            .copyWith(color: textColor);

        Widget buttonContent;
        if (loading) {
          buttonContent = SofSpinner(
            color: textColor,
            size: size.iconSize,
          );
        } else {
          final items = <Widget>[];
          if (leading != null) {
            items.add(IconTheme(
              data: IconThemeData(color: textColor, size: size.iconSize),
              child: leading!,
            ));
            items.add(const SizedBox(width: 8));
          }

          items.add(Flexible(
            child: DefaultTextStyle.merge(
              style: textStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              child: child,
            ),
          ));

          if (trailing != null) {
            items.add(const SizedBox(width: 8));
            items.add(IconTheme(
              data: IconThemeData(color: textColor, size: size.iconSize),
              child: trailing!,
            ));
          }

          buttonContent = Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: items,
          );
        }

        final container = AnimatedContainer(
          duration: theme.motion.getEffectiveDuration(theme.motion.durationInstant),
          curve: Curves.easeOut,
          height: effectiveHeight,
          padding: EdgeInsets.symmetric(horizontal: effectiveHorizPadding),
          decoration: ShapeDecoration(
            color: bgColor,
            shape: SofSquircleBorder(
              borderRadius: effectiveRadius,
              side: borderSide,
            ),
            shadows: isInteractive && variant == SofButtonVariant.filled
                ? [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: colors.isDark ? 0.28 : 0.22),
                      blurRadius: state.isHovered ? 14 : 8,
                      offset: Offset(0, state.isHovered ? 4 : 2),
                    ),
                  ]
                : isInteractive && variant == SofButtonVariant.danger
                    ? [
                        BoxShadow(
                          color: colors.danger.withValues(alpha: colors.isDark ? 0.30 : 0.22),
                          blurRadius: state.isHovered ? 14 : 8,
                          offset: Offset(0, state.isHovered ? 4 : 2),
                        ),
                      ]
                    : null,
          ),
          alignment: Alignment.center,
          child: buttonContent,
        );

        return SofFocusRing(
          focused: state.isFocused,
          borderRadius: effectiveRadius,
          child: fullWidth
              ? SizedBox(width: double.infinity, child: container)
              : container,
        );
      },
    );
  }
}
