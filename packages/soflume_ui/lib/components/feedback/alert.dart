import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../foundation/shapes/squircle_border.dart';
import 'badge.dart';

/// Semantic alert / notice banner card.
class SofAlert extends StatelessWidget {
  const SofAlert({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.variant = SofBadgeVariant.accent,
    this.onClose,
    this.action,
  });

  final Widget title;
  final Widget? message;
  final Widget? icon;
  final SofBadgeVariant variant;
  final VoidCallback? onClose;
  final Widget? action;

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

    final bgColor = themeColor.withValues(alpha: colors.isDark ? 0.16 : 0.08);
    final borderColor = themeColor.withValues(alpha: colors.isDark ? 0.35 : 0.25);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: SofSquircleBorder(
          borderRadius: radii.brMd,
          side: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(color: themeColor, size: 20),
              child: icon!,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle.merge(
                  style: typography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.contentPrimary,
                  ),
                  child: title,
                ),
                if (message != null) ...[
                  const SizedBox(height: 4),
                  DefaultTextStyle.merge(
                    style: typography.caption.copyWith(
                      color: colors.contentSecondary,
                    ),
                    child: message!,
                  ),
                ],
                if (action != null) ...[
                  const SizedBox(height: 8),
                  action!,
                ],
              ],
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClose,
              child: Text(
                '×',
                style: TextStyle(
                  color: colors.contentSecondary,
                  fontSize: 18,
                  height: 1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
