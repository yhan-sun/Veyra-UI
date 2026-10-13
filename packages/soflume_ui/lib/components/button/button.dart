import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';
import '../../primitives/pressable.dart';
import '../../primitives/focus_ring.dart';

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
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      pressScale: 0.97,
      builder: (context, state) {
        Color bgColor;
        Color textColor;
        BorderSide borderSide = BorderSide.none;

        switch (variant) {
          case SofButtonVariant.filled:
            bgColor = state.isHovered
                ? Color.lerp(colors.accent, colors.contentPrimary, 0.08)!
                : colors.accent;
            textColor = colors.onAccent;
            break;

          case SofButtonVariant.subtle:
            bgColor = state.isHovered
                ? colors.accent.withValues(alpha: 0.22)
                : colors.accentSubtle;
            textColor = colors.accent;
            break;

          case SofButtonVariant.outlined:
            bgColor = state.isHovered
                ? colors.surfaceMuted
                : const Color(0x00000000);
            textColor = colors.contentPrimary;
            borderSide = BorderSide(
              color: state.isHovered ? colors.accent : colors.outlineSubtle,
              width: 1.2,
            );
            break;

          case SofButtonVariant.ghost:
            bgColor = state.isHovered
                ? colors.surfaceMuted
                : const Color(0x00000000);
            textColor = colors.contentPrimary;
            break;

          case SofButtonVariant.danger:
            bgColor = state.isHovered
                ? Color.lerp(colors.danger, const Color(0xFF000000), 0.12)!
                : colors.danger;
            textColor = const Color(0xFFFFFFFF);
            break;
        }

        final textStyle = (size == SofButtonSize.small
                ? typography.label
                : typography.body.copyWith(fontWeight: FontWeight.w600))
            .copyWith(color: textColor);

        Widget buttonContent;
        if (loading) {
          buttonContent = SizedBox(
            width: size.iconSize,
            height: size.iconSize,
            child: _SofButtonSpinner(color: textColor),
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

          items.add(DefaultTextStyle.merge(
            style: textStyle,
            child: child,
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
          ),
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

class _SofButtonSpinner extends StatefulWidget {
  const _SofButtonSpinner({required this.color});

  final Color color;

  @override
  State<_SofButtonSpinner> createState() => _SofButtonSpinnerState();
}

class _SofButtonSpinnerState extends State<_SofButtonSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CustomPaint(
        painter: _SpinnerPainter(widget.color),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.15;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawCircle(center, radius, paint);

    final activePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57,
      2.5,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) => oldDelegate.color != color;
}
