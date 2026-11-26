import 'dart:async';
import 'dart:collection';
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

    return Semantics(
      liveRegion: true,
      label: message,
      child: SofSurface(
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
      ),
    );
  }
}

class _ToastRequest {
  _ToastRequest({
    required this.overlayState,
    required this.theme,
    required this.message,
    required this.icon,
    required this.variant,
    required this.duration,
  });

  final OverlayState overlayState;
  final SoflumeThemeData theme;
  final String message;
  final Widget? icon;
  final SofBadgeVariant variant;
  final Duration duration;
}

/// Global manager for coordinating sequential animated Toast instances without overlap.
class _SofToastManager {
  static _SofToastManager? _instance;
  static _SofToastManager get instance => _instance ??= _SofToastManager();

  final Queue<_ToastRequest> _queue = Queue<_ToastRequest>();
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

    // Clean up stale entries if a previous overlay tree was disposed (e.g. route/app swap).
    if (_currentEntry != null && !_currentEntry!.mounted) {
      _currentEntry = null;
      _currentHandle = null;
      _queue.clear();
    }

    final theme = SoflumeTheme.of(context);
    final request = _ToastRequest(
      overlayState: overlayState,
      theme: theme,
      message: message,
      icon: icon,
      variant: variant,
      duration: duration,
    );

    if (_currentEntry != null) {
      if (_currentHandle?.onDismissRequested == null) {
        // Previous entry hasn't mounted a frame yet; replace it synchronously.
        if (_currentEntry!.mounted) {
          _currentEntry!.remove();
        }
        _currentEntry = null;
        _currentHandle = null;
        _queue.clear();
        _present(request);
        return;
      }
      // Keep only the latest pending request when triggered rapidly
      _queue.clear();
      _queue.add(request);
      _currentHandle?.dismiss();
      return;
    }

    _present(request);
  }

  void _present(_ToastRequest request) {
    if (!request.overlayState.mounted) {
      _advanceQueue();
      return;
    }

    late OverlayEntry entry;
    final handle = _SofToastAnimationHandle();
    _currentHandle = handle;

    void finishEntry() {
      if (entry.mounted) {
        entry.remove();
      }
      if (_currentEntry == entry) {
        _currentEntry = null;
        _currentHandle = null;
        _advanceQueue();
      }
    }

    entry = OverlayEntry(
      builder: (context) {
        return SoflumeTheme(
          data: request.theme,
          child: _SofToastOverlay(
            handle: handle,
            theme: request.theme,
            message: request.message,
            icon: request.icon,
            variant: request.variant,
            duration: request.duration,
            onDismissed: finishEntry,
            onDisposed: () {
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
    request.overlayState.insert(entry);
  }

  void _advanceQueue() {
    if (_queue.isNotEmpty) {
      final next = _queue.removeFirst();
      _present(next);
    }
  }
}

class _SofToastAnimationHandle {
  VoidCallback? onDismissRequested;
  bool dismissed = false;

  void dismiss() {
    dismissed = true;
    onDismissRequested?.call();
  }
}

class _SofToastOverlay extends StatefulWidget {
  const _SofToastOverlay({
    required this.handle,
    required this.theme,
    required this.message,
    required this.icon,
    required this.variant,
    required this.duration,
    required this.onDismissed,
    required this.onDisposed,
  });

  final _SofToastAnimationHandle handle;
  final SoflumeThemeData theme;
  final String message;
  final Widget? icon;
  final SofBadgeVariant variant;
  final Duration duration;
  final VoidCallback onDismissed;
  final VoidCallback onDisposed;

  @override
  State<_SofToastOverlay> createState() => _SofToastOverlayState();
}

class _SofToastOverlayState extends State<_SofToastOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _dismissTimer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    final motion = widget.theme.motion;
    _controller = AnimationController(
      vsync: this,
      duration: motion.getEffectiveDuration(motion.durationRegular),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: motion.reduceMotion ? Offset.zero : const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: motion.getEffectiveCurve(motion.springSettle),
      reverseCurve: Curves.easeIn,
    ));

    widget.handle.onDismissRequested = _triggerDismiss;

    if (widget.handle.dismissed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onDismissed();
      });
    } else {
      _controller.forward();
      _dismissTimer = Timer(widget.duration, _triggerDismiss);
    }
  }

  void _triggerDismiss() {
    if (_isDismissing) return;
    _isDismissing = true;
    _dismissTimer?.cancel();
    if (mounted && _controller.status != AnimationStatus.dismissed) {
      _controller.reverse().then((_) {
        if (mounted) {
          widget.onDismissed();
        }
      });
    } else if (mounted) {
      widget.onDismissed();
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    widget.onDisposed();
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
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if ((details.primaryVelocity ?? 0) < -150) {
                    _triggerDismiss();
                  }
                },
                child: SofToast(
                  message: widget.message,
                  icon: widget.icon,
                  variant: widget.variant,
                ),
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
/// Features smooth spring slide-down entrance, sequential queue coordination,
/// swipe-up dismissal, and automated exit animation.
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
