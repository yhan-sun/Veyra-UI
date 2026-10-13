import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';

/// Shimmering placeholder loader for text, cards, and avatars.
class SofSkeleton extends StatefulWidget {
  const SofSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  State<SofSkeleton> createState() => _SofSkeletonState();
}

class _SofSkeletonState extends State<SofSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final radii = theme.radii;

    final effectiveRadius = widget.borderRadius ?? radii.brMd;

    final baseColor = colors.isDark ? const Color(0xFF232735) : const Color(0xFFE8ECF4);
    final highlightColor = colors.isDark ? const Color(0xFF2C3244) : const Color(0xFFF6F8FC);

    if (theme.motion.reduceMotion) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: ShapeDecoration(
          color: baseColor,
          shape: SofSquircleBorder(borderRadius: effectiveRadius),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.5 + (t * 3.0), -0.2),
              end: Alignment(-0.5 + (t * 3.0), 0.2),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
            ),
            shape: SofSquircleBorder(borderRadius: effectiveRadius),
          ),
        );
      },
    );
  }
}
