import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../primitives/surface.dart';

/// Placement of the popover relative to its anchor.
enum SofPopoverPlacement {
  top,
  bottom,
  left,
  right,
}

/// A floating contextual popover component with Soft Lumen frosted glass styling,
/// viewport edge auto-clamping, and accessible dismissal.
class SofPopover extends StatefulWidget {
  const SofPopover({
    super.key,
    required this.child,
    required this.content,
    this.placement = SofPopoverPlacement.bottom,
    this.offset = 8.0,
    this.barrierDismissible = true,
    this.borderRadius,
    this.onDismiss,
  });

  /// The anchor trigger widget that activates the popover.
  final Widget child;

  /// The popover content displayed inside the floating surface.
  final Widget content;

  /// Preferred placement relative to the trigger.
  final SofPopoverPlacement placement;

  /// Distance in logical pixels between trigger and popover surface.
  final double offset;

  /// Whether tapping outside the popover dismisses it.
  final bool barrierDismissible;

  /// Custom corner radius for the floating popover surface.
  final BorderRadius? borderRadius;

  /// Callback invoked when popover is dismissed.
  final VoidCallback? onDismiss;

  @override
  State<SofPopover> createState() => SofPopoverState();
}

class SofPopoverState extends State<SofPopover> {
  final GlobalKey _anchorKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void open() {
    if (_isOpen) return;
    final overlay = Overlay.of(context);
    final renderBox = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final anchorRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    final theme = SoflumeTheme.of(context);

    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        return _SofPopoverOverlay(
          anchorRect: anchorRect,
          placement: widget.placement,
          offset: widget.offset,
          barrierDismissible: widget.barrierDismissible,
          borderRadius: widget.borderRadius,
          theme: theme,
          onClose: close,
          content: widget.content,
        );
      },
    );

    overlay.insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void close() {
    if (!_isOpen) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
    if (mounted) {
      setState(() {});
    }
    widget.onDismiss?.call();
  }

  void toggle() {
    if (_isOpen) {
      close();
    } else {
      open();
    }
  }

  @override
  void dispose() {
    if (_isOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isOpen = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _anchorKey,
      behavior: HitTestBehavior.opaque,
      onTap: toggle,
      child: widget.child,
    );
  }
}

class _SofPopoverOverlay extends StatefulWidget {
  const _SofPopoverOverlay({
    required this.anchorRect,
    required this.placement,
    required this.offset,
    required this.barrierDismissible,
    required this.borderRadius,
    required this.theme,
    required this.onClose,
    required this.content,
  });

  final Rect anchorRect;
  final SofPopoverPlacement placement;
  final double offset;
  final bool barrierDismissible;
  final BorderRadius? borderRadius;
  final SoflumeThemeData theme;
  final VoidCallback onClose;
  final Widget content;

  @override
  State<_SofPopoverOverlay> createState() => _SofPopoverOverlayState();
}

class _SofPopoverOverlayState extends State<_SofPopoverOverlay>
    with SingleTickerProviderStateMixin {
  late final FocusNode _focusNode;
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });

    _animController = AnimationController(
      vsync: this,
      duration: widget.theme.motion.getEffectiveDuration(widget.theme.motion.durationQuick),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: widget.theme.motion.springGentle),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeOut);

    _animController.forward();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final radii = widget.theme.radii;
    final effectiveRadius = widget.borderRadius ?? radii.brLg;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          if (widget.barrierDismissible) {
            _handleDismiss();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Stack(
        children: [
          // Dismissible backdrop
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: widget.barrierDismissible ? _handleDismiss : null,
              child: const ColoredBox(color: Color(0x00000000)),
            ),
          ),

              // Positioned popover content
              Positioned(
                left: _computeLeft(screenSize, padding),
                top: _computeTop(screenSize, padding),
                child: SoflumeTheme(
                  data: widget.theme,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: SofSurface(
                        variant: SofSurfaceVariant.floating,
                        borderRadius: effectiveRadius,
                        padding: const EdgeInsets.all(12.0),
                        child: widget.content,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  double _computeLeft(Size screenSize, EdgeInsets padding) {
    final anchor = widget.anchorRect;
    double left;

    switch (widget.placement) {
      case SofPopoverPlacement.top:
      case SofPopoverPlacement.bottom:
        left = anchor.left;
        break;
      case SofPopoverPlacement.left:
        left = anchor.left - widget.offset - 200; // estimated default width
        break;
      case SofPopoverPlacement.right:
        left = anchor.right + widget.offset;
        break;
    }

    // Viewport edge clamping
    final minLeft = padding.left + 12.0;
    final maxLeft = screenSize.width - padding.right - 220.0;
    return left.clamp(minLeft, maxLeft > minLeft ? maxLeft : minLeft);
  }

  double _computeTop(Size screenSize, EdgeInsets padding) {
    final anchor = widget.anchorRect;
    double top;

    switch (widget.placement) {
      case SofPopoverPlacement.bottom:
        top = anchor.bottom + widget.offset;
        break;
      case SofPopoverPlacement.top:
        top = anchor.top - widget.offset - 100; // offset upwards
        break;
      case SofPopoverPlacement.left:
      case SofPopoverPlacement.right:
        top = anchor.top;
        break;
    }

    final minTop = padding.top + 12.0;
    final maxTop = screenSize.height - padding.bottom - 120.0;
    return top.clamp(minTop, maxTop > minTop ? maxTop : minTop);
  }
}
