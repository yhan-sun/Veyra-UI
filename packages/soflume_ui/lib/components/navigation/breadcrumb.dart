import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';

/// Item for breadcrumb trail navigation.
class SofBreadcrumbItem {
  const SofBreadcrumbItem({
    required this.label,
    this.icon,
    this.onTap,
  });

  final String label;
  final Widget? icon;
  final VoidCallback? onTap;
}

/// Accessible breadcrumb trail for deep navigation paths.
class SofBreadcrumb extends StatelessWidget {
  const SofBreadcrumb({
    super.key,
    required this.items,
    this.separator = '/',
  });

  final List<SofBreadcrumbItem> items;
  final String separator;

  @override
  Widget build(BuildContext context) {
    final theme = SoflumeTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final children = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLast = i == items.length - 1;

      final content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null) ...[
            IconTheme(
              data: IconThemeData(
                size: 14,
                color: isLast ? colors.contentPrimary : colors.contentSecondary,
              ),
              child: item.icon!,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            item.label,
            style: typography.caption.copyWith(
              color: isLast ? colors.contentPrimary : colors.contentSecondary,
              fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      );

      if (!isLast && item.onTap != null) {
        children.add(
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: item.onTap,
              child: content,
            ),
          ),
        );
      } else {
        children.add(content);
      }

      if (!isLast) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              separator,
              style: typography.caption.copyWith(
                color: colors.contentSecondary.withValues(alpha: 0.5),
              ),
            ),
          ),
        );
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
