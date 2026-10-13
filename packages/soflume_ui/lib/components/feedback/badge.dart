import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';

/// Semantic color role for badges and tags.
enum SofBadgeVariant {
  accent,
  success,
  warning,
  danger,
  neutral,
}

/// A compact status or count indicator.
class SofBadge extends StatelessWidget {
  const SofBadge({
    super.key,
    this.label,
    this.variant = SofBadgeVariant.accent,
    this.child,
    this.offset = const Offset(6, -6),
    this.dot = false,
  });

  final Widget? label;
  final SofBadgeVariant variant;
  final Widget? child;
  final Offset offset;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    Color badgeColor;
    Color textColor = const Color(0xFFFFFFFF);

    switch (variant) {
      case SofBadgeVariant.accent:
        badgeColor = colors.accent;
        textColor = colors.onAccent;
        break;
      case SofBadgeVariant.success:
        badgeColor = colors.success;
        break;
      case SofBadgeVariant.warning:
        badgeColor = colors.warning;
        break;
      case SofBadgeVariant.danger:
        badgeColor = colors.danger;
        break;
      case SofBadgeVariant.neutral:
        badgeColor = colors.contentSecondary;
        break;
    }

    Widget badgeWidget;
    if (dot) {
      badgeWidget = Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: badgeColor,
          shape: BoxShape.circle,
        ),
      );
    } else {
      badgeWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: DefaultTextStyle.merge(
          style: typography.caption.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: textColor,
            height: 1.2,
          ),
          child: label ?? const SizedBox(),
        ),
      );
    }

    if (child == null) {
      return badgeWidget;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: offset.dy,
          right: -offset.dx,
          child: badgeWidget,
        ),
      ],
    );
  }
}
