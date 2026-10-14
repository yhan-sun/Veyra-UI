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
/// real-time scroll following via [LayerLink], intelligent edge flipping,
/// and keyboard focus restoration.
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
    this.focusNode,
  });

  /// The anchor trigger widget that activates the popover.
  final Widget child;

  /// The popover content displayed inside the floating surface.
  final Widget content;

  /// Preferred placement relative to the trigger. Will dynamically flip if space is insufficient.
  final SofPopoverPlacement placement;

  /// Distance in logical pixels between trigger and popover surface.
  final double offset;

  /// Whether tapping outside the popover dismisses it.
  final bool barrierDismissible;

  /// Custom corner radius for the floating popover surface.
  final BorderRadius? borderRadius;

  /// Callback invoked when popover is dismissed.
  final VoidCallback? onDismiss;

  /// Optional focus node for the trigger. If omitted, an internal node is managed.
  final FocusNode? focusNode;

  @override
  State<SofPopover> createState() => SofPopoverState();
}

class SofPopoverState extends State<SofPopover> {
  final GlobalKey _anchorKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  late FocusNode _triggerFocusNode;
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  @override
  void initState() {
    super.initState();
    _triggerFocusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(SofPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) {
        _triggerFocusNode.dispose();
      }
      _triggerFocusNode = widget.focusNode ?? FocusNode();
    }
  }

  void open() {
    if (_isOpen) return;
    final overlay = Overlay.of(context);
    final renderBox = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final anchorRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
    final theme = SoflumeTheme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;
    final padding = mediaQuery.padding;

    // Intelligent edge flipping
    final spaceBelow = screenSize.height - anchorRect.bottom - padding.bottom;
    final spaceAbove = anchorRect.top - padding.top;
    final spaceRight = screenSize.width - anchorRect.right - padding.right;
    final spaceLeft = anchorRect.left - padding.left;

    SofPopoverPlacement resolvedPlacement = widget.placement;
    if (widget.placement == SofPopoverPlacement.bottom && spaceBelow < 160 && spaceAbove > spaceBelow) {
      resolvedPlacement = SofPopoverPlacement.top;
    } else if (widget.placement == SofPopoverPlacement.top && spaceAbove < 160 && spaceBelow > spaceAbove) {
      resolvedPlacement = SofPopoverPlacement.bottom;
    } else if (widget.placement == SofPopoverPlacement.right && spaceRight < 200 && spaceLeft > spaceRight) {
      resolvedPlacement = SofPopoverPlacement.left;
    } else if (widget.placement == SofPopoverPlacement.left && spaceLeft < 200 && spaceRight > spaceLeft) {
      resolvedPlacement = SofPopoverPlacement.right;
    }

    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        return _SofPopoverOverlay(
          layerLink: _layerLink,
          placement: resolvedPlacement,
          offset: widget.offset,
          barrierDismissible: widget.barrierDismissible,
          borderRadius: widget.borderRadius,
          theme: theme,
          onClose: close,
          triggerFocusNode: _triggerFocusNode,
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
      // Restore focus to trigger element for seamless keyboard navigation
      _triggerFocusNode.requestFocus();
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
    if (widget.focusNode == null) {
      _triggerFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        focusNode: _triggerFocusNode,
        child: GestureDetector(
          key: _anchorKey,
          behavior: HitTestBehavior.opaque,
          onTap: toggle,
          child: widget.child,
        ),
      ),
    );
  }
}

class _SofPopoverOverlay extends StatefulWidget {
  const _SofPopoverOverlay({
    required this.layerLink,
    required this.placement,
    required this.offset,
    required this.barrierDismissible,
    required this.borderRadius,
    required this.theme,
    required this.onClose,
    required this.triggerFocusNode,
    required this.content,
  });

  final LayerLink layerLink;
  final SofPopoverPlacement placement;
  final double offset;
  final bool barrierDismissible;
  final BorderRadius? borderRadius;
  final SoflumeThemeData theme;
  final VoidCallback onClose;
  final FocusNode triggerFocusNode;
  final Widget content;

  @override
  State<_SofPopoverOverlay> createState() => _SofPopoverOverlayState();
}

class _SofPopoverOverlayState extends State<_SofPopoverOverlay>
    with SingleTickerProviderStateMixin {
  late final FocusNode _overlayFocusNode;
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _overlayFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _overlayFocusNode.requestFocus();
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
    _overlayFocusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleDismiss() {
    widget.onClose();
  }

  Alignment _getTargetAnchor() {
    switch (widget.placement) {
      case SofPopoverPlacement.bottom:
        return Alignment.bottomLeft;
      case SofPopoverPlacement.top:
        return Alignment.topLeft;
      case SofPopoverPlacement.right:
        return Alignment.topRight;
      case SofPopoverPlacement.left:
        return Alignment.topLeft;
    }
  }

  Alignment _getFollowerAnchor() {
    switch (widget.placement) {
      case SofPopoverPlacement.bottom:
        return Alignment.topLeft;
      case SofPopoverPlacement.top:
        return Alignment.bottomLeft;
      case SofPopoverPlacement.right:
        return Alignment.topLeft;
      case SofPopoverPlacement.left:
        return Alignment.topRight;
    }
  }

  Offset _getFollowerOffset() {
    switch (widget.placement) {
      case SofPopoverPlacement.bottom:
        return Offset(0, widget.offset);
      case SofPopoverPlacement.top:
        return Offset(0, -widget.offset);
      case SofPopoverPlacement.right:
        return Offset(widget.offset, 0);
      case SofPopoverPlacement.left:
        return Offset(-widget.offset, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final radii = widget.theme.radii;
    final effectiveRadius = widget.borderRadius ?? radii.brLg;

    return Focus(
      focusNode: _overlayFocusNode,
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
          // Dismissible full-screen backdrop
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: widget.barrierDismissible ? _handleDismiss : null,
              child: const ColoredBox(color: Color(0x00000000)),
            ),
          ),

          // Scroll-following positioned popover content
          CompositedTransformFollower(
            link: widget.layerLink,
            showWhenUnlinked: false,
            targetAnchor: _getTargetAnchor(),
            followerAnchor: _getFollowerAnchor(),
            offset: _getFollowerOffset(),
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
}
