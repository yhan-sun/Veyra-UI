import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/motion/spring_curve.dart';
import '../../primitives/focus_ring.dart';

/// Soft Lumen radio selector with smooth expanding inner disc.
class SofRadio<T> extends StatefulWidget {
  const SofRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.enabled = true,
    this.size = 20.0,
    this.focusNode,
    this.autofocus = false,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final Widget? label;
  final bool enabled;
  final double size;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<SofRadio<T>> createState() => _SofRadioState<T>();
}

class _SofRadioState<T> extends State<SofRadio<T>> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;

  bool get _isSelected => widget.value == widget.groupValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: _isSelected ? 1.0 : 0.0,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const SofSpringCurve.snappy(),
      reverseCurve: const SofSpringCurve.settle(),
    );

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(SofRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isSelected != (oldWidget.value == oldWidget.groupValue)) {
      if (_isSelected) {
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

  void _handleSelect() {
    if (!widget.enabled || widget.onChanged == null) return;
    HapticFeedback.selectionClick();
    widget.onChanged!(widget.value);
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

    final disc = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, _) {
        final t = _scaleAnimation.value;
        final borderColor = Color.lerp(colors.outlineSubtle, colors.accent, t)!;

        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: 1.6,
            ),
          ),
          alignment: Alignment.center,
          child: Transform.scale(
            scale: t,
            child: Container(
              width: widget.size * 0.52,
              height: widget.size * 0.52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.accent,
              ),
            ),
          ),
        );
      },
    );

    final interactiveDisc = SofFocusRing(
      focused: _isFocused,
      borderRadius: BorderRadius.circular(widget.size / 2),
      child: disc,
    );

    Widget content = interactiveDisc;

    if (widget.label != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          interactiveDisc,
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
      inMutuallyExclusiveGroup: true,
      selected: _isSelected,
      enabled: isInteractive,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        enabled: isInteractive,
        mouseCursor: isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              if (isInteractive) _handleSelect();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isInteractive ? _handleSelect : null,
          child: Opacity(
            opacity: isInteractive ? 1.0 : 0.45,
            child: content,
          ),
        ),
      ),
    );
  }
}
