import 'package:flutter/widgets.dart';
import '../foundation/theme/theme.dart';
import '../foundation/shapes/squircle_border.dart';
import '../foundation/motion/spring_curve.dart';
import '../foundation/icons/icon.dart';
import '../foundation/icons/soflume_icons.dart';
import '../primitives/pressable.dart';

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
    this.height = 46.0,
    this.width,
    this.borderRadius,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final SofMorphingState state;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    final isIdle = state == SofMorphingState.idle;
    final isInteractive = isIdle && onPressed != null;

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
          style: typography.body.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onAccent,
          ),
          child: child,
        );
        break;

      case SofMorphingState.loading:
        bgColor = colors.accent;
        innerContent = SizedBox(
          width: 20,
          height: 20,
          child: _MorphSpinner(color: colors.onAccent),
        );
        break;

      case SofMorphingState.success:
        bgColor = colors.success;
        innerContent = const SofIcon(
          SofIcons.check,
          size: 20,
          color: Color(0xFFFFFFFF),
        );
        break;

      case SofMorphingState.error:
        bgColor = colors.danger;
        innerContent = const SofIcon(
          SofIcons.x,
          size: 18,
          color: Color(0xFFFFFFFF),
        );
        break;
    }

    return SofPressable(
      onPressed: isInteractive ? onPressed : null,
      enabled: isInteractive,
      pressScale: 0.96,
      builder: (context, pressState) {
        return AnimatedContainer(
          duration: theme.motion.getEffectiveDuration(theme.motion.durationQuick),
          curve: const SofSpringCurve.snappy(),
          width: targetWidth,
          height: height,
          decoration: ShapeDecoration(
            color: pressState.isHovered && isIdle
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
        );
      },
    );
  }
}

class _MorphSpinner extends StatefulWidget {
  const _MorphSpinner({required this.color});

  final Color color;

  @override
  State<_MorphSpinner> createState() => _MorphSpinnerState();
}

class _MorphSpinnerState extends State<_MorphSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
        painter: _MorphSpinnerPainter(widget.color),
      ),
    );
  }
}

class _MorphSpinnerPainter extends CustomPainter {
  _MorphSpinnerPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 2.5;
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
      2.8,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(_MorphSpinnerPainter oldDelegate) => false;
}
