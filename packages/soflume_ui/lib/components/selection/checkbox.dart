import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';
import '../../foundation/motion/spring_curve.dart';
import '../../primitives/focus_ring.dart';

/// Soft Lumen styled checkbox with squircle geometry and smooth animated checkmark.
class SofCheckbox extends StatefulWidget {
  const SofCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
    this.size = 20.0,
    this.focusNode,
    this.autofocus = false,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final Widget? label;
  final bool enabled;
  final double size;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<SofCheckbox> createState() => _SofCheckboxState();
}

class _SofCheckboxState extends State<SofCheckbox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _checkProgress;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      value: (widget.value ?? false) ? 1.0 : 0.0,
    );

    _checkProgress = CurvedAnimation(
      parent: _controller,
      curve: const SofSpringCurve.snappy(),
      reverseCurve: const SofSpringCurve.settle(),
    );

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(SofCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value == true) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  void _handleToggle() {
    if (!widget.enabled || widget.onChanged == null) return;
    HapticFeedback.selectionClick();
    if (widget.value == null) {
      widget.onChanged!(true);
    } else {
      widget.onChanged!(!widget.value!);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final isInteractive = widget.enabled && widget.onChanged != null;
    final isChecked = widget.value == true;
    final isIndeterminate = widget.value == null;

    final box = AnimatedBuilder(
      animation: _checkProgress,
      builder: (context, _) {
        final t = _checkProgress.value;
        final active = isChecked || isIndeterminate;

        final bgColor = active
            ? colors.accent
            : (colors.isDark ? colors.surfaceMuted : colors.surface);

        final borderColor = active ? colors.accent : colors.outlineSubtle;

        return Container(
          width: widget.size,
          height: widget.size,
          decoration: ShapeDecoration(
            color: bgColor,
            shape: SofSquircleBorder(
              borderRadius: BorderRadius.circular(widget.size * 0.32),
              side: BorderSide(
                color: borderColor,
                width: 1.5,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: CustomPaint(
            size: Size(widget.size * 0.7, widget.size * 0.7),
            painter: _CheckmarkPainter(
              progress: isIndeterminate ? 1.0 : t,
              isIndeterminate: isIndeterminate,
              color: colors.onAccent,
            ),
          ),
        );
      },
    );

    final interactiveBox = SofFocusRing(
      focused: _isFocused,
      borderRadius: BorderRadius.circular(widget.size * 0.35),
      child: box,
    );

    Widget content = interactiveBox;

    if (widget.label != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          interactiveBox,
          const SizedBox(width: 10),
          DefaultTextStyle.merge(
            style: theme.typography.body.copyWith(
              color: isInteractive ? colors.contentPrimary : colors.contentSecondary,
            ),
            child: widget.label!,
          ),
        ],
      );
    }

    return Semantics(
      checked: isChecked,
      enabled: isInteractive,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        enabled: isInteractive,
        mouseCursor: isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              if (isInteractive) _handleToggle();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isInteractive ? _handleToggle : null,
          child: Opacity(
            opacity: isInteractive ? 1.0 : 0.45,
            child: content,
          ),
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  _CheckmarkPainter({
    required this.progress,
    required this.isIndeterminate,
    required this.color,
  });

  final double progress;
  final bool isIndeterminate;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.05) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (isIndeterminate) {
      final y = size.height / 2;
      canvas.drawLine(
        Offset(size.width * 0.2, y),
        Offset(size.width * 0.8, y),
        paint,
      );
      return;
    }

    final path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.52);
    path.lineTo(size.width * 0.42, size.height * 0.8);
    path.lineTo(size.width * 0.88, size.height * 0.25);

    // Animate checkmark draw
    final pathMetrics = path.computeMetrics().first;
    final extract = pathMetrics.extractPath(0.0, pathMetrics.length * progress);
    canvas.drawPath(extract, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.isIndeterminate != isIndeterminate ||
      oldDelegate.color != color;
}
