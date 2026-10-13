import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/motion/spring_curve.dart';

/// Flagship slider component with elastic thumb and luminous lumen glow.
class SofSlider extends StatefulWidget {
  const SofSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.luminous = false,
    this.enabled = true,
    this.trackHeight = 6.0,
    this.thumbRadius = 10.0,
  }) : assert(min <= max && value >= min && value <= max);

  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final bool luminous;
  final bool enabled;
  final double trackHeight;
  final double thumbRadius;

  @override
  State<SofSlider> createState() => _SofSliderState();
}

class _SofSliderState extends State<SofSlider> with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _thumbScale;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _thumbScale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const SofSpringCurve.snappy(),
        reverseCurve: const SofSpringCurve.settle(),
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details, BoxConstraints constraints) {
    if (!widget.enabled || widget.onChanged == null) return;
    _scaleController.forward();
    widget.onChangeStart?.call(widget.value);
    _updateValueFromPosition(details.localPosition.dx, constraints.maxWidth);
  }

  void _handleDragUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (!widget.enabled || widget.onChanged == null) return;
    _updateValueFromPosition(details.localPosition.dx, constraints.maxWidth);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enabled || widget.onChanged == null) return;
    _scaleController.reverse();
    widget.onChangeEnd?.call(widget.value);
  }

  void _updateValueFromPosition(double localX, double totalWidth) {
    final range = widget.max - widget.min;
    if (range <= 0 || totalWidth <= 0) return;

    final progress = (localX / totalWidth).clamp(0.0, 1.0);
    double newValue = widget.min + (progress * range);

    if (widget.divisions != null && widget.divisions! > 0) {
      final step = range / widget.divisions!;
      newValue = (newValue / step).round() * step;
      newValue = newValue.clamp(widget.min, widget.max);
    }

    if (newValue != widget.value) {
      HapticFeedback.selectionClick();
      widget.onChanged!(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final isInteractive = widget.enabled && widget.onChanged != null;

    final progress = ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (d) => _handleDragStart(d, constraints),
          onHorizontalDragUpdate: (d) => _handleDragUpdate(d, constraints),
          onHorizontalDragEnd: _handleDragEnd,
          onTapDown: (d) {
            if (isInteractive) {
              _handleDragStart(DragStartDetails(localPosition: d.localPosition), constraints);
              _handleDragEnd(DragEndDetails());
            }
          },
          child: Container(
            height: widget.thumbRadius * 3,
            alignment: Alignment.center,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                // Inactive Track
                Container(
                  width: width,
                  height: widget.trackHeight,
                  decoration: BoxDecoration(
                    color: colors.isDark ? colors.surfaceMuted : colors.surfaceMuted,
                    borderRadius: BorderRadius.circular(widget.trackHeight / 2),
                  ),
                ),

                // Active Track
                Container(
                  width: width * progress,
                  height: widget.trackHeight,
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(widget.trackHeight / 2),
                    boxShadow: widget.luminous
                        ? [
                            BoxShadow(
                              color: colors.accent.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),

                // Thumb with spring scale animation
                Positioned(
                  left: (width * progress) - widget.thumbRadius,
                  child: ScaleTransition(
                    scale: _thumbScale,
                    child: Container(
                      width: widget.thumbRadius * 2,
                      height: widget.thumbRadius * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFFFFF),
                        border: Border.all(
                          color: colors.accent,
                          width: 2.0,
                        ),
                        boxShadow: [
                          const BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                          if (widget.luminous)
                            BoxShadow(
                              color: colors.accent.withValues(alpha: 0.6),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
