import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/motion/spring_curve.dart';
import '../../foundation/theme/theme.dart';
import '../../primitives/focus_ring.dart';

/// Flagship slider component with elastic thumb, keyboard support, and luminous glow.
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
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
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
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  @override
  State<SofSlider> createState() => _SofSliderState();
}

class _SofSliderState extends State<SofSlider> with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late CurvedAnimation _curvedAnimation;
  late final Animation<double> _thumbScale;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isDragging = false;

  bool get _isInteractive => widget.enabled && widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _curvedAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: const SofSpringCurve.snappy(),
      reverseCurve: const SofSpringCurve.settle(),
    );
    _thumbScale = Tween<double>(begin: 1.0, end: 1.25).animate(_curvedAnimation);

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _isFocused = _focusNode.hasFocus;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final motion = SoflumeTheme.of(context).motion;
    _scaleController.duration = motion.getEffectiveDuration(motion.durationInstant);
    _curvedAnimation.curve = motion.getEffectiveCurve(motion.springSnappy);
    _curvedAnimation.reverseCurve = motion.getEffectiveCurve(motion.springSettle);
  }

  @override
  void didUpdateWidget(SofSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      if (oldWidget.focusNode == null) {
        _focusNode.removeListener(_handleFocusChange);
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChange);
      _isFocused = _focusNode.hasFocus;
    }
    if (!_isInteractive && _isDragging) {
      _isDragging = false;
      _scaleController.reverse();
    }
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _curvedAnimation.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details, double trackWidth) {
    if (!_isInteractive) return;
    _isDragging = true;
    _scaleController.forward();
    widget.onChangeStart?.call(widget.value);
    _updateValueFromPosition(details.localPosition.dx, trackWidth);
  }

  void _handleDragUpdate(DragUpdateDetails details, double trackWidth) {
    if (!_isInteractive) return;
    _updateValueFromPosition(details.localPosition.dx, trackWidth);
  }

  void _handleDragEnd() {
    if (!_isDragging) return;
    _isDragging = false;
    _scaleController.reverse();
    if (_isInteractive) {
      widget.onChangeEnd?.call(widget.value);
    }
  }

  void _updateValueFromPosition(double localX, double totalWidth) {
    final range = widget.max - widget.min;
    final usableWidth = math.max(1.0, totalWidth - widget.thumbRadius * 2);
    if (range <= 0) return;

    final progress = ((localX - widget.thumbRadius) / usableWidth).clamp(0.0, 1.0);
    double newValue = widget.min + (progress * range);

    if (widget.divisions != null && widget.divisions! > 0) {
      final step = range / widget.divisions!;
      newValue = widget.min + ((newValue - widget.min) / step).round() * step;
      newValue = newValue.clamp(widget.min, widget.max);
    }

    if (newValue != widget.value) {
      HapticFeedback.selectionClick();
      widget.onChanged!(newValue);
    }
  }

  void _stepBy(int direction) {
    if (!_isInteractive) return;
    final range = widget.max - widget.min;
    if (range <= 0) return;

    final step = (widget.divisions != null && widget.divisions! > 0)
        ? range / widget.divisions!
        : range * 0.05;
    final next = (widget.value + direction * step).clamp(widget.min, widget.max);
    if (next != widget.value) {
      HapticFeedback.selectionClick();
      widget.onChanged!(next);
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!_isInteractive) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowRight || key == LogicalKeyboardKey.arrowUp) {
      _stepBy(1);
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowLeft || key == LogicalKeyboardKey.arrowDown) {
      _stepBy(-1);
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.home) {
      widget.onChanged!(widget.min);
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.end) {
      widget.onChanged!(widget.max);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final isInteractive = _isInteractive;

    final range = widget.max - widget.min;
    final progress = range <= 0 ? 0.0 : ((widget.value - widget.min) / range).clamp(0.0, 1.0);

    return Semantics(
      slider: true,
      enabled: isInteractive,
      label: widget.semanticLabel,
      value: '${(progress * 100).round()}%',
      increasedValue: '${((progress + 0.05).clamp(0.0, 1.0) * 100).round()}%',
      decreasedValue: '${((progress - 0.05).clamp(0.0, 1.0) * 100).round()}%',
      onIncrease: isInteractive ? () => _stepBy(1) : null,
      onDecrease: isInteractive ? () => _stepBy(-1) : null,
      child: Focus(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        canRequestFocus: isInteractive,
        onKeyEvent: _handleKeyEvent,
        child: MouseRegion(
          cursor: isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: Opacity(
            opacity: isInteractive ? 1.0 : 0.45,
            child: SofFocusRing(
              focused: _isFocused && isInteractive,
              borderRadius: BorderRadius.circular(widget.thumbRadius * 1.5),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth.isFinite ? constraints.maxWidth : 240.0;
                  final usableWidth = math.max(0.0, width - widget.thumbRadius * 2);
                  final thumbCenterX = widget.thumbRadius + (usableWidth * progress);

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: (d) => _handleDragStart(d, width),
                    onHorizontalDragUpdate: (d) => _handleDragUpdate(d, width),
                    onHorizontalDragEnd: (_) => _handleDragEnd(),
                    onHorizontalDragCancel: _handleDragEnd,
                    onTapDown: (d) {
                      if (isInteractive) {
                        _focusNode.requestFocus();
                        _handleDragStart(
                          DragStartDetails(localPosition: d.localPosition),
                          width,
                        );
                        _handleDragEnd();
                      }
                    },
                    child: SizedBox(
                      width: width,
                      height: widget.thumbRadius * 3,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.centerLeft,
                        children: [
                          // Inactive Track inset by thumbRadius so thumb never overflows edges
                          Positioned(
                            left: widget.thumbRadius,
                            right: widget.thumbRadius,
                            child: Container(
                              height: widget.trackHeight,
                              decoration: BoxDecoration(
                                color: colors.surfaceMuted,
                                borderRadius: BorderRadius.circular(widget.trackHeight / 2),
                              ),
                            ),
                          ),

                          // Active Track
                          Positioned(
                            left: widget.thumbRadius,
                            width: usableWidth * progress,
                            child: Container(
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
                          ),

                          // Thumb with spring scale animation
                          Positioned(
                            left: thumbCenterX - widget.thumbRadius,
                            child: ScaleTransition(
                              scale: theme.motion.reduceMotion
                                  ? const AlwaysStoppedAnimation(1.0)
                                  : _thumbScale,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
