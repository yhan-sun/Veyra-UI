import 'package:flutter/widgets.dart';
import '../../foundation/theme/theme.dart';
import '../../primitives/focus_ring.dart';

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
    final radii = theme.radii;

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
          _BreadcrumbLink(
            label: item.label,
            borderRadius: radii.brXs,
            onTap: item.onTap!,
            child: content,
          ),
        );
      } else {
        children.add(content);
      }

      if (!isLast) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ExcludeSemantics(
              child: Text(
                separator,
                style: typography.caption.copyWith(
                  color: colors.contentSecondary.withValues(alpha: 0.5),
                ),
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

class _BreadcrumbLink extends StatefulWidget {
  const _BreadcrumbLink({
    required this.label,
    required this.borderRadius,
    required this.onTap,
    required this.child,
  });

  final String label;
  final BorderRadius borderRadius;
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_BreadcrumbLink> createState() => _BreadcrumbLinkState();
}

class _BreadcrumbLinkState extends State<_BreadcrumbLink> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: widget.label,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (focused) {
          if (mounted) setState(() => _isFocused = focused);
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: SofFocusRing(
            focused: _isFocused,
            borderRadius: widget.borderRadius,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
