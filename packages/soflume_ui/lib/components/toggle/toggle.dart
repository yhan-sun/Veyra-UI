import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/motion/spring_curve.dart';
import '../../primitives/focus_ring.dart';

/// Flagship switch component with physics spring dynamics and squircle pill ergonomics.
class SofToggle extends StatefulWidget {
  const SofToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.luminous = false,
    this.size = 30.0,
    this.focusNode,
    this.autofocus = false,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  /// Whether to render an ambient soft lumen glow around the active thumb.
  final bool luminous;

  /// Height of the toggle switch. Track width is computed proportionally (~1.75x height).
  final double size;

  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<SofToggle> createState() => _SofToggleState();
}

class _SofToggleState extends State<SofToggle> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _thumbPosition;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      value: widget.value ? 1.0 : 0.0,
    );

    _thumbPosition = CurvedAnimation(
      parent: _controller,
      curve: const SofSpringCurve.snappy(),
      reverseCurve: const SofSpringCurve.settle(),
    );

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(SofToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode.removeListener(_handleFocusChange);
        _focusNode.dispose();
      } else {
        oldWidget.focusNode!.removeListener(_handleFocusChange);
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChange);
      _isFocused = _focusNode.hasFocus;
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
    widget.onChanged!(!widget.value);
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

    final height = widget.size;
    final width = height * 1.72;
    const padding = 3.0;
    final thumbSize = height - (padding * 2);
    final maxTravel = width - height;

    return Semantics(
      toggled: widget.value,
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
          onTapDown: (_) => isInteractive ? setState(() => _isPressed = true) : null,
          onTapUp: (_) => isInteractive ? setState(() => _isPressed = false) : null,
          onTapCancel: () => isInteractive ? setState(() => _isPressed = false) : null,
          onTap: isInteractive ? _handleToggle : null,
          child: SofFocusRing(
            focused: _isFocused,
            borderRadius: BorderRadius.circular(height / 2),
            child: AnimatedBuilder(
              animation: _thumbPosition,
              builder: (context, _) {
                final t = _thumbPosition.value;

                final trackColor = Color.lerp(
                  colors.isDark ? colors.surfaceMuted : colors.surfaceMuted,
                  colors.accent,
                  t,
                )!;

                final borderColor = Color.lerp(
                  colors.outlineSubtle,
                  colors.accent.withValues(alpha: 0.2),
                  t,
                )!;

                // Stretch thumb slightly on press for flagship tactile elasticity
                final stretchWidth = _isPressed ? thumbSize * 1.2 : thumbSize;

                return Opacity(
                  opacity: isInteractive ? 1.0 : 0.45,
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: trackColor,
                      borderRadius: BorderRadius.circular(height / 2),
                      border: Border.all(color: borderColor, width: 1.0),
                    ),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Positioned(
                          left: padding + (t * maxTravel) - (_isPressed && t > 0.5 ? (stretchWidth - thumbSize) : 0),
                          child: Container(
                            width: stretchWidth,
                            height: thumbSize,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(thumbSize / 2),
                              boxShadow: [
                                const BoxShadow(
                                  color: Color(0x28000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                                if (widget.luminous && t > 0.05)
                                  BoxShadow(
                                    color: colors.accent.withValues(alpha: 0.45 * t),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                              ],
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
    );
  }
}
