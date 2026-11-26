import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../foundation/theme/theme.dart';
import '../foundation/motion/spring_curve.dart';

/// Interaction state snapshot passed to [SofPressableBuilder].
class SofPressableState {
  const SofPressableState({
    required this.isHovered,
    required this.isPressed,
    required this.isFocused,
    required this.isEnabled,
  });

  final bool isHovered;
  final bool isPressed;
  final bool isFocused;
  final bool isEnabled;
}

typedef SofPressableBuilder = Widget Function(
  BuildContext context,
  SofPressableState state,
);

/// A responsive, tactile interactive primitive with spring press dynamics.
///
/// Handles touch, mouse, keyboard navigation, and accessibility semantics.
class SofPressable extends StatefulWidget {
  const SofPressable({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.builder,
    this.child,
    this.enabled = true,
    this.dimWhenDisabled = true,
    this.pressScale = 0.975,
    this.enableHaptic = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
  }) : assert(builder != null || child != null, 'Either child or builder must be provided');

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final SofPressableBuilder? builder;
  final Widget? child;
  final bool enabled;

  /// Whether to apply disabled opacity when [enabled] is false or [onPressed] is null.
  final bool dimWhenDisabled;

  final double pressScale;
  final bool enableHaptic;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  @override
  State<SofPressable> createState() => _SofPressableState();
}

class _SofPressableState extends State<SofPressable> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late CurvedAnimation _curvedAnimation;
  late Animation<double> _scaleAnimation;
  late FocusNode _focusNode;

  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  bool get _isInteractive => widget.enabled && widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: const SofSpringCurve.snappy(),
      reverseCurve: const SofSpringCurve.settle(),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(_curvedAnimation);

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _isFocused = _focusNode.hasFocus;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final motion = SoflumeTheme.of(context).motion;
    _controller.duration = motion.getEffectiveDuration(motion.durationInstant);
    _curvedAnimation.curve = motion.getEffectiveCurve(motion.springSnappy);
    _curvedAnimation.reverseCurve = motion.getEffectiveCurve(motion.springSettle);
  }

  @override
  void didUpdateWidget(SofPressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pressScale != oldWidget.pressScale) {
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: widget.pressScale,
      ).animate(_curvedAnimation);
    }
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
    if (!_isInteractive && _isPressed) {
      _isPressed = false;
      _controller.reverse();
    }
  }

  void _handleFocusChange() {
    if (!mounted) return;
    final hasFocus = _focusNode.hasFocus;
    if (widget.builder != null) {
      setState(() => _isFocused = hasFocus);
    } else {
      _isFocused = hasFocus;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isInteractive) return;
    if (widget.builder != null) {
      setState(() => _isPressed = true);
    } else {
      _isPressed = true;
    }
    _controller.forward();
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      if (widget.builder != null) {
        setState(() => _isPressed = false);
      } else {
        _isPressed = false;
      }
    }
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (_isPressed) {
      if (widget.builder != null) {
        setState(() => _isPressed = false);
      } else {
        _isPressed = false;
      }
    }
    _controller.reverse();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _curvedAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final isInteractive = _isInteractive;

    final pressableState = SofPressableState(
      isHovered: _isHovered,
      isPressed: _isPressed,
      isFocused: _isFocused,
      isEnabled: isInteractive,
    );

    Widget content = widget.builder != null
        ? widget.builder!(context, pressableState)
        : widget.child!;

    if (!isInteractive && widget.dimWhenDisabled) {
      content = Opacity(
        opacity: 0.45,
        child: content,
      );
    }

    // Apply scale transition
    if (!theme.motion.reduceMotion && widget.pressScale != 1.0) {
      content = ScaleTransition(
        scale: _scaleAnimation,
        child: content,
      );
    }

    return Semantics(
      button: true,
      enabled: isInteractive,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        enabled: isInteractive,
        mouseCursor: isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onShowHoverHighlight: (hovering) {
          if (!mounted || widget.builder == null) {
            _isHovered = hovering;
            return;
          }
          setState(() => _isHovered = hovering);
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              if (isInteractive) {
                if (widget.enableHaptic) {
                  HapticFeedback.lightImpact();
                }
                if (!theme.motion.reduceMotion && widget.pressScale != 1.0) {
                  _controller.forward().then((_) {
                    if (mounted) _controller.reverse();
                  });
                }
                widget.onPressed?.call();
              }
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: isInteractive ? widget.onPressed : null,
          onLongPress: isInteractive ? widget.onLongPress : null,
          child: content,
        ),
      ),
    );
  }
}
