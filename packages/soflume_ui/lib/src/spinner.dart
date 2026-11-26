import 'package:flutter/widgets.dart';
import '../foundation/theme/theme.dart';

/// Shared circular loading spinner used across button components.
class SofSpinner extends StatefulWidget {
  const SofSpinner({
    super.key,
    required this.color,
    this.size = 18.0,
    this.strokeWidth,
  });

  final Color color;
  final double size;
  final double? strokeWidth;

  @override
  State<SofSpinner> createState() => _SofSpinnerState();
}

class _SofSpinnerState extends State<SofSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = SoflumeTheme.of(context).motion.reduceMotion;
    if (reduceMotion) {
      if (_controller.isAnimating) {
        _controller.stop();
      }
      _controller.value = 0.25;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: RotationTransition(
        turns: _controller,
        child: CustomPaint(
          painter: _SofSpinnerPainter(
            color: widget.color,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _SofSpinnerPainter extends CustomPainter {
  _SofSpinnerPainter({
    required this.color,
    this.strokeWidth,
  });

  final Color color;
  final double? strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final effectiveStroke = strokeWidth ?? (size.width * 0.14).clamp(1.8, 3.0);
    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = effectiveStroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - effectiveStroke) / 2;

    canvas.drawCircle(center, radius, trackPaint);

    final activePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = effectiveStroke
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
  bool shouldRepaint(_SofSpinnerPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
