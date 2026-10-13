import 'dart:async';
import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../primitives/surface.dart';
import '../feedback/badge.dart';

/// Floating toast pill notification.
class SofToast extends StatelessWidget {
  const SofToast({
    super.key,
    required this.message,
    this.icon,
    this.variant = SofBadgeVariant.accent,
  });

  final String message;
  final Widget? icon;
  final SofBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    Color themeColor;
    switch (variant) {
      case SofBadgeVariant.accent:
        themeColor = colors.accent;
        break;
      case SofBadgeVariant.success:
        themeColor = colors.success;
        break;
      case SofBadgeVariant.warning:
        themeColor = colors.warning;
        break;
      case SofBadgeVariant.danger:
        themeColor = colors.danger;
        break;
      case SofBadgeVariant.neutral:
        themeColor = colors.contentSecondary;
        break;
    }

    return SofSurface(
      variant: SofSurfaceVariant.floating,
      borderRadius: radii.brPill,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(color: themeColor, size: 18),
              child: icon!,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              message,
              overflow: TextOverflow.ellipsis,
              style: typography.body.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.contentPrimary,
                fontSize: 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Global manager for coordinating animated Toast instances.
class _SofToastManager {
  static _SofToastManager? _instance;
  static _SofToastManager get instance => _instance ??= _SofToastManager();

  OverlayEntry? _currentEntry;
  _SofToastAnimationHandle? _currentHandle;

  void show({
    required BuildContext context,
    required String message,
    Widget? icon,
    SofBadgeVariant variant = SofBadgeVariant.accent,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlayState = Overlay.maybeOf(context, rootOverlay: true);
    if (overlayState == null) return;

    final theme = SoflumeTheme.of(context);

    // Dismiss any existing toast with animation first
    _currentHandle?.dismiss();

    late OverlayEntry entry;
    final handle = _SofToastAnimationHandle();
    _currentHandle = handle;

    entry = OverlayEntry(
      builder: (context) {
        return SoflumeTheme(
          data: theme,
          child: _SofToastOverlay(
            handle: handle,
            message: message,
            icon: icon,
            variant: variant,
            duration: duration,
            onDismissed: () {
              if (entry.mounted) {
                entry.remove();
              }
              if (_currentEntry == entry) {
                _currentEntry = null;
                _currentHandle = null;
              }
            },
          ),
        );
      },
    );

    _currentEntry = entry;
    overlayState.insert(entry);
  }
}

class _SofToastAnimationHandle {
  VoidCallback? onDismissRequested;

  void dismiss() {
    onDismissRequested?.call();
  }
}

class _SofToastOverlay extends StatefulWidget {
  const _SofToastOverlay({
    required this.handle,
    required this.message,
    required this.icon,
    required this.variant,
    required this.duration,
    required this.onDismissed,
  });

  final _SofToastAnimationHandle handle;
  final String message;
  final Widget? icon;
  final SofBadgeVariant variant;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_SofToastOverlay> createState() => _SofToastOverlayState();
}

class _SofToastOverlayState extends State<_SofToastOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeIn,
    ));

    widget.handle.onDismissRequested = _triggerDismiss;

    _controller.forward();

    _dismissTimer = Timer(widget.duration, () {
      _triggerDismiss();
    });
  }

  void _triggerDismiss() {
    _dismissTimer?.cancel();
    if (mounted && _controller.status != AnimationStatus.dismissed) {
      _controller.reverse().then((_) {
        if (mounted) {
          widget.onDismissed();
        }
      });
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 16, right: 16),
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SofToast(
                message: widget.message,
                icon: widget.icon,
                variant: widget.variant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows a floating [SofToast] using animated [OverlayEntry].
///
/// Features smooth spring slide-down entrance, queue coordination,
/// and automated exit animation.
void showSofToast({
  required BuildContext context,
  required String message,
  Widget? icon,
  SofBadgeVariant variant = SofBadgeVariant.accent,
  Duration duration = const Duration(seconds: 3),
}) {
  _SofToastManager.instance.show(
    context: context,
    message: message,
    icon: icon,
    variant: variant,
    duration: duration,
  );
}
