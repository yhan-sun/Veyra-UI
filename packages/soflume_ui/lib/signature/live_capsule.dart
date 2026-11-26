import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../foundation/theme/theme.dart';
import '../primitives/focus_ring.dart';
import '../primitives/surface.dart';

/// Brand Signature: Dynamic interactive capsule for ongoing tasks, media, and system alerts.
class SofLiveCapsule extends StatefulWidget {
  const SofLiveCapsule({
    super.key,
    required this.leading,
    required this.title,
    this.trailing,
    this.expandedChild,
    this.initiallyExpanded = false,
    this.collapsedMaxWidth = 380.0,
    this.expandedMaxWidth = 440.0,
    this.onTap,
  });

  final Widget leading;
  final Widget title;
  final Widget? trailing;
  final Widget? expandedChild;
  final bool initiallyExpanded;
  final double collapsedMaxWidth;
  final double expandedMaxWidth;
  final VoidCallback? onTap;

  @override
  State<SofLiveCapsule> createState() => _SofLiveCapsuleState();
}

class _SofLiveCapsuleState extends State<SofLiveCapsule> {
  late bool _expanded;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void _handleTap() {
    if (widget.expandedChild != null) {
      HapticFeedback.lightImpact();
      setState(() => _expanded = !_expanded);
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    final isInteractive = widget.expandedChild != null || widget.onTap != null;
    final effectiveRadius = _expanded ? radii.brXl : radii.brPill;

    return Semantics(
      button: isInteractive,
      expanded: widget.expandedChild != null ? _expanded : null,
      child: FocusableActionDetector(
        enabled: isInteractive,
        mouseCursor: isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onShowFocusHighlight: (focused) {
          if (mounted) setState(() => _isFocused = focused);
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              if (isInteractive) _handleTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isInteractive ? _handleTap : null,
          child: SofFocusRing(
            focused: _isFocused,
            borderRadius: effectiveRadius,
            child: AnimatedContainer(
              duration: theme.motion.getEffectiveDuration(theme.motion.durationQuick),
              curve: theme.motion.getEffectiveCurve(theme.motion.springSnappy),
              constraints: BoxConstraints(
                maxWidth: _expanded ? widget.expandedMaxWidth : widget.collapsedMaxWidth,
              ),
              child: SofSurface(
                variant: SofSurfaceVariant.frost,
                borderRadius: effectiveRadius,
                padding: EdgeInsets.symmetric(
                  horizontal: _expanded ? 18 : 14,
                  vertical: _expanded ? 16 : 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: _expanded ? MainAxisSize.max : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconTheme(
                                data: IconThemeData(
                                  color: colors.accent,
                                  size: 18,
                                ),
                                child: widget.leading,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: DefaultTextStyle.merge(
                                  style: typography.label.copyWith(
                                    color: colors.contentPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  child: widget.title,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.trailing != null) ...[
                          const SizedBox(width: 10),
                          widget.trailing!,
                        ],
                      ],
                    ),
                    if (_expanded && widget.expandedChild != null) ...[
                      const SizedBox(height: 12),
                      widget.expandedChild!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
