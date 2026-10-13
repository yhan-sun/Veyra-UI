import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';

/// Progress indicator style.
enum SofProgressShape {
  linear,
  circular,
}

/// Linear and circular progress indicators with smooth Soft Lumen styling.
class SofProgress extends StatefulWidget {
  const SofProgress({
    super.key,
    this.value,
    this.shape = SofProgressShape.linear,
    this.luminous = false,
    this.size = 36.0,
    this.trackHeight = 6.0,
    this.color,
  });

  /// The progress value between 0.0 and 1.0. If null, the indicator is indeterminate.
  final double? value;
  final SofProgressShape shape;
  final bool luminous;
  final double size;
  final double trackHeight;
  final Color? color;

  @override
  State<SofProgress> createState() => _SofProgressState();
}

class _SofProgressState extends State<SofProgress> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(SofProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
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
    final activeColor = widget.color ?? colors.accent;
    final trackColor = colors.isDark ? colors.surfaceMuted : colors.surfaceMuted;

    if (widget.shape == SofProgressShape.linear) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          if (widget.value != null) {
            final progress = widget.value!.clamp(0.0, 1.0);
            return Container(
              height: widget.trackHeight,
              width: width,
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: BorderRadius.circular(widget.trackHeight / 2),
              ),
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: theme.motion.getEffectiveDuration(theme.motion.durationQuick),
                width: width * progress,
                height: widget.trackHeight,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(widget.trackHeight / 2),
                  boxShadow: widget.luminous
                      ? [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }

          // Indeterminate linear
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _controller.value;
              final start = (t * 1.5 - 0.5).clamp(0.0, 1.0);
              final end = (t * 1.5).clamp(0.0, 1.0);
              final segWidth = width * (end - start);

              return Container(
                height: widget.trackHeight,
                width: width,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: BorderRadius.circular(widget.trackHeight / 2),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: width * start,
                      width: segWidth,
                      height: widget.trackHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: activeColor,
                          borderRadius: BorderRadius.circular(widget.trackHeight / 2),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    // Circular progress
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _CircularProgressPainter(
              value: widget.value,
              rotation: _controller.value,
              color: activeColor,
              trackColor: trackColor,
              strokeWidth: widget.trackHeight,
              luminous: widget.luminous,
            ),
          );
        },
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.value,
    required this.rotation,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.luminous,
  });

  final double? value;
  final double rotation;
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final bool luminous;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Active
    final activePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (value != null) {
      final sweepAngle = (value!.clamp(0.0, 1.0)) * 6.2831853;
      canvas.drawArc(rect, -1.5707963, sweepAngle, false, activePaint);
    } else {
      final startAngle = rotation * 6.2831853 - 1.5707963;
      canvas.drawArc(rect, startAngle, 2.0, false, activePaint);
    }
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) => true;
}
