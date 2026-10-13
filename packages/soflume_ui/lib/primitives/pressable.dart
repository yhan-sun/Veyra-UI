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
  late final Animation<double> _scaleAnimation;
  late FocusNode _focusNode;

  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const SofSpringCurve.snappy(),
        reverseCurve: const SofSpringCurve.settle(),
      ),
    );

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(SofPressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pressScale != oldWidget.pressScale) {
      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: widget.pressScale,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const SofSpringCurve.snappy(),
          reverseCurve: const SofSpringCurve.settle(),
        ),
      );
    }
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled || widget.onPressed == null) return;
    setState(() => _isPressed = true);
    _controller.forward();
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (!widget.enabled) return;
    setState(() => _isPressed = false);
    _controller.reverse();
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
    final isInteractive = widget.enabled && widget.onPressed != null;

    final pressableState = SofPressableState(
      isHovered: _isHovered,
      isPressed: _isPressed,
      isFocused: _isFocused,
      isEnabled: isInteractive,
    );

    Widget content = widget.builder != null
        ? widget.builder!(context, pressableState)
        : widget.child!;

    if (!isInteractive) {
      content = Opacity(
        opacity: 0.45,
        child: content,
      );
    }

    // Apply scale transition
    if (theme.motion.reduceMotion || widget.pressScale == 1.0) {
      // Skip scale animation in reduce motion
    } else {
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
          if (mounted) {
            setState(() => _isHovered = hovering);
          }
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              if (isInteractive) {
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
