import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../foundation/theme/theme.dart';
import '../foundation/motion/spring_curve.dart';
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
    this.onTap,
  });

  final Widget leading;
  final Widget title;
  final Widget? trailing;
  final Widget? expandedChild;
  final bool initiallyExpanded;
  final VoidCallback? onTap;

  @override
  State<SofLiveCapsule> createState() => _SofLiveCapsuleState();
}

class _SofLiveCapsuleState extends State<SofLiveCapsule> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    if (widget.expandedChild == null) return;
    HapticFeedback.lightImpact();
    setState(() => _expanded = !_expanded);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final radii = theme.radii;

    return GestureDetector(
      onTap: _toggleExpanded,
      child: AnimatedContainer(
        duration: theme.motion.getEffectiveDuration(theme.motion.durationQuick),
        curve: const SofSpringCurve.snappy(),
        constraints: BoxConstraints(
          maxWidth: _expanded ? 380 : 260,
        ),
        child: SofSurface(
          variant: SofSurfaceVariant.frost,
          borderRadius: _expanded ? radii.brXl : radii.brPill,
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
    );
  }
}
